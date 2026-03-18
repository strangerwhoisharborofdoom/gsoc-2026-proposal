FROM ros:humble

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3-colcon-common-extensions \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Clone the gazebo-ros2-bridge-simulator repo
RUN git clone https://github.com/strangerwhoisharborofdoom/gazebo-ros2-bridge-simulator.git

WORKDIR /workspace/gazebo-ros2-bridge-simulator

# Build the workspace
RUN /bin/bash -lc "source /opt/ros/humble/setup.bash && colcon build --symlink-install"

# Copy the run_demo script
COPY run_demo.sh /workspace/run_demo.sh
RUN chmod +x /workspace/run_demo.sh

ENTRYPOINT ["/workspace/run_demo.sh"]
