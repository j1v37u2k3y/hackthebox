#!/bin/bash
# Updates the IP address for the current HTB session after a machine reset

basedir="$HOME/ctf/htb"

if [ -z "$1" ]; then
    read -r -p "New IP address: " new_ip
else
    new_ip="$1"
fi

# Get current tmux session name (which is the box name)
test_name=$(tmux display-message -p '#S')

if [ -z "$test_name" ]; then
    echo "Error: Not in a tmux session. Run this from your HTB tmux session."
    exit 1
fi

# Update tmux environment and push to all panes in this session
tmux setenv IP "$new_ip"
export IP="$new_ip"
for pane in $(tmux list-panes -s -t "$test_name" -F '#{pane_id}'); do
    tmux send-keys -t "$pane" "export IP=${new_ip}" Enter
done

# Update /etc/hosts if the box has an entry
server_name="${test_name}.htb"
old_ip=$(grep -F "$server_name" /etc/hosts | awk '{ print $1 }')

if [ -n "$old_ip" ]; then
    echo "Updating /etc/hosts: ${server_name} ${old_ip} -> ${new_ip}"
    sudo sed -i "s/${old_ip}\t${server_name}/${new_ip}\t${server_name}/" /etc/hosts
else
    read -r -p "Add ${server_name} -> ${new_ip} to /etc/hosts? [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY])
            echo -e "${new_ip}\t${server_name}" | sudo tee -a /etc/hosts > /dev/null
            ;;
    esac
fi

echo ""
echo "IP updated to ${new_ip} for box ${test_name}"
echo "Run scans with: bash nmap.sh ${test_name} ${new_ip} <scriptdir>"
