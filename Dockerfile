FROM jlesage/baseimage-gui:debian-8

ENV APP_NAME="iDRAC 6" \
    IDRAC_PORT=443

COPY keycode-hack.c /keycode-hack.c

RUN apt-get update && \
    mkdir -p /usr/share/man/man1 && \
    apt-get install -y --no-install-recommends default-jre-headless && \
    apt-get install -y wget software-properties-common && \
    apt-get install -y openjdk-7-jdk gcc && \
    gcc -o /keycode-hack.so /keycode-hack.c -shared -s -ldl -fPIC && \
    apt-get remove -y gcc software-properties-common && \
    apt-get autoremove -y && \
    update-java-alternatives -s java-1.7.0-openjdk-amd64 && \
    source /etc/profile && \
    rm -rf /var/lib/apt/lists/* && \
    rm /keycode-hack.c

RUN mkdir /app && \
    chown ${USER_ID}:${GROUP_ID} /app

COPY startapp.sh /startapp.sh

WORKDIR /app
