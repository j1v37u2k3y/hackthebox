#!/bin/bash
# Runs full NMAP scan and triggers suggester for follow-up tools

basedir="$HOME/ctf/htb/"

# Variables passed from htb.sh via tmux
test_name=$1
ip_address=$2
scriptdir=$3

xsl="$HOME/nmap-bootstrap.xsl"

# Download Bootstrap XSL stylesheet if not already present
if [ ! -f "$xsl" ]; then
    echo "Downloading nmap-bootstrap.xsl..."
    wget -q -O "$xsl" "https://j1v37u2k3y.github.io/nmap-bootstrap-xsl/nmap-bootstrap.xsl"
fi

clear
echo "Starting full NMAP scan on ${ip_address}..."
echo ""

outdir="${basedir}${test_name}/nmap"
outbase="${outdir}/${test_name}_full"

# Run full port scan with service detection and Bootstrap stylesheet
nmap -n -vvv -sS -sC -sV "$ip_address" -oA "$outbase" -p- --stylesheet "$xsl"

# Generate styled HTML report from XML output
xsltproc -o "${outbase}.html" "$xsl" "${outbase}.xml"

# Launch follow-up tools based on open ports
. "${scriptdir}/suggester.sh"

# Save open ports to notes
grep open "${outbase}.nmap" > "${basedir}${test_name}/notes.txt"

echo ""
echo "Scan complete. Open ports saved to ${basedir}${test_name}/notes.txt"
echo "HTML report: ${outbase}.html"
