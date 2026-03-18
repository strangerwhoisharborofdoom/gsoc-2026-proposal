#!/bin/bash
set -e

echo "=== GSoC 2026 Demo: Gazebo-ROS 2 Integration ==="

source /opt/ros/humble/setup.bash
source /workspace/gazebo-ros2-bridge-simulator/install/setup.bash || true

echo ""
echo "ROS 2 topics available:"
ros2 topic list

echo ""
echo "Demo completed. Use 'docker exec -it <container> bash' for interactive shell."
echo ""
echo "To view topics: docker exec -it <container> ros2 topic echo <topic>"

# Keep container alive for debugging
tail -f /dev/null
