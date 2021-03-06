#!/bin/zsh

# Set password for VNC
mkdir -p /root/.vnc/
echo $VNCPWD | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

# Start VNC server and expose VNC
vncserver :0 -rfbport $VNCPORT -geometry $VNCDISPLAY -depth $VNCDEPTH -pixelformat $PIXELFORMAT > /var/log/vncserver.log 2>&1

# Start shell
/bin/zsh -l
