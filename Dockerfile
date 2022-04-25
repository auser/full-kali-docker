FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install kali-linux-everything && \
    apt-get clean
RUN apt -y update && apt -y upgrade && apt -y autoremove && apt clean


RUN apt-get -y install kali-desktop-xfce tightvncserver dbus dbus-x11 net-tools zsh

ENV USER root

ENV VNCPORT 5900
ENV VNCPWD password
ENV VNCDISPLAY 1280x720
ENV VNCDEPTH 16

EXPOSE 5900 5901

# Install custom packages
# TODO: ohmyzsh, powerlevel10k

RUN apt-get -y install vim curl tmux autocutsel firefox-esr

# Chezmoi
RUN sh -c "$(curl -fsLS chezmoi.io/get)" && \
    git clone https://github.com/auser/dotfiles.git ~/.local/share/chezmoi

# ZSH
# RUN chsh -s $(which zsh) root

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh && mkdir /root/.vnc
COPY xstartup /root/.vnc/xstartup
RUN chmod 755 /root/.vnc/xstartup
ENTRYPOINT [ "/entrypoint.sh" ]
