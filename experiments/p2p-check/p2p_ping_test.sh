#!/bin/bash

# Network connectivity test script
# Usage: ./connectivity_test.sh [cluster]
# cluster: specify either 'a' or 'b'

CLUSTER=$1
WAIT_SECONDS=2

if [ -z "$CLUSTER" ]; then
    echo "Usage: $0 [cluster]"
    echo "cluster: Please specify either 'a' or 'b'."
    exit 1
fi

# Cluster-specific configuration
if [ "$CLUSTER" = "a" ]; then
    NODE_PREFIX="a"
    NODE_START=1
    NODE_END=70  # Adjusted for cluster 'a'
    NETWORK_SEGMENTS=("10.1.0" "10.2.0" "10.3.0" "10.4.0")  # Updated for cluster 'a'
elif [ "$CLUSTER" = "b" ]; then
    NODE_PREFIX="b"
    NODE_START=1
    NODE_END=30  # Adjusted for cluster 'b'
    NETWORK_SEGMENTS=("10.5.0" "10.6.0" "10.7.0" "10.8.0")  # Unchanged for cluster 'b'
else
    echo "Invalid cluster name: $CLUSTER"
    exit 1
fi

# Calculate the number of nodes
NODES_COUNT=$((NODE_END - NODE_START + 1))
NODE_NUM=$NODES_COUNT  # Total number of nodes
HALF_NODES=$((NODE_NUM / 2))

# Save the results in the data/ directory
OUTPUT_FILE="data/${CLUSTER}_cluster_connectivity.csv"

# Create the header for the result file
echo "SourceNode,SourceIP,DestinationNode,DestinationIP,NetworkSegment,Status" > $OUTPUT_FILE

# SSH options with multiplexing enabled to keep connections open
SSH_OPTS="-o BatchMode=yes -o ConnectTimeout=5 -o ControlMaster=auto -o ControlPath=~/.ssh/cm-%r@%h:%p -o ControlPersist=600"

# Generate all unique pairs of nodes without repeats
PAIRS=()
for (( i=NODE_START; i<=NODE_END; i++ )); do
    for (( j=i+1; j<=NODE_END; j++ )); do
        PAIRS+=("$i,$j")
    done
done

for (( i=NODE_START; i<=NODE_END; i++ )); do
    for (( j=i+1; j<=NODE_END; j++ )); do
        PAIRS+=("$j,$i")
    done
done

TOTAL_PAIRS=${#PAIRS[@]}

echo "Total pairs generated: $TOTAL_PAIRS"  # Debug message

# Calculate the number of batches
BATCH_COUNT=$((NODE_NUM - 1))
echo "Total batches: $BATCH_COUNT"  # Debug message

# Generate batches by selecting pairs at intervals of NODE_NUM - 1
declare -a BATCHES
for (( b=0; b<BATCH_COUNT; b++ )); do
    BATCHES[$b]=""
done

for (( index=0; index<TOTAL_PAIRS; index++ )); do
    batch_index=$(( index % (NODE_NUM - 1) ))
    BATCHES[$batch_index]="${BATCHES[$batch_index]} ${PAIRS[$index]}"
done

# Display batch contents for debugging
for (( b=0; b<BATCH_COUNT; b++ )); do
    echo "Batch $((b+1)): ${BATCHES[$b]}"
done

# Process the pairs in batches
BATCH_NUMBER=1
for BATCH_CONTENT in "${BATCHES[@]}"; do
    echo "Processing batch $BATCH_NUMBER"
    # Debug message for the batch being processed
    echo "Batch content: $BATCH_CONTENT"

    # Split the batch into pairs
    IFS=' ' read -r -a BATCH_PAIRS <<< "$BATCH_CONTENT"

    # Process pairs in parallel within the batch
    for PAIR in "${BATCH_PAIRS[@]}"; do
        (
        # Extract source and destination node numbers
        IFS=',' read SOURCE_NODE_NUM DEST_NODE_NUM <<< "$PAIR"

        # Debug message for the pair
        echo "Testing pair: Source node $SOURCE_NODE_NUM, Destination node $DEST_NODE_NUM"

        # Format node numbers to 3 digits
        SOURCE_NODE="${NODE_PREFIX}$(printf "%03d" $SOURCE_NODE_NUM)-gw"
        DEST_NODE="${NODE_PREFIX}$(printf "%03d" $DEST_NODE_NUM)-gw"

        TEMP_OUTPUT="/tmp/${SOURCE_NODE}_${DEST_NODE}_connectivity.tmp"

        echo "Running ping from $SOURCE_NODE to $DEST_NODE"

        # Connect via SSH and run ping tests over remote shell
        ssh $SSH_OPTS $SOURCE_NODE bash -s << EOF > $TEMP_OUTPUT
NODE_NUM="$SOURCE_NODE_NUM"
DEST_NODE_NUM="$DEST_NODE_NUM"
SOURCE_NODE="$SOURCE_NODE"
DEST_NODE="$DEST_NODE"

# Test within the same network segment
for NET in ${NETWORK_SEGMENTS[@]}; do
    SOURCE_IP="\$NET.\$NODE_NUM"
    DEST_IP="\$NET.\$DEST_NODE_NUM"
    ping -c 1 -W 1 -I "\$SOURCE_IP" "\$DEST_IP" > /dev/null 2>&1
    if [ \$? -eq 0 ]; then
        STATUS="Success"
    else
        STATUS="Failure"
    fi
    echo "\$SOURCE_NODE,\$SOURCE_IP,\$DEST_NODE,\$DEST_IP,\$NET,\$STATUS"
done

# Cross-segment ping test
for SOURCE_NET in ${NETWORK_SEGMENTS[@]}; do
    SOURCE_IP="\$SOURCE_NET.\$NODE_NUM"
    for DEST_NET in ${NETWORK_SEGMENTS[@]}; do
        DEST_IP="\$DEST_NET.\$DEST_NODE_NUM"
        ping -c 1 -W 1 -I "\$SOURCE_IP" "\$DEST_IP" > /dev/null 2>&1
        if [ \$? -eq 0 ]; then
            STATUS="Success"
        else
            STATUS="Failure"
        fi
        echo "\$SOURCE_NODE,\$SOURCE_IP,\$DEST_NODE,\$DEST_IP,\$SOURCE_NET->\$DEST_NET,\$STATUS"
    done
done
EOF

        ) &
    done

    wait  # Wait for all background processes in the batch to finish

    # Sleep for $WAIT_SECONDS seconds before starting the next batch
    echo "Batch $BATCH_NUMBER complete. Sleeping for $WAIT_SECONDS seconds..."
    sleep $WAIT_SECONDS
    BATCH_NUMBER=$((BATCH_NUMBER + 1))

done

# Combine temporary files into the result file
echo "Combining results into $OUTPUT_FILE"  # Debug message for result file
for TEMP_FILE in /tmp/*_connectivity.tmp; do
    if [ -f "$TEMP_FILE" ]; then
        cat "$TEMP_FILE" >> $OUTPUT_FILE
        rm -f "$TEMP_FILE"
    fi
done

echo "Connectivity test completed. The results have been saved in $OUTPUT_FILE."
