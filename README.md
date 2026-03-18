<div align="center">

![GSoC 2026](https://img.shields.io/badge/GSoC-2026-ff69b4?style=for-the-badge&logo=google&logoColor=white)
![Open Robotics](https://img.shields.io/badge/Open%20Robotics-ROS%202-blue?style=for-the-badge&logo=ros&logoColor=white)
![Gazebo](https://img.shields.io/badge/Gazebo-Simulation-orange?style=for-the-badge)
![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)
![CI](https://github.com/strangerwhoisharborofdoom/gsoc-2026-proposal/actions/workflows/ci.yml/badge.svg)

</div>

# Google Summer of Code 2026 Proposal

## Enhanced Gazebo-ROS 2 Integration and Simulation Tools

| | |
|---|---|
| **Applicant** | Pavan C N (@strangerwhoisharborofdoom) |
| **Organization** | Open Robotics |
| **Timeline** | May - August 2026 |
| **Timezone** | IST (UTC+05:30) |
| **Project Size** | 350 hours (medium) |

---

## 1. Executive Summary

**One-line summary:** Improve Gazebo-ROS 2 interoperability by delivering a robust SDF/URDF conversion & validation toolchain.

This project proposes a toolkit for converting URDF robot models into SDF to improve interoperability between ROS 2 and Gazebo simulations. The toolkit will include:

- **URDF → SDF converter** — Reliable bidirectional conversion between URDF and SDF formats
- **SDF validation tools** — Automatic validation using sdformat library
- **Gazebo integration examples** — Ready-to-use simulation scenarios
- **Developer documentation** — Comprehensive guides for ROS and Gazebo users

**Key Metrics:**
- Reduce model conversion errors by >90%
- Support 10+ popular robot models out-of-the-box
- Achieve <500ms conversion time for typical URDF files
- Provide comprehensive test coverage (>85%)

---

## 2. Problem Statement

**The Challenge:**

ROS 2 developers commonly describe robots using URDF (Unified Robot Description Format), while Gazebo uses SDF (Simulation Description Format). The existing URDF-to-SDF conversion pipeline has several critical gaps:

1. **Incomplete feature support** — Many URDF tags (especially collision geometry, sensor plugins, and joint limits) are not faithfully translated
2. **Silent failures** — Invalid conversions often pass without errors, producing broken simulation models
3. **No validation feedback** — Developers receive no actionable diagnostics when conversions fail
4. **Fragmented tooling** — Multiple tools exist but none provide end-to-end validation and testing
5. **Poor documentation** — New ROS 2 users struggle to get robot models working in Gazebo simulation

These issues slow down robotics development, discourage simulation adoption, and create unnecessary friction for ROS 2 users. This project directly addresses these gaps with a comprehensive conversion and validation toolkit.

---

## 3. Deliverables

By the end of GSoC 2026, this project will deliver:

1. **Command-line URDF-to-SDF converter** — A Python/CLI tool supporting bidirectional URDF ↔ SDF conversion with rich diagnostic output
2. **SDF validation library** — Automated validation against sdformat schema with human-readable error reports
3. **Gazebo simulation integration** — Verified robot models that load directly in Gazebo Sim via ros_gz_bridge
4. **Validation dataset** — Collection of 10+ URDF models (TurtleBot, UR5, PR2, etc.) with known-good SDF counterparts
5. **Comprehensive documentation** — User guides, API reference, migration tutorials, and troubleshooting guides
6. **Test suite** — Unit tests, integration tests, and regression tests with >85% code coverage
7. **Open-source release** — Published under Apache 2.0 license on GitHub with CI/CD pipeline

---

## 4. Competitive Analysis

| Tool/Project | URDF Support | SDF Validation | Gazebo Bridge | CLI Interface | Documentation |
|---|---|---|---|---|---|
| **This Project** | Full bidirectional | Schema + semantic | Full | Yes | Comprehensive |
| sdformat (official) | Read-only | Schema-only | Limited | Partial | Technical |
| urdfdom | Read-only | None | None | No | Minimal |
| gazebo_ros_pkgs | Partial | None | Yes | No | Moderate |
| xacro | Preprocessor only | None | None | Yes | Good |

**Unique Value:**
- First tool combining conversion, validation, and Gazebo integration in one pipeline
- Actionable diagnostic feedback for model authors
- Ready-to-use validation dataset for community benchmarking
- Full CI/CD with automated testing against multiple Gazebo/ROS 2 versions

---

## 5. Architecture

```
                        ┌─────────────────────────────────────────┐
                        │         URDF Input File                 │
                        └─────────────────┬───────────────────────┘
                                          │
                        ┌─────────────────▼───────────────────────┐
                        │         URDF Parser (urdfdom)           │
                        │    - Extract kinematics, geometry,      │
                        │    - Extract sensors, actuators         │
                        └─────────────────┬───────────────────────┘
                                          │
                        ┌─────────────────▼───────────────────────┐
                        │    URDF → SDF Semantic Mapping Layer    │
                        │    - Material mapping (URDF→SDF)        │
                        │    - Collision geometry conversion      │
                        │    - Joint limit translation            │
                        │    - Sensor plugin mapping              │
                        └─────────────────┬───────────────────────┘
                                          │
                        ┌─────────────────▼───────────────────────┐
                        │       SDF Builder (sdformat)            │
                        │    - Construct SDF DOM tree             │
                        │    - Apply Gazebo-specific extensions   │
                        └─────────────────┬───────────────────────┘
                                          │
                        ┌─────────────────▼───────────────────────┐
                        │      SDF Validation Engine              │
                        │    - Schema validation (xsd)            │
                        │    - Semantic validation (rules)        │
                        │    - Gazebo compatibility checks        │
                        └─────────────────┬───────────────────────┘
                                          │
                        ┌─────────────────▼───────────────────────┐
                        │           Output SDF File               │
                        │    + Diagnostic Report (JSON/text)      │
                        └─────────────────────────────────────────┘
```

**Key Components:**
- **Parser Layer** — Uses existing `urdfdom` and `sdformat` libraries for robust XML parsing
- **Mapping Layer** — Custom semantic translation rules ensuring feature parity
- **Validation Engine** — Multi-tier validation catching both syntax and semantic errors
- **CLI Interface** — Cross-platform Python tool with rich output formatting

---

## 6. Integration With Gazebo Internals

This project integrates deeply with core Gazebo and ROS 2 libraries:

### sdformat Library
- Uses **sdformat C++** as the authoritative SDF parser and generator
- Leverages `sdf::Element` and `sdf::Root` DOM for semantic-level manipulation
- Validates output using `sdf::Errors` from the official schema

### gz-sim Integration
- Generates SDF compatible with **Gazebo Sim** (Fortress and later)
- Supports gz-sim plugin loading and world configuration
- Validates models against actual gz-sim loading requirements

### ros_gz Bridge
- Ensures converted models work seamlessly with **ros_gz_sim** and **ros_gz_bridge**
- Supports TF2 frame mapping between URDF and SDF coordinate systems
- Validates sensor data flow through the ROS 2 messaging system

### URDF/xacro Compatibility
- Parses both raw URDF and xacro-expanded URDF
- Preserves xacro macro semantics during conversion where possible
- Reports incompatible xacro features with migration suggestions

---

## 7. Example Usage

### Basic Conversion
```bash
# Convert a URDF file to SDF
urdf2sdf input/turtlebot3.urdf --output output/turtlebot3.sdf

# Convert with verbose diagnostic output
urdf2sdf my_robot.urdf --verbose --diagnostics report.json

# Validate an existing SDF file
urdf2sdf --validate existing_model.sdf

# Bidirectional conversion (URDF → SDF → URDF)
urdf2sdf robot.urdf --roundtrip --output verified.urdf
```

### Sample Output
```
$ urdf2sdf turtlebot3.urdf --verbose
[INFO] Parsing URDF: turtlebot3.urdf
[INFO] Found 5 links, 4 joints
[INFO] Converting kinematics...
[INFO] Converting collision geometries...
[WARN] Material 'Red' uses non-standard color format
[INFO] Converting visual geometries...
[INFO] Building SDF DOM tree...
[INFO] Validating SDF against schema v1.9...
[INFO] Running semantic validation...
[SUCCESS] Conversion complete: turtlebot3.sdf
[SUCCESS] SDF validated: 0 errors, 1 warning
```

### API Usage (Python)
```python
from urdf2sdf import Converter, Validator

# Convert URDF to SDF
converter = Converter()
result = converter.convert("robot.urdf", "robot.sdf")
print(f"Conversion: {'success' if result.success else result.error}")

# Validate SDF
validator = Validator()
errors = validator.validate("robot.sdf")
for e in errors:
    print(f"  [{e.level}] {e.message} at line {e.line}")
```

---

## 8. Testing Strategy

**Unit Tests:**
- Test individual conversion functions for each URDF/SDF element type
- Validate material, geometry, joint, and sensor mapping correctness
- Test edge cases: missing attributes, malformed XML, nested elements

**Integration Tests:**
- Full URDF → SDF → Gazebo load pipeline for each test model
- Verify model behavior matches expected simulation characteristics
- Test ros_gz bridge data flow with converted models

**Regression Tests:**
- Maintain a suite of known-good URDF/SDF pairs
- Run full test suite on every commit via GitHub Actions CI
- Track conversion quality metrics over time

**Validation Dataset:**
- `examples/turtlebot3.urdf` — Popular differential drive robot
- `examples/ur5.urdf` — Industrial 6-DOF manipulator
- `examples/pr2.urdf` — Complex multi-DOF mobile manipulator
- `examples/minitaur.urdf` — Quadruped with parallel mechanisms
- `examples/quadrotor.urdf` — Flying vehicle with propulsion

Each model in the dataset has:
- Original URDF file
- Expected SDF output (golden reference)
- Validation test case
- Expected diagnostics output

---

## 9. Project Timeline

### Week 1-2: Project Setup & Research
- Set up development environment (Gazebo Fortress, ROS 2 Humble/Jazzy)
- Study existing conversion code in sdformat, urdfdom, gazebo_ros_pkgs
- Analyze 20+ URDF models from various robot manufacturers
- Document URDF-to-SDF feature mapping gaps
- **Deliverable:** Gap analysis document, development environment ready

### Week 3-4: Core Parser Implementation
- Implement URDF parsing layer using urdfdom
- Implement SDF DOM construction using sdformat
- Build core conversion pipeline (URDF → SDF)
- Write unit tests for basic URDF elements (link, joint, material)
- **Deliverable:** Core parser with basic URDF/SDF element support

### Week 5-6: Geometry & Kinematics
- Implement collision geometry conversion (box, cylinder, sphere, mesh)
- Implement visual geometry and material mapping
- Handle kinematic chain reconstruction (joint hierarchy, transforms)
- Add joint limit, friction, and dynamics property translation
- **Deliverable:** Full kinematics and geometry conversion

### Week 7-8: Sensor & Plugin Support
- Map URDF sensor elements to SDF equivalents (camera, lidar, IMU)
- Handle Gazebo-specific sensor plugins
- Implement ros_gz bridge compatibility layer
- Support custom plugin loading in converted models
- **Deliverable:** Sensor plugin conversion with ROS 2 integration

### Week 9-10: Validation Engine
- Build schema validation layer using sdformat's built-in validation
- Implement semantic validation rules (kinematic validity, coordinate frames)
- Create human-readable diagnostic reporting
- Develop validation dataset with known-good models
- **Deliverable:** Complete validation engine with diagnostic output

### Week 11-12: CLI & Integration Testing
- Build cross-platform command-line interface
- Integrate all components into unified tool
- Run full integration tests on validation dataset
- Fix bugs and improve error handling
- **Deliverable:** Fully functional CLI tool with integration tests

### Week 13-14: Documentation & Polish
- Write comprehensive user documentation
- Create tutorial guides and migration examples
- Build developer API reference
- Final CI/CD pipeline setup and coverage optimization
- **Deliverable:** Complete documentation, polished release

### Week 15-16: Community Feedback & Wrap-up
- Share results on ROS Discourse and Gazebo Forum
- Gather community feedback and address issues
- Submit PRs to upstream projects (sdformat, gazebo_ros)
- Final testing and bug fixes
- **Deliverable:** Community-validated tool with upstream contributions

---

## 10. Community Engagement & Outreach

### Maintainers & Mentors
| Name | Role | Affiliation |
|---|---|---|
| **Aaron Chen** | Primary technical mentor | gz-sim maintainer, OSRF |
| **Steve Peters** | SDF/specification guidance | Gazebo architect, OSRF |
| **Louise Poubel** | ROS 2 bridge expertise | ROS Gazebo integration lead |

### Outreach Plan
1. **Week 1:** Introduce project on ROS Discourse and Gazebo Forum
2. **Week 2:** Create detailed GitHub issues for each milestone
3. **Week 3-4:** Comment on related discussions in gz-sim/sdformat repos
4. **Ongoing:** Weekly status updates on GitHub with progress reports
5. **Pre-GSoC:** Submit 2-3 small PRs to build relationship with maintainers
6. **Post-weekly:** Participate in Gazebo SIG meetings when scheduled

### Related Repositories
- **gz-sim** (Gazebo Simulator) — Target integration for converted models
- **sdformat** (SDF Parser) — Core library for SDF generation and validation
- **gazebo_ros_pkgs** — ROS 2 bridge compatibility testing
- **urdfdom** — URDF parsing reference implementation

---

## 11. Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| **Complex URDF features not supported** | Medium | High | Phase implementation; core features first, edge cases later |
| **sdformat API changes** | Low | Medium | Track upstream releases; pin known-working versions in CI |
| **Gazebo version compatibility issues** | Medium | Medium | Test against multiple Gazebo versions (F, G, H) in CI |
| **Performance bottlenecks** | Low | Low | Profile early; optimize hot paths; document performance targets |
| **Community adoption low** | Medium | Medium | Active outreach on ROS Discourse, Gazebo Forum, and social media |
| **Mentor availability limited** | Low | Medium | Maintain async communication; document progress thoroughly |

---

## 12. Background & Qualifications

I am Pavan C N, a first-year B.Tech student in Robotics Engineering at Garden City University, Bangalore, with a strong foundation in:

- **Programming:** C/C++, Python, JavaScript/TypeScript (React, Angular)
- **Robotics:** ROS 2 basics, Gazebo simulation, sensor integration
- **Linux/DevOps:** Ubuntu, Git, GitHub Actions, Docker
- **Open Source:** Active contributor to ROS 2 and robotics repositories

**Relevant Experience:**
- Contributed to ROS 2 packages under Open Robotics
- Built AI-powered automation tools and full-stack applications
- Published multiple open-source projects on GitHub
- Currently learning advanced Gazebo and sdformat internals

**Why I'm the right person for this project:**
- Deep interest in robotics simulation and the ROS 2 ecosystem
- Proven ability to learn complex codebases quickly
- Strong communication skills for community engagement
- Commitment to delivering high-quality, well-documented code

---

## 13. Post-GSoC Plan

### Immediate (GSoC ends)
- Address any remaining issues from community feedback
- Publish final release on PyPI and ROS package index
- Write blog post summarizing project outcomes and learnings

### 6 Months Post-GSoC
- Add support for additional URDF features (MIMIC joints, transmission)
- Extend validation dataset to 20+ robot models
- Integrate with ROS 2 build tools (colcon, rosdep)

### Long-term Sustainability
- Transition project to community maintenance under Open Robotics
- Accept PRs from the robotics community
- Continue improving documentation and adding tutorials
- Potentially integrate into official Gazebo/ROS 2 toolchains

### Career Goals
This project aligns perfectly with my career goal of becoming a robotics software engineer specializing in simulation and control systems. I plan to:
- Pursue internships in robotics simulation companies
- Contribute to ROS 2 and Gazebo projects long-term
- Potentially pursue research in multi-robot simulation systems

---

## 14. Research & References

This project draws from several important research areas and existing tools:

### Key References
1. **SDF Specification** — https://sdformat.org/spec
2. **URDF Specification** — https://wiki.ros.org/urdf/XML
3. **sdformat Library** — https://github.com/gazebosim/sdformat
4. **urdfdom Library** — https://github.com/ros/urdfdom
5. **Gazebo Sim** — https://gazebosim.org/
6. **ros_gz_bridge** — https://github.com/gazebosim/ros_gz

### Related Academic Work
- URDF to SDF conversion approaches (OSRF internal tools)
- Multi-format robot description interoperability
- Simulation model validation frameworks
- ROS 2 and Gazebo integration patterns

---

## 15. Contributing

We welcome contributions! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Ways to Help
- Report bugs and request features via GitHub Issues
- Submit PRs for bug fixes or new features
- Improve documentation and tutorials
- Share your experience with the converter

---

## 16. License

This project is licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for details.

---

## 17. About Open Robotics

[Open Robotics](https://www.openrobotics.org/) is a 501(c)(3) nonprofit dedicated to advancing the state of the art in robotics. Open Robotics develops and maintains open-source software for robotics, including ROS and Gazebo, which are used by researchers, educators, and industry professionals worldwide.

This proposal aligns with Open Robotics' mission to:
- Accelerate robotics research and education
- Foster a collaborative open-source community
- Make robotics accessible to everyone

---

## 18. Contact & Links

| Platform | Link |
|---|---|
| GitHub | [@strangerwhoisharborofdoom](https://github.com/strangerwhoisharborofdoom) |
| ROS Discourse | [Profile](https://discourse.ros.org) |
| Gazebo Forum | [Profile](https://community.gazebosim.org) |
| Email | [Contact via GitHub](https://github.com/strangerwhoisharborofdoom) |

---

*Thank you for considering this proposal. I look forward to contributing to the Open Robotics community and making robotics simulation more accessible to developers worldwide.*

**GSoC 2026 — Enhanced Gazebo-ROS 2 Integration**

*Applicant: Pavan C N (@strangerwhoisharborofdoom)*
*Organization: Open Robotics*
*Timeline: May - August 2026*
