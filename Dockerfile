# Start from NVIDIA CUDA base image
FROM nvidia/cuda:12.4.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install Python, pip, and Docker
RUN apt-get update && apt-get install -y \
    python3 python3-pip python-is-python3 \
    apt-transport-https ca-certificates curl gnupg lsb-release \
    software-properties-common wget git \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
       | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io \
    && apt-get clean

# Install Python libraries
RUN pip install --upgrade pip && \
    pip install jupyterlab && \
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

# Copy and set entrypoint script
COPY dockerd-entrypoint.sh /usr/local/bin/dockerd-entrypoint.sh
RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh

# Expose Docker daemon port & Jupyter port
EXPOSE 2375 8888

# Start Docker and Jupyter
CMD ["/usr/local/bin/dockerd-entrypoint.sh"]
