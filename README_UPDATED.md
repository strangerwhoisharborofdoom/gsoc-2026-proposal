# Google Summer of Code 2026 Proposal — README (Updated)

**One-line summary:** Improve Gazebo–ROS 2 interoperability by delivering a robust SDF/URDF conversion & validation toolchain, an enhanced Gazebo-ROS2 bridge, and thorough tutorials to speed up simulation workflows for ROS 2 users.

## Important additions
- License: Apache-2.0 (see LICENSE.md)
- CONTRIBUTING: CONTRIBUTING.md
- Code of Conduct: CODE_OF_CONDUCT.md
- CI workflow: .github/workflows/ci.yml (placeholder)
- Dockerfile: minimal Dockerfile to reproduce demo

## Suggested maintainers / mentors
I will engage maintainers of Gazebo and ROS 2 projects during community bonding. Suggested targets:
- Gazebo / gz-sim maintainers — https://github.com/osrf/gz-sim
- Gazebo physics maintainers — https://github.com/osrf/gz-physics
- ROS 2 integration maintainers — https://github.com/ros2

## Getting started (quick)
Tested with: ROS 2 Humble (minimal)

1. Clone the repo and related projects:
```bash
git clone https://github.com/strangerwhoisharborofdoom/gsoc-2026-proposal.git
git clone https://github.com/strangerwhoisharborofdoom/gazebo-ros2-bridge-simulator.git
```
2. Build (example):
```bash
cd gazebo-ros2-bridge-simulator
colcon build --symlink-install
source install/setup.bash
ros2 launch gz_sim_examples warehouse_launch.py
```

Docker fallback (minimal):
```bash
docker build -t gz-sim-demo:latest .
docker run --rm -it --network host gz-sim-demo:latest /bin/bash
```

## Contact
Preferred: GitHub issues on this repo or p00731100@gmail.com
Timezone: IST (UTC+05:30)

---

(Full README content should replace the main README — README_UPDATED.md is a working draft.)
