#!/usr/bin/env bash
# Description: Creates folders and sets up tmux for HackTheBox

# Auto-detect script location and base directory
scriptdir="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
basedir="$HOME/ctf/htb"

# Ensure base directory exists
mkdir -p "$basedir"

read -r -p "What box are you working on? " test_name
read -r -p "What is the IP address? " ip_address

WD="$basedir/$test_name"
mkdir -p "$WD"/{nmap,burp,dirb}

export IP="${ip_address}"
export WD="${WD}"

# Check if IP already exists in /etc/hosts
server_name_found=$(grep -F "${ip_address}" /etc/hosts | awk '{ print $2 }')

if [ -n "$server_name_found" ]; then
    echo "${server_name_found} found in /etc/hosts with IP: ${ip_address}"
fi

read -r -p "Update hosts file? [y/N] " response

server_name="${test_name}.htb"
case "$response" in
    [yY][eE][sS]|[yY])
        echo -e "${IP}\t${server_name}" | sudo tee -a /etc/hosts > /dev/null
        echo "Added ${server_name} -> ${IP} to /etc/hosts"
        ;;
esac

echo ""
echo "Box: ${test_name}"
echo "IP: ${IP}"
echo "Hostname: ${server_name}"
echo "Working Dir: ${WD}"
echo ""

# Find OpenVPN config
ovpn_file=$(find "$basedir" -maxdepth 1 -name "*.ovpn" -print -quit 2>/dev/null)

if [ -z "$ovpn_file" ]; then
    echo "Warning: No .ovpn file found in $basedir"
    echo "Place your .ovpn file in $basedir to auto-connect."
    echo ""
fi

# Launch tmux session
tmux new-session -d -s "$test_name"
tmux new-window -d -t "$test_name" -n nmap
tmux send-keys -t "$test_name:nmap" "bash $scriptdir/nmap.sh $test_name $ip_address $scriptdir" Enter

if [ -n "$ovpn_file" ]; then
    tmux send-keys -t "$test_name" "sudo openvpn $ovpn_file" Enter
fi

tmux attach -t "$test_name"
tmux setenv IP "${ip_address}"
tmux setenv WD "${WD}"
