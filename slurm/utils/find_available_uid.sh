#!/bin/bash

# The starting UID, received as the first command line argument
START_UID=$1

if [[ -z "$START_UID" ]]; then
  echo "Please provide a starting UID as an argument."
  exit 1
fi

# Function to check if a UID is already in use
is_uid_in_use() {
  uid=$1
  if grep -q "^.*:.*:$uid:" /etc/passwd; then
    return 0  # UID is in use
  else
    return 1  # UID is not in use
  fi
}

# Loop starting from START_UID to find the first unused UID
current_uid=$START_UID
while true; do
  if ! is_uid_in_use $current_uid; then
    echo "First available UID after $START_UID is: $current_uid"
    break
  fi
  ((current_uid++))
done

