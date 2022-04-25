#!/bin/zsh

# Set password for VNC
ls -la /root/.vnc
mkdir -p /root/.vnc/
echo $VNCPWD | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

# Start VNC server and expose VNC
vncserver :0 -rfbport $VNCPORT -geometry $VNCDISPLAY -depth $VNCDEPTH > /var/log/vncserver.log 2>&1

# Start shell
/bin/zsh -l
