import os
import matplotlib.pyplot as plt
import numpy as np
import glob
from matplotlib.colors import ListedColormap
import argparse

# Function to generate the communication matrix
def generate_communication_matrix(base_dir, output_image_path):
    # Create a 16x16 matrix to represent the communication statuses
    matrix = np.full((16, 16), 0)  # 0: white, 1: red, 2: blue

    # Iterate over all possible pairs (excluding self-communication)
    for sender in range(16):
        for receiver in range(16):
            if sender == receiver:
                # Skip self-communication
                continue

            # Construct the filename pattern based on sender and receiver
            file_pattern = f'p2p-test-{sender}-{receiver}-*.out'
            file_path = os.path.join(base_dir, file_pattern)

            # Search for the file
            files = glob.glob(file_path)

            if not files:
                # If no file is found, keep the cell white (0)
                matrix[sender, receiver] = 0
            else:
                # Read the content of the first matched file
                with open(files[0], 'r') as file:
                    content = file.read()
                    if 'fail' in content:
                        # If 'fail' is found, mark as red (1)
                        matrix[sender, receiver] = 1
                    else:
                        # If 'fail' is not found, mark as blue (2)
                        matrix[sender, receiver] = 2

    # Plotting the matrix
    fig, ax = plt.subplots(figsize=(8, 8))

    # Create a color map: 0 -> white, 1 -> red, 2 -> blue
    cmap = ListedColormap(['white', 'red', 'blue'])

    # Display the matrix as a colored grid with square cells
    cax = ax.imshow(matrix, cmap=cmap, aspect='equal')

    # Add gridlines and labels
    ax.set_xticks(np.arange(16))
    ax.set_yticks(np.arange(16))
    ax.set_xticks(np.arange(-0.5, 16, 1), minor=True)
    ax.set_yticks(np.arange(-0.5, 16, 1), minor=True)
    ax.set_xticklabels(range(16))
    ax.set_yticklabels(range(16))
    ax.set_xlabel('Receiver')
    ax.set_ylabel('Sender')

    # Show the gridlines
    ax.grid(which='minor', color='black', linestyle='-', linewidth=1)

    # Add title
    ax.set_title('[IB] P2P Communication Status Matrix')

    # Save the plot as an image
    plt.savefig(output_image_path, dpi=300)

    # Close the plot to free up memory
    plt.close(fig)

    print(f"Image saved at {output_image_path}")

# Main function to parse arguments
def main():
    parser = argparse.ArgumentParser(description='Generate P2P communication matrix from log files.')

    # Add argument for the base directory
    parser.add_argument('base_dir', type=str, help='Base directory where the log files are located')

    # Get the current script's directory to save the image in img/ folder
    current_dir = os.path.dirname(os.path.abspath(__file__))
    output_image_path = os.path.join(current_dir, 'img', 'ib_p2p_communication_matrix.png')

    args = parser.parse_args()

    # Create img/ directory if it doesn't exist
    os.makedirs(os.path.join(current_dir, 'img'), exist_ok=True)

    # Call the function to generate the matrix
    generate_communication_matrix(args.base_dir, output_image_path)

if __name__ == '__main__':
    main()
