<div align="center">

![GSoC 2026](https://img.shields.io/badge/GSoC-2026-ff69b4?style=for-the-badge&logo=google&logoColor=white)
![Open Robotics](https://img.shields.io/badge/Open%20Robotics-ROS%202-blue?style=for-the-badge&logo=ros&logoColor=white)
![Gazebo](https://img.shields.io/badge/Gazebo-Simulation-orange?style=for-the-badge)
![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)
![CI](https://github.com/strangerwhoisharborofdoom/gsoc-2026-proposal/actions/workflows/ci.yml/badge.svg)

</div>

# Google Summer of Code 2026 Proposal

## URDF to SDF Conversion Toolkit for ROS 2 and Gazebo

| | |
|---|---|
| **Applicant** | Pavan C N (@strangerwhoisharborofdoom) |
| **Organization** | Open Robotics |
| **Project Size** | 350 hours (Medium) |
| **Timeline** | May — August 2026 |
| **Timezone** | IST (UTC+05:30) |

## Why This Project Is Needed: Existing Tools Review

Before building new tooling, it is important to understand what already exists and where the gaps are.

### Existing Conversion Tools

| Tool | Maintainer | Direction | Status |
|------|------------|-----------|--------|
| **gz sdf -p** | Gazebo (osrf) | URDF → SDF | CLI utility; prints SDF to stdout[web:15] |
| **sdformat_urdf** | ROS (osrf) | SDF → URDF | urdf_parser_plugin; SDF-to-URDF only[web:10] |
| **FusionSDF** | Community (andreasBihlmaier) | CAD → SDF | Fusion 360 plugin; not URDF-focused[web:23] |
| **sdf_to_urdf** | Community (andreasBihlmaier) | SDF → URDF | ~50-line wrapper around sdformat_urdf[web:5] |

### Limitations of Existing Solutions

**1. gz sdf -p (Gazebo CLI)**

* Prints raw SDF to stdout — no output file, no batch processing
* **Silently ignores `<gazebo>` tags** referencing non-existent elements without warnings[web:11]
* Fixed joint lumping (joint reduction) is opaque and not configurable[web:25]
* No schema or semantic validation — broken SDF can be generated without error
* Documentation is outdated or scattered across old Gazebo wiki pages[web:9]
* Users report getting minimal output with just the SDF version and model name[web:22]

**2. sdformat_urdf (ROS package)**

* Only supports **SDF → URDF** direction — the reverse is not implemented[web:10]
* **Does not support universal joints**, a common requirement for many robot models[web:13]
* Material limitations: only solid color materials via `<ambient>` and `<diffuse>` tags[web:8]
* Requires a single `<model>` not inside a `<world>` — no support for nested models[web:8]
* Does not support `<pose>` on the model tag, limiting flexibility[web:8]
## Project Goals

| # | Goal | Success Criteria |
|---|------|------------------|
| 1 | Robust URDF → SDF conversion pipeline | Converts 90%+ of URDF elements faithfully |
| 2 | Automated SDF validation with diagnostics | Schema + semantic checks with actionable error messages |
| 3 | Seamless Gazebo Sim integration | All test models load in Gazebo without manual edits |
| 4 | Comprehensive documentation | User guide, API reference, migration tutorials |
| 5 | Production-quality code | >85% test coverage; CI/CD with GitHub Actions |

---

## System Architecture

The toolkit is structured as a layered C++ library with a CLI front-end:

```
┌─────────────────────────────────────────────────────────────────────┐
│                      CLI: urdf2sdf (Command-Line Tool)              │
│  Usage: urdf2sdf input.urdf --output output.sdf --validate --report │
└─────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────────┐
│                   Conversion Pipeline (C++ Library)                 │
│  ┌─────────────┐   ┌─────────────┐   ┌─────────────┐               │
│  │ URDF Parser │ → │  Mapping    │ → │ SDF Builder │               │
│  │  (urdfdom)  │   │   Layer     │   │ (sdformat)  │               │
│  └─────────────┘   └─────────────┘   └─────────────┘               │
│  - Kinematic tree  - Material map   - DOM tree build                │
│  - Geometry (box,  - Collision conv - Gazebo extensions             │
│    cylinder, mesh) - Joint limits   - Plugin mapping                │
│  - Sensors         - Dynamics       - ros_gz bridge                 │
└─────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      Validation Layer                               │
│  ┌─────────────────────┐   ┌─────────────────────┐                  │
│  │ Schema Validation   │   │ Semantic Validation │                  │
│  │ (sdformat parser)   │   │ (Custom rules)      │                  │
│  └─────────────────────┘   └─────────────────────┘                  │
│  - SDF version check       - Collision geometry sanity              │
│  - XML well-formedness     - Joint hierarchy validity               │
│  - Required elements       - Sensor configuration checks            │
└─────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      Output Layer                                   │
│  - SDF file (turtlebot3.sdf)                                        │
│  - Diagnostics report (diagnostics.json)                            │
│  - Validation summary (pass/fail with warnings)                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Component Details

**URDF Parser (urdfdom)**

* Leverages the official `urdfdom` C++ library to parse URDF XML into C++ DOM structures
* Extracts: links, joints, sensors, collision geometries, visual geometries, materials
* Handles Xacro preprocessing via external call (user runs `xacro` before conversion)

**Mapping Layer**

* Translates URDF semantics to SDF equivalents:
## Example Conversion Workflow

Here is a step-by-step example of converting a TurtleBot3 URDF model to SDF:

### Step 1: Install the Toolkit

```bash
# Build from source
git clone https://github.com/strangerwhoisharborofdoom/urdf2sdf.git
cd urdf2sdf && colcon build --symlink-install
source install/setup.bash
```

### Step 2: Prepare the URDF File

```bash
# If using Xacro, preprocess first
xacro turtlebot3_burger.urdf.xacro > turtlebot3.urdf
```

### Step 3: Run the Conversion

```bash
# Basic conversion
urdf2sdf turtlebot3.urdf --output turtlebot3.sdf

# With validation and diagnostics
urdf2sdf turtlebot3.urdf --output turtlebot3.sdf --validate --report diagnostics.json

# Verbose mode for debugging
urdf2sdf turtlebot3.urdf --output turtlebot3.sdf --verbose
```

### Step 4: Review the Output

```bash
# View the generated SDF
cat turtlebot3.sdf

# View the diagnostics report
cat diagnostics.json
```

### Step 5: Validate in Gazebo

```bash
# Load in headless Gazebo Sim
gz sim -r -s turtlebot3.sdf

# Or use the built-in Gazebo check
urdf2sdf --check-gazebo turtlebot3.sdf
```
## Real Robot Test Cases

The toolkit will be validated against real-world robot models. These test cases cover a range of complexity levels and URDF feature usage:

### Test Case 1: TurtleBot3 Burger

| Aspect | Details |
|--------|--------|
| **Complexity** | Beginner |
| **Links** | 10 (base_footprint, base_link, base_scan, wheel_link_*) |
| **Joints** | 4 continuous (wheels), 1 fixed |
| **Sensors** | 1 laser scanner (LDS-01) |
| **Special Features** | Fixed joint lumping, IMU plugin |
| **Expected Issues** | Fixed joint reduction on base_footprint |

### Test Case 2: Universal Robots UR5

| Aspect | Details |
|--------|--------|
| **Complexity** | Intermediate |
| **Links** | 11 (base, shoulder, elbow, wrist, ee_link) |
| **Joints** | 6 revolute (industrial arm kinematics) |
| **Sensors** | None (pure manipulator) |
| **Special Features** | Joint limits, dynamics (damping, friction), transmission elements |
| **Expected Issues** | Transmission mapping to SDF plugin |

### Test Case 3: PR2 Robot

| Aspect | Details |
|--------|--------|
| **Complexity** | Advanced |
| **Links** | 30+ (full mobile manipulator) |
| **Joints** | 20+ (revolute, prismatic, continuous, fixed) |
| **Sensors** | Multiple (stereo cameras, laser, IMU, contact sensors) |
| **Special Features** | Nested models, Gazebo plugins, complex collision geometry |
| **Expected Issues** | Plugin mapping, material color conversion |

### Test Case 4: Quadrotor (Iris)

| Aspect | Details |
|--------|--------|
| **Complexity** | Intermediate |
| **Links** | 5 (base + 4 rotors) |
| **Joints** | 4 continuous (rotors) |
| **Sensors** | IMU, barometer, GPS |
| **Special Features** | Rotor dynamics, aerodynamic drag model in `<gazebo>` tags |
| **Expected Issues** | `<gazebo>` tag element references, custom plugin parameters |

### Test Case 5: Minitaur Quadruped
## Detailed 16-Week Timeline

### Phase 1: Community Bonding (Weeks 0–2)

| Week | Focus | Deliverables |
|------|-------|-------------|
| **Week 0** | Environment setup, codebase study | Docker dev environment with Gazebo Fortress + ROS 2 Jazzy; local build of urdfdom and sdformat; first PR merged (README/docs update) |
| **Week 1** | URDF/SDF specification deep-dive | Annotated notes on URDF schema, SDF schema, and element mappings; comparison document of both formats |
| **Week 2** | Architecture design, API specification | ERD for internal data structures; CLI interface design; conversion pipeline architecture document approved by mentors |

### Phase 2: Core Conversion Pipeline (Weeks 3–6)

| Week | Focus | Deliverables |
|------|-------|-------------|
| **Week 3** | URDF parsing with urdfdom | C++ parser module; unit tests for link/joint/sensor extraction; parses simple URDF (single-link box) |
| **Week 4** | **Milestone 1: URDF Parser Complete** | Parser handles all URDF element types; test suite for parser module; documentation for parser API |
| **Week 5** | SDF DOM construction with sdformat | SDF builder module; maps basic URDF elements to SDF; generates valid SDF for simple models |
| **Week 6** | Geometry and material conversion | Box, cylinder, sphere, mesh collision geometry; material color mapping; visual geometry support |

### Phase 3: Advanced Conversion Features (Weeks 7–10)

| Week | Focus | Deliverables |
|------|-------|-------------|
| **Week 7** | Joint hierarchy and kinematics | Revolute, prismatic, continuous, fixed joint types; parent-child link relationships; kinematic chain validation |
| **Week 8** | **Milestone 2: Conversion Engine Complete** | Full URDF → SDF pipeline functional; TurtleBot3 conversion passes; unit tests for all conversion functions |
| **Week 9** | Joint dynamics and limits | Damping, friction, effort limits, velocity limits; transmission element mapping to SDF plugins |
| **Week 10** | Sensor conversion and ros_gz bridge | Camera, lidar/ray, IMU, contact sensor mapping; ros_gz bridge configuration injection; sensor topic naming conventions |

### Phase 4: Validation and Testing (Weeks 11–13)

| Week | Focus | Deliverables |
|------|-------|-------------|
| **Week 11** | Schema validation layer | sdformat parser integration; SDF well-formedness checks; XML schema validation |
| **Week 12** | **Milestone 3: Gazebo Integration Tested** | Semantic validation rules; Gazebo headless load test; all 5 test cases pass validation |
| **Week 13** | Diagnostic reporting and CLI polish | JSON diagnostics output; verbose/debug modes; error messages with line numbers and fix suggestions |

### Phase 5: Documentation and Release (Weeks 14–16)

| Week | Focus | Deliverables |
|------|-------|-------------|
| **Week 14** | User documentation | Installation guide, CLI reference, migration tutorials for each test robot |
| **Week 15** | API documentation and examples | Doxygen docs for C++ library; code examples; troubleshooting guide |
| **Week 16** | **Milestone 4: Release Ready** | Final bug fixes; CI/CD pipeline stable; >85% test coverage; release tag on GitHub; PyPI and ROS package index submission |

---

## Impact

This project directly addresses a critical gap in the ROS 2 ecosystem by providing a reliable, open-source URDF-to-SDF conversion tool that:

### For ROS 2 Developers
- **Eliminates manual conversion work**: No more hand-writing SDF files or debugging XML schema errors
- **Preserves robot semantics**: Joint hierarchies, kinematic chains, and sensor configurations are automatically preserved
- **Accelerates Gazebo simulation**: Get ROS 2 robots running in Gazebo Sim within minutes, not hours
- **Standardizes migration path**: Consistent, repeatable conversion process across the community

### For Gazebo Ecosystem
- **Expands robot library**: Enables rapid onboarding of thousands of existing URDF robots into Gazebo Sim
- **Improves interoperability**: Bridges the ROS 2 and Gazebo worlds with well-defined conversion semantics
- **Reduces maintenance burden**: Single source of truth (URDF) can be converted to SDF on demand
- **Community-driven improvements**: Open-source development allows community to add robot-specific converters

### For Academic and Research Institutions
- **Reproducible simulation setups**: Conversion is deterministic and version-controlled
- **Teaching tool**: Students learn SDF concepts by examining converted output
- **Research continuity**: Existing URDF-based research can be migrated to Gazebo Sim without rewriting models

- ## Planned Contributions to Open Robotics Ecosystem

Beyond the core conversion tool, this project will contribute back to the broader Open Robotics ecosystem:

### Code Contributions
| Repository | Contribution |
|---|---|
| **gz-sim** | Submit improvements to URDF import plugins based on conversion findings |
| **sdformat** | Report schema bugs discovered during conversion validation; propose extensions |
| **ros_gz** | Document and improve ros_gz_bridge configuration patterns for converted robots |
| **gz-sensors** | Identify and report sensor parameter mapping gaps between URDF and SDF |

### Documentation
- **Migration guide**: Comprehensive documentation for ROS 2 users transitioning URDF robots to Gazebo Sim
- **SDF learning resource**: Annotated conversion examples that serve as practical SDF tutorials
- **API reference**: Doxygen documentation for the C++ conversion library
- **Troubleshooting guide**: Common conversion issues with solutions and workarounds

### Community Engagement
- **Blog posts**: Technical write-ups on conversion challenges and solutions for the Open Robotics blog
- **Conference presentation**: Present findings at ROSCon 2026 or Gazebo Sim Summit
- **Mentorship**: Guide future contributors in extending the tool for new robot types
- **Issue triage**: Help maintain URDF import functionality in gz-sim by providing conversion test cases

- ## Technical Challenges and Mitigation Strategies

| Challenge | Description | Mitigation Strategy |
|---|---|---|
| **Plugin mapping** | URDF plugins have no direct SDF equivalent | Use `gz-sim` plugin patterns; document manual mapping |
| **Material colors** | URDF RGBA vs SDF color specification differences | Implement robust color parsing with gamma correction |
| **Mesh formats** | URDF uses COLLADA/OBJ; SDF expects different paths | Preserve mesh references; add mesh conversion utilities |
| **Joint limits** | Different limit representations between formats | Map effort/velocity limits to SDF `<limit>` elements |
| **Sensor types** | Gazebo-specific sensor parameters vary | Use default sensible values; flag for manual review |
| **Kinematic trees** | Complex parent-child hierarchies | Validate kinematic chain integrity post-conversion |
| **World frames** | URDF implicit vs SDF explicit world reference | Properly handle base_link to world joint conversion |

## Conclusion

The URDF to SDF Conversion Toolkit fills a critical gap in the ROS 2 and Gazebo Sim ecosystem. By automating the tedious and error-prone process of converting robot descriptions between formats, this project will:

1. **Save developer time** - Eliminate hours of manual SDF authoring
2. **Improve simulation fidelity** - Preserve robot semantics through automated conversion
3. **Accelerate adoption** - Make Gazebo Sim accessible to the broader ROS 2 community
4. **Enable reproducibility** - Deterministic, version-controlled conversion process
5. **Build community knowledge** - Document conversion patterns for future maintenance

This project represents a practical, implementable contribution that directly serves the needs of ROS 2 developers, robotics researchers, and the Open Robotics community. With a well-defined scope, clear milestones, and realistic deliverables, this GSoC project will produce a production-ready tool that becomes an essential part of the ROS 2 workflow.

---

## Repository Structure

```
gsoc-2026-proposal/
├── README.md                 # This file
├── src/
│   ├── urdf_parser/          # URDF parsing module (C++)
│   ├── sdf_builder/          # SDF DOM construction
│   ├── converter/            # Core conversion logic
│   └── validator/            # SDF validation and diagnostics
├── include/
│   └── urdf2sdf/             # Public API headers
├── test/
│   ├── unit/                 # Unit tests for each module
│   ├── integration/          # End-to-end conversion tests
│   └── test_models/          # URDF test robot files
├── examples/
│   ├── turtlebot3/           # TurtleBot3 conversion example
│   ├── ur5/                  # UR5 manipulator example
│   └── simple_box/           # Minimal working example
├── docs/
│   ├── architecture.md       # System design documentation
│   ├── api_reference.md      # API documentation
│   └── migration_guide.md    # User migration guide
├── CMakeLists.txt
├── package.xml
└── LICENSE
```

---

**Proposed by:** [Your Name]
**GSoC 2026 Organization:** Open Robotics
**Project Category:** Gazebo Sim / ROS 2
**Difficulty:** Medium to Hard
**Mentors:** [To be assigned]
**Contact:** [Your Email / GitHub]

| Aspect | Details |
|--------|--------|
| **Complexity** | Advanced |
| **Links** | 13 (body + 4 legs x 3 joints each) |
| **Joints** | 12 revolute (legged locomotion) |
| **Sensors** | Contact sensors, IMU |
| **Special Features** | High-frequency joint control, ground contact physics |
| **Expected Issues** | Contact sensor mapping, friction/cone parameters |

### Validation Criteria

Each test case is validated against:

1. **SDF Schema** — Passes sdformat parser without errors
2. **Gazebo Load** — Loads in Gazebo Sim headless mode without crashing
3. **Kinematic Integrity** — Joint hierarchy preserved; no broken parent-child links
4. **Geometry Fidelity** — Collision and visual geometries match URDF within tolerance
5. **Sensor Functionality** — Sensors publish data on correct ROS 2 topics via ros_gz_bridge

---

### Sample Diagnostics Output

```json
{
  "conversion_status": "success",
  "warnings": [
    {
      "element": "link.base_footprint",
      "message": "Fixed joint lumping applied; base_footprint merged with base_link",
      "severity": "info"
    }
  ],
  "errors": [],
  "gazebo_load_test": "passed",
  "elements_converted": 47,
  "elements_skipped": 0
}
```

---
  * URDF `<link>` → SDF `<link>` with `<collision>`, `<visual>`, `<inertial>`
  * URDF `<joint>` → SDF `<joint>` with type mapping (revolute, prismatic, continuous, fixed)
  * URDF `<sensor>` → SDF `<sensor>` (camera, ray/lidar, imu, contact)
  * URDF `<material>` → SDF `<material>` with `<ambient>`, `<diffuse>` color mapping
* Maintains a conversion report of skipped or approximated elements

**SDF Builder (sdformat)**

* Uses the `sdformat` C++ library to construct a valid SDF DOM tree
* Injects Gazebo-specific extensions: `<plugin>`, `<gazebo reference>` tags
* Adds ros_gz bridge configuration for ROS 2 topic mapping
* Serializes to SDF XML with proper formatting and schema version

**Validation Layer**

* **Schema validation**: Uses sdformat's built-in parser to verify SDF against the official schema
* **Semantic validation**: Custom rules checking logical consistency (e.g., joint parents exist, masses are positive)
* **Gazebo load test**: Spawns a headless Gazebo Sim instance to verify the SDF loads without errors
* **Diagnostic output**: JSON report with line numbers, element paths, and suggested fixes

---
* Not available as a standalone ROS 2 tool — requires full ROS installation

**3. FusionSDF and Community Tools**

* FusionSDF converts from CAD (Fusion 360) directly to SDF — not from URDF[web:23]
* `sdf_to_urdf` is a minimal 50-line wrapper, not a full-featured tool[web:5]
* No community tool provides **URDF → SDF with validation and diagnostics**
* No tool integrates with ROS 2 build tools (colcon, rosdep)

### Why a New Toolkit Is Needed

The existing landscape has a clear gap: **there is no production-ready URDF-to-SDF converter with validation, diagnostics, and ROS 2 integration.** Developers currently rely on `gz sdf -p` for conversion and then manually debug broken SDF files in Gazebo. This project fills that gap by providing:

1. A robust URDF → SDF conversion pipeline using urdfdom and sdformat
2. Automated schema and semantic validation with human-readable error reports
3. A standalone CLI tool that works outside ROS for CI/CD pipelines
4. A reusable C++ library that can be embedded in other projects
5. Comprehensive test coverage using real robot models (TurtleBot3, UR5, PR2)

---
---

## Abstract

This project proposes a comprehensive toolkit for converting URDF robot models into SDF (SDFormat) to improve interoperability between ROS 2 and Gazebo simulation environments. The toolkit includes a C++ parser library built on urdfdom and sdformat, a command-line conversion utility, and a validation layer that provides human-readable diagnostic feedback when conversions fail. By addressing the gaps in existing URDF-to-SDF conversion workflows, this project enables ROS 2 developers to seamlessly migrate robot models to Gazebo simulation without manual editing or silent conversion errors.

---

## Problem Statement

ROS 2 developers describe robot models in URDF, while Gazebo Sim requires SDF (SDFormat). The gap between these formats creates friction in simulation workflows:

* **Silent conversion failures** — The `gz sdf -p` command converts URDF to SDF but silently drops or ignores unsupported elements without warning
* **No validation feedback** — Developers receive no actionable diagnostics when the resulting SDF fails to load in Gazebo
* **Missing feature parity** — URDF elements like collision geometry extensions, joint dynamics, and Gazebo-specific `<gazebo>` tags are not faithfully translated
* **No end-to-end tooling** — Existing tools are fragmented: a CLI for conversion, a separate plugin for SDF-to-URDF, and no unified validation layer
* **High barrier for newcomers** — New ROS 2 users struggle to get their URDF models working in Gazebo, leading to frustration and abandoned simulation projects

This project addresses all of these gaps with a unified, production-ready conversion and validation toolkit.

---
