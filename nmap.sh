#!/bin/bash
# Runs full NMAP scan and triggers suggester for follow-up tools

basedir="$HOME/ctf/htb/"

# Variables passed from htb.sh via tmux
test_name=$1
ip_address=$2
scriptdir=$3

clear
echo "Starting full NMAP scan on ${ip_address}..."
echo ""

# Run full port scan with service detection
nmap -sC -sV "$ip_address" -oA "${basedir}${test_name}/nmap/${test_name}_full" -p-

# Launch follow-up tools based on open ports
. "${scriptdir}/suggester.sh"

# Save open ports to notes
cat "${basedir}${test_name}/nmap/${test_name}_full.nmap" | grep open > "${basedir}${test_name}/notes.txt"

echo ""
echo "Scan complete. Open ports saved to ${basedir}${test_name}/notes.txt"
