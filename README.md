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

**Project Size:** 350 hours (medium)

---

## Integration with Open Robotics Projects

The project will integrate with the following OSRF repositories:

| Repository | Purpose |
|---|---|
| gz-sim | Simulation core integration and ECM improvements |
| sdformat | SDF parsing and validation |
| ros_gz_bridge | ROS2 ↔ Gazebo topic bridge |

**Initial PR targets:**
1. Documentation improvements for ECM (Entity Component Manager) components in gz-sim
2. Example world demonstrating URDF → SDF conversion
3. Bridge configuration templates for ros_gz_bridge

---

## Backward Compatibility Strategy

ROS2 ecosystems change frequently. This project will support:

| Target | Minimum Version |
|---|---|
| ROS2 Humble | 24.04 LTS |
| ROS2 Rolling | Latest |
| Gazebo Harmonic | 8.x |
| Gazebo Garden | 7.x |

---

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
## Real Code Examples

### Python API Example

```python
from sdf_parser import parse_sdf

model = parse_sdf("robot.sdf")
print(model.links)
print(model.joints)
```

### CLI Example

```bash
urdf2sdf robot.urdf -o robot.sdf
```

---

## Schema Mapping: URDF ↔ SDF

URDF to SDF conversion maps elements as follows:

| URDF Element | SDF Equivalent |
|---|---|
| `link` | `link` |
| `joint` | `joint` |
| `transmission` | `plugin` (gazebo_ros_control) |
| `gazebo` tag | `model/plugin` |
| `inertial` | `inertial` |
| `collision` | `collision` |
| `visual` | `visual` |

**Unsupported/Partially Supported:** URDF `material` color names (requires texture lookup), certain joint types not in SDF.

---

## Example CLI Output

```text
$ urdf2sdf robot.urdf

✔ Parsed URDF (3 links, 2 joints)
✔ Converted links
✔ Converted joints
✔ Generated SDF

Output: robot.sdf
```

---

## Logging System

The CLI supports multiple verbosity levels:

- `--verbose` - Print detailed parsing steps
- `--debug` - Full debug output including intermediate representations
- `--quiet` - Only show errors and warnings

Example: `urdf2sdf robot.urdf -o robot.sdf --verbose`

---

## Visualization Support

Preview converted models before finalizing:

```bash
urdf2sdf robot.urdf --visualize
```

Opens a Gazebo preview with the converted model loaded.

---

## Memory Usage Plan

The parser is designed for efficiency:

- Memory footprint < 100MB for large robot models
- Streaming parsing for very large files
- Efficient data structures (O(1) link/joint lookups)

---

## Plugin Conversion Strategy

Gazebo plugins are handled as follows:

| URDF Plugin | SDF/ROS Bridge Equivalent |
|---|---|
| `gazebo_ros_control` | `ros_gz_bridge` + SDF `<plugin>` |
| Custom plugins | Ported to SDF plugin format |

Custom plugin detection and conversion templates will be provided.

---

## Multi-Robot Simulation Support

The tool supports spawning multiple robots:

```python
from sdf_parser import parse_sdf, create_world

world = create_world()
world.spawn(parse_sdf("robot1.sdf"))
world.spawn(parse_sdf("robot2.sdf"))
world.save("multi_robot.sdf")
```

---
## Simulation Test Pipeline

The project will validate conversion through an automated pipeline:

```
URDF file → convert → SDF → Gazebo → spawn robot → verify joints → report
```

The `test_simulation.sh` script will:
- Parse URDF and convert to SDF
- Load the SDF in Gazebo headless mode
- Verify joint positions and link connections
- Report conversion accuracy

---

## Real Robot Model Validation

The tool will be tested against well-known robot models:

| Model | Source | Purpose |
|---|---|---|
| TurtleBot3 | Official ROS2 | Small mobile robot |
| Fetch Robot | Fetch Robotics | Mobile manipulator |
| PR2 | Willow Garage | Dual-arm manipulation |
| UR5 arm | Universal Robots | Industrial arm |

Each model will be tested for full conversion fidelity.

---

## Real Benchmark Plan

**Benchmark dataset:** 10+ robot models of varying complexity

- Measure conversion time (target: < 500ms for most models)
- Measure SDF output correctness (joint/link counts match URDF)
- Gazebo load time comparison

---

## Documentation Website

The project will include a docs/ directory with:

- `install.md` - Installation instructions
- `converter.md` - CLI and API documentation
- `examples.md` - Worked examples and tutorials

Deployed via **GitHub Pages** for public access.

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


## Maintainability Plan

The project will follow these long-term maintenance practices:

- **Modular architecture** - Separation of parsing, conversion, and CLI layers
- **Clear API boundaries** - Stable public interfaces, internal flexibility
- **Type hints** - Full Python type annotations for maintainability
- **Extensive documentation** - Docstrings, README, and hosted docs
- **Backwards compatibility** - Semantic versioning with clear deprecation paths

---

## Code Quality Tools

The development workflow will use:

- `black` - Code formatting
- `ruff` - Linting
- `mypy` - Static type checking
- `pre-commit` - Git hooks

```bash
pre-commit install
```

---

## Release Strategy

The project will use **Semantic Versioning**:

| Version | Milestone |
|---|---|
| 0.1.0 | MVP - Basic URDF to SDF conversion |
| 0.5.0 | Stable converter with plugin support |
| 1.0.0 | Production release with full test coverage |

---

## Community Support Plan

Users can seek help through:

- **GitHub Issues** - Bug reports and feature requests
- **ROS Discourse** - General questions and discussions
- **Gazebo community forum** - Simulation-specific issues

---

## Code Ownership

A `CODEOWNERS` file will define:

```
/parser @strangerwhoisharborofdoom
/docs @strangerwhoisharborofdoom
/tests @strangerwhoisharborofdoom
```

---

## Research Contributions

This work contributes to **robotics model format interoperability** - a recognized challenge in the ROS community. By providing reliable URDF to SDF conversion with comprehensive testing, the project enables:

- Faster robot model integration across simulation tools
- Reduced friction in ROS 2 + Gazebo workflows
- Academic research in format conversion accuracy and completeness

---
