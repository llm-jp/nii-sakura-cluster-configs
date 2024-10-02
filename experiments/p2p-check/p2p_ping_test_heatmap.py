import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import os
import numpy as np

# Function to load and process the CSV data
def load_connectivity_data(cluster):
    file_path = f"data/{cluster}_cluster_connectivity.csv"
    if not os.path.exists(file_path):
        print(f"File {file_path} not found.")
        return None

    # Read the CSV file
    df = pd.read_csv(file_path)

    # Split the NetworkSegment column if it contains '->' and create separate source and destination segments
    df['SourceNetworkSegment'] = df['NetworkSegment'].str.split('->').str[0]
    df['DestinationNetworkSegment'] = df['NetworkSegment'].str.split('->').str[1].fillna(df['SourceNetworkSegment'])

    # Create a pivot table: rows are (SourceNode, SourceNetworkSegment),
    # columns are (DestinationNode, DestinationNetworkSegment)
    pivot_table = df.pivot_table(index=['SourceNode', 'SourceNetworkSegment'],
                                 columns=['DestinationNode', 'DestinationNetworkSegment'],
                                 values='Status',
                                 aggfunc=lambda x: 1 if 'Success' in x.values else -1)

    # Keep NaN values as NaN (which will be represented as white in the heatmap)
    return pivot_table

# Function to save the heatmap as an image
def save_heatmap(data, cluster):
    plt.figure(figsize=(24, 20))  # Set the figure size

    # Define the color map: -1 (Failure) = red, 1 (Success) = blue, NaN = white
    cmap = sns.color_palette(['red', 'white', 'blue'], as_cmap=True)

    # Plot the heatmap with color mapping and NaN values as white
    sns.heatmap(data, annot=False, cmap=cmap, cbar=True, linewidths=.5,
                linecolor='grey', mask=data.isnull(), vmin=-1, vmax=1,
                square=True)

    # Set title and labels
    plt.title(f'Network Connectivity Heatmap - Cluster {cluster}')
    plt.xlabel('Destination (Node, NetworkSegment)')
    plt.ylabel('Source (Node, NetworkSegment)')

    # Save the plot as an image in the img/ directory
    img_dir = 'img'
    if not os.path.exists(img_dir):
        os.makedirs(img_dir)
    file_path = os.path.join(img_dir, f'cluster_{cluster}_connectivity_heatmap.png')
    plt.savefig(file_path)
    plt.close()  # Close the figure to avoid display

# Load data for cluster 'a' and 'b'
for cluster in ['a', 'b']:
    data = load_connectivity_data(cluster)
    if data is not None:
        save_heatmap(data, cluster)
