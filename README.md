# Embodied Agents with Episodic Memory and Task Recovery

> AI-powered robotic agents with persistent memory, task outcome detection, and autonomous recovery mechanisms.

<div align="center">
  <img src="img/agent_architecture.png" width="800" alt="System Architecture"/>
</div>

<div align="center">
  <!-- Replace with your actual badges -->
  <img src="https://img.shields.io/badge/ROS2-Humble-blue"/>
  <img src="https://img.shields.io/badge/Isaac%20Sim-4.5-green"/>
  <img src="https://img.shields.io/badge/Docker-required-blue"/>
</div>

---

## Overview

This framework enables robotic agents to:
- **Remember** user preferences across sessions via episodic memory
- **Detect** task success or failure in real time
- **Recover** autonomously from failures without human intervention

### Stack Components

| Service | Description |
|---|---|
| `isaac-sim-lab` | NVIDIA Isaac Sim environment with IsaacLab |
| `contact-graspnet` | 6-DOF grasp pose estimation from point clouds |
| `kinova-ros2` | ROS2 driver and MoveIt2 config for Kinova arm |
| `ros-ai-agent` | LLM-based task planner with memory and recovery |

---

## Prerequisites

- **OS:** Ubuntu 22.04
- **GPU:** NVIDIA GPU with CUDA 12.x (Isaac Sim requires RTX-capable GPU)
- **RAM:** 32 GB recommended (use `-low` flag for 16 GB systems)
- **Docker:** 24.x + Docker Compose v2
- **NVIDIA Container Toolkit:** [Install guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

---

## Configuration

Before launching the stack, you need to add API key config files inside the `ros-ai-agent` service directory.

### Required Config Files

| File | Description |
|---|---|
| `openai_api_key.config` | OpenAI-compatible key from [OpenRouter](https://openrouter.ai) |
| `gemini_api_key.config` | Gemini key from [Google AI Studio](https://aistudio.google.com) |
| `langsmith_api_key.config` | LangSmith key for tracing (optional but recommended) |

### Where to Place Them

Place all config files in the `ros-ai-agent/` directory before building:

### Getting API Keys

- **OpenRouter** — Sign up at [openrouter.ai](https://openrouter.ai) to get a unified API key for models like Mistral and OpenAI-compatible endpoints. Use this key in `openai_api_key.config`.
- **Gemini** — Get your free API key from [Google AI Studio](https://aistudio.google.com/app/apikey) and paste it into `gemini_api_key.config`.
- **LangSmith** — Create a project at [smith.langchain.com](https://smith.langchain.com) and add your key to `langsmith_api_key.config` for agent tracing.

> These files are listed in `.gitignore` and will **not** be committed. Never share or push your API keys.

## Quick Start

### 1. Clone the Repository

```sh
git clone --recurse-submodules https://github.com/Abhishek8857/embodied-ai.git
cd embodied-ai/
```

### 2. Build the Docker Images

```sh
bash setup.sh
```

>  First build can take **30–60 minutes** depending on your connection and hardware.  
> On systems with less than 32 GB RAM, use the low-memory flag:
> ```sh
> bash setup.sh -low
> ```

### 3. Launch the Stack

```sh
bash launch.sh
```

This starts all services. Wait until all containers report healthy before proceeding.

### 4. Open the Simulation Scene

1. In the Isaac Sim window, go to **File → Open**
2. Navigate to: `/root/workspaces/isaac-sim-lab/overlay_ws/src/robot_usd_files/kinova_table.usd`
3. Click **Play** (▶) to start the simulation

### 5. Send Commands to the Robot

Find the terminal showing `Enter a command:` and type a natural language instruction.

>  **Always start with the home command** to move the robot to its safe starting position:
> ```
> go home
> ```

Then you can issue any task command, for example:
```
Pick up the red cube and place it on the green cube.
```

The agent will plan, execute, and recover from failures automatically. 

---

## License

[MIT](LICENSE)