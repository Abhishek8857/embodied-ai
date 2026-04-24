#!/bin/bash
set -e

LOW_MEMORY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -low)
            echo "Low memory build enabled."
            LOW_MEMORY=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [-low]"
            exit 1
            ;;
    esac
done

git submodule update --init --recursive

export LOW_MEMORY
export ISAAC_SIM_LAB_IMAGE=$(cat isaac-sim-lab/image_name.cfg)
export CONTACT_GRASPNET_IMAGE=$(cat contact_graspnet/image_name.cfg)
export KINOVA_ROS2_IMAGE=$(cat kinova-ros2/image_name.cfg)
export ROS_AI_AGENT_IMAGE=$(cat ros-ai-agent/image_name.cfg)

docker compose build
