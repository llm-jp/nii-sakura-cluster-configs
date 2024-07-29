# https://docs.docker.com/engine/install/rhel/
# Set up the repository
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

# Install Docker Engine
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# If prompted to accept the GPG key, verify that the fingerprint matches `060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35``, and if so, accept it.

# Start Docker.
sudo systemctl start docker

# Verify that the Docker Engine installation is successful by running the hello-world image.
sudo docker run hello-world
