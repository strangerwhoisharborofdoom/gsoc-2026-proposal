FROM ros:humble

# Minimal Dockerfile - user should expand for full demo
RUN apt-get update && apt-get install -y git python3-colcon-common-extensions
WORKDIR /workspace
