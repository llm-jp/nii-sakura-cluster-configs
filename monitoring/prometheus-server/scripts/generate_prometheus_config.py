import argparse
import os

def generate_prometheus_config(job_name, port, file_name):
    ip_list_a = [f"192.168.0.{i}:{port}" for i in range(1, 71)]
    ip_list_b = [f"192.168.0.{i}:{port}" for i in range(101, 131)]
    instance_names_a = [f"a{i:03d}" for i in range(1, 71)]
    instance_names_b = [f"b{i:03d}" for i in range(1, 31)]

    output_dir = "./prometheus"
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    output_path = os.path.join(output_dir, file_name)

    with open(output_path, 'w') as f:
        for i, ip in enumerate(ip_list_a):
            f.write(f"- targets:\n    - \"{ip}\"\n")
            f.write(f"  labels:\n    job: {job_name}\n    instance_name: \"{instance_names_a[i]}\"\n")
        for i, ip in enumerate(ip_list_b):
            f.write(f"- targets:\n    - \"{ip}\"\n")
            f.write(f"  labels:\n    job: {job_name}\n    instance_name: \"{instance_names_b[i]}\"\n")

    print(f"Configuration file '{file_name}' has been generated at '{output_dir}'.")


def main():
    parser = argparse.ArgumentParser(description="Generate Prometheus config file.")
    parser.add_argument('-P', '--port', type=int, default=9100, help='Port number to use for targets')
    parser.add_argument('-n', '--job_name', type=str, required=True, help='Job name to use in the config')
    parser.add_argument('-o', '--file_name', type=str, required=True, help='Output file name')

    args = parser.parse_args()

    generate_prometheus_config(args.job_name, args.port, args.file_name)

if __name__ == "__main__":
    main()
