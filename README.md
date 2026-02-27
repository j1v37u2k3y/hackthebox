# hackthebox

Simple script to automate HackTheBox setup and initial reconnaissance.

## What it does

1. Prompts for box name and IP address
2. Creates organized directory structure (`~/ctf/htb/<boxname>/`)
3. Optionally updates `/etc/hosts`
4. Launches a tmux session with:
   - OpenVPN connection (auto-detected)
   - Full NMAP scan (`-sC -sV -p-`)
   - Auto-launches tools based on open ports (dirb, smbclient, ldapsearch)

## Setup

```bash
# Clone the repo anywhere you like
git clone https://github.com/j1v37u2k3y/hackthebox.git
cd hackthebox

# Option 1: Symlink to your PATH
sudo ln -s "$(pwd)/htb.sh" /usr/local/bin/hackthebox

# Option 2: Just run it directly
bash htb.sh
```

Place your `.ovpn` file in `~/ctf/htb/` — it will be auto-detected.

## Requirements

- tmux
- nmap
- dirsearch
- openvpn
- smbclient (optional, for SMB enumeration)
- ldapsearch (optional, for LDAP enumeration)

## Usage

```bash
hackthebox
```

You'll be prompted for the box name and IP. Everything else is automated.

Work in progress!