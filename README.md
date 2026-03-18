<div align="center">

![GSoC 2026](https://img.shields.io/badge/GSoC-2026-ff69b4?style=for-the-badge&logo=google&logoColor=white)
![Open Robotics](https://img.shields.io/badge/Open%20Robotics-ROS%202-blue?style=for-the-badge&logo=ros&logoColor=white)
![Gazebo](https://img.shields.io/badge/Gazebo-Simulation-orange?style=for-the-badge)
![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)
![CI](https://github.com/strangerwhoisharborofdoom/gsoc-2026-proposal/actions/workflows/ci.yml/badge.svg)

</div>

# Google Summer of Code 2026 Proposal
## Enhanced Gazebo-ROS 2 Integration and Simulation Tools

**Applicant:** Pavan C N (@strangerwhoisharborofdoom)  
**Organization:** Open Robotics  
**Timeline:** May - August 2026  
**Timezone:** IST (UTC+05:30)

---

**One-line summary:** Improve Gazebo-ROS 2 interoperability by delivering a robust SDF/URDF conversion & validation toolchain, an enhanced Gazebo-ROS2 bridge, and thorough tutorials to speed up simulation workflows for ROS 2 users.

**Why Open Robotics / OSRF:** This project directly improves Gazebo and ROS 2 interoperability —

---

## MVP (Minimum Viable Product)

- **`urdf2sdf` CLI** that converts a simple robot model with meshes and preserves joints.
- **`sdf-parser` library** with tests and one example.
- **One PR** implementing integration code to an OSRF repo (placeholder).
- **Documentation:** 2 tutorials (install + conversion example).

## Stretch Goals

- Bidirectional conversion (`sdf2urdf`) with physics property preservation.
- Multi-robot sync in the Gazebo-ROS2 bridge.
- 5+ tutorials and CI integration tests across repositories.

---

## Getting Started (5-10 minute demo)

### Docker (fastest)

```bash
# build
docker build -t gz-sim-demo:latest .

# run (starts a minimal demo and exits after showing topic output)
docker run --rm --network host gz-sim-demo:latest /bin/bash -lc "source /opt/ros/humble/setup.bash && echo 'ROS 2 Humble ready' && ros2 topic list"
```

### Local (if you have ROS 2 Humble)

```bash
git clone https://github.com/strangerwhoisharborofdoom/gazebo-ros2-bridge-simulator.git
cd gazebo-ros2-bridge-simulator
colcon build --symlink-install
source install/setup.bash
ros2 launch gz_sim_examples warehouse_launch.py
# in another terminal: ros2 topic echo /example/topic
```

---

## How a mentor can reproduce results in 5 minutes

1. Install Docker (if not installed).
2. `git clone https://github.com/strangerwhoisharborofdoom/gsoc-2026-proposal.git`
3. `cd gsoc-2026-proposal`
4. `docker build -t gz-sim-demo:latest .`
5. `docker run --rm -it --network host gz-sim-demo:latest` — this runs a minimal Gazebo headless demo and prints available ROS 2 topics.
6. Check `ros2 topic list` output inside the container.

---

## Suggested Maintainers / Mentors

I will engage maintainers from the Gazebo and ROS 2 projects during community bonding. Suggested targets:

- **Gazebo / gz-sim maintainers** — https://github.com/osrf/gz-sim
- **Gazebo physics maintainers** — https://github.com/osrf/gz-physics
- **ROS 2 integration maintainers** — https://github.com/ros2

**Planned outreach:** I will open an initial issue in each target repository during the community bonding period and request feedback and a possible mentor contact.

**Outreach template:**
> Hi maintainers — I'm Pavan (@strangerwhoisharborofdoom). I'm applying to GSoC with a project to improve URDF-SDF conversion and Gazebo-ROS2 bridging. I'd appreciate guidance on which repo/maintainers I should talk to and if someone could review an initial issue/PR during bonding. Thank you!

---

## Timeline

| Phase | Timeline | Deliverable | Status | Issue |
|-------|----------|-------------|--------|-------|
| Community Bonding | May 2026 | Identify maintainers, open issues, finalize spec | Planned | TBD |
| Phase 1 | June 2026 (Weeks 1-2) | `urdf2sdf` CLI MVP | Planned | TBD |
| Phase 2 | June 2026 (Weeks 3-4) | `sdf-parser` core implementation | Planned | TBD |
| Phase 3 | July 2026 (Weeks 1-2) | Gazebo-ROS2 bridge improvements | Planned | TBD |
| Phase 4 | July 2026 (Weeks 3-4) | Tutorials + documentation | Planned | TBD |
| Mid-term | Late July 2026 | Demo + progress review | Planned | TBD |
| Phase 5 | August 2026 | Stretch goals + polish | Planned | TBD |
| Final | Late August 2026 | Final deliverables | Planned | TBD |

---

## PR / Issue Table

| # | Repository | Issue | PR | Description | Status |
|---|------------|-------|----|-------------|--------|
| 1 | gz-sim | - | [osrf/gz-sim#3367](https://github.com/osrf/gz-sim/pull/3367) | ECM Documentation - Entity Component Manager complexity | Open |
| 2 | gazebo-ros2-bridge-simulator | - | - | Bridge simulator project (personal repo) | Done |
| 3 | sdf-parser | TBD | TBD | Core SDF parsing library | Planned |
| 4 | urdf-sdf-converter | TBD | TBD | URDF to SDF conversion CLI | Planned |


## Placeholder Issues (Mapped to Timeline)

These issues are tracked in this repo and reference the upstream Open Robotics repositories:

| # | Issue | Milestone | Related Repo | Status |
|---|-------|-----------|--------------|--------|
| [#1](https://github.com/strangerwhoisharborofdoom/gsoc-2026-proposal/issues/1) | Set up project infrastructure and SDF parser foundation | Community Bonding / Week 1-2 | [sdf-parser](https://github.com/open-rmf/sdf-parser) | Open |
| [#2](https://github.com/strangerwhoisharborofdoom/gsoc-2026-proposal/issues/2) | Implement URDF-to-SDF conversion logic | Phase 1 / Week 3-5 | [urdf-sdf-converter](https://github.com/open-rmf/urdf-sdf-converter) | Open |
| [#3](https://github.com/strangerwhoisharborofdoom/gsoc-2026-proposal/issues/3) | Build Gazebo ROS 2 bridge simulator integration | Phase 2 / Week 6-9 | [gazebo-ros2-bridge-simulator](https://github.com/open-rmf/gazebo-ros2-bridge-simulator) | Open |
| [#4](https://github.com/strangerwhoisharborofdoom/gsoc-2026-proposal/issues/4) | Add documentation and developer guide | Phase 3 / Week 10-12 | All repos | Open |
| [#5](https://github.com/strangerwhoisharborofdoom/gsoc-2026-proposal/issues/5) | Final evaluation, polish, and submission preparation | Final Phase / Week 13 | All repos | Open |




---

## Project Repositories

- **sdf-parser**: https://github.com/strangerwhoisharborofdoom/sdf-parser
- **urdf-sdf-converter**: https://github.com/strangerwhoisharborofdoom/urdf-sdf-converter
- **gazebo-ros2-bridge-simulator**: https://github.com/strangerwhoisharborofdoom/gazebo-ros2-bridge-simulator
- **gsoc-2026-proposal**: https://github.com/strangerwhoisharborofdoom/gsoc-2026-proposal (this repo)

---

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for details.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## Code of Conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

---

*Full proposal details available in the [proposal document](PROPOSAL.md) and the [100 changes recommendations](100_changes_recommendations.md).* core components maintained by Open Robotics. Delivering robust conversion tools and bridge improvements reduces friction for the Gazebo + ROS 2 developer community and aligns with OSRF's mission.
