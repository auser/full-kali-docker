FROM kalilinux/kali-rolling as base

ENV DEBIAN_FRONTEND noninteractive

# apt-get -y install kali-linux-everything && \
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -yq install kali-desktop-xfce kali-linux-default kali-tools-web kali-tools-windows-resources && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    # Remove apt-get cache from the layer to reduce container size
    rm -rf /var/lib/apt/lists/*


ENV USER root

FROM base as box

ENV VNCPORT 5900
ENV VNCPWD password
ENV VNCDISPLAY 1280x800
ENV VNCDEPTH 16
ENV PIXELFORMAT rgb565

EXPOSE 5900 5901

# Install custom packages
# TODO: ohmyzsh, powerlevel10k

RUN apt-get -y update && \
    apt-get -y install terminator vim curl tmux autocutsel firefox-esr && \
    apt-get -y install tightvncserver xfce4-power-manager-plugins gnome-terminal xorg xrdp dbus dbus-x11 net-tools zsh && \
    apt-get -yq install maltego metasploit-framework burpsuite wireshark aircrack-ng hydra nmap beef-xss nikto && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    # Remove apt-get cache from the layer to reduce container size
    rm -rf /var/lib/apt/lists/*

# Chezmoi
RUN sh -c "$(curl -fsLS chezmoi.io/get)" && \
    git clone https://github.com/auser/dotfiles.git ~/.local/share/chezmoi

# ZSH
# RUN chsh -s $(which zsh) root

COPY entrypoint.sh /entrypoint.sh
COPY ./xstartup /root/.vnc/xstartup
RUN chmod 755 /entrypoint.sh && \
    mkdir -p /root/.vnc && \
    chmod 755 /root/.vnc/xstartup

ENTRYPOINT [ "/entrypoint.sh" ]
