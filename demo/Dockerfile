# Docker demo for URDF→SDF converter
# Usage: docker build -t gz-demo . && docker run --rm -it gz-demo
FROM osrf/ros:humble-desktop

RUN apt-get update && apt-get install -y \
    python3-colcon-common-extensions python3-pip git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
COPY . /workspace

# Install Python dependencies
RUN pip3 install -r requirements.txt || true

# Setup entrypoint
COPY demo/run_demo.sh /workspace/run_demo.sh
RUN chmod +x /workspace/run_demo.sh
ENTRYPOINT ["/workspace/run_demo.sh"]
