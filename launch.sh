#!/bin/bash
# launch.sh — launches the full stack in a single tmux window
# Usage: ./launch.sh

set -e

SESSION="embodied-ai"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux kill-session -t $SESSION 2>/dev/null || true

# Isaac Sim
tmux new-session -d -s $SESSION
tmux send-keys -t $SESSION.0 "bash $ROOT/isaac-sim-lab/docker_run/isaac_sim_launch.sh" Enter

# Split 
tmux split-window -t $SESSION.0 -v -p 85

# Split 
tmux split-window -t $SESSION.1 -v -p 58

# Split and start Graspnet and Agent
tmux send-keys -t $SESSION.2 "bash $ROOT/contact_graspnet/docker_run/contact_graspnet.sh" Enter
tmux split-window -t $SESSION.2 -h -p 50
tmux send-keys -t $SESSION "bash $ROOT/ros-ai-agent/docker_run/agent.sh" Enter

# Other containers
tmux select-pane -t $SESSION.1
tmux send-keys -t $SESSION.1 "bash $ROOT/kinova-ros2/docker_run/isaac_sim.sh" Enter

tmux split-window -t $SESSION.1 -h -p 75
tmux send-keys -t $SESSION "bash $ROOT/kinova-ros2/docker_run/motion_server.sh" Enter

tmux split-window -t $SESSION -h -p 67
tmux send-keys -t $SESSION "bash $ROOT/kinova-ros2/docker_run/agent_talker.sh" Enter

tmux split-window -t $SESSION -h -p 50
tmux send-keys -t $SESSION "bash $ROOT/kinova-ros2/docker_run/process_grasps.sh" Enter

# Kill switch
cat << 'EOF' > /tmp/embodied_ai_kill.sh
#!/bin/bash
echo "Press q to stop all containers and kill the stack..."
read -n 1 -s key
if [ "$key" = "q" ]; then
    echo "Stopping containers..."
    docker stop $(docker ps -q) 2>/dev/null || true
    tmux kill-session -t embodied-ai
fi
EOF

tmux new-window -t $SESSION -n "kill"
tmux send-keys -t $SESSION:kill "bash /tmp/embodied_ai_kill.sh" Enter

# Attach on main window, agent pane focused 
tmux set-option -t $SESSION mouse on
tmux select-window -t $SESSION:0
tmux select-pane -t $SESSION.4
tmux attach-session -t $SESSION
