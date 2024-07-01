FROM debian:latest
LABEL authors="torch"

WORKDIR /app

RUN rm /etc/apt/sources.list.d/*

RUN echo 'deb http://mirrors.ustc.edu.cn/debian/ bookworm main' >> /etc/apt/sources.list && \
    echo 'deb-src http://mirrors.ustc.edu.cn/debian/ bookworm main' >> /etc/apt/sources.list && \
    echo 'deb http://mirrors.ustc.edu.cn/debian/ bookworm-updates main' >> /etc/apt/sources.list && \
    echo 'deb-src http://mirrors.ustc.edu.cn/debian/ bookworm-updates main' >> /etc/apt/sources.list && \
    echo 'deb http://mirrors.ustc.edu.cn/debian-security bookworm-security main non-free-firmware' >> /etc/apt/sources.list && \
    echo 'deb-src http://mirrors.ustc.edu.cn/debian-security bookworm-security main non-free-firmware' >> /etc/apt/sources.list

RUN apt update && apt upgrade -y && \
    apt install libopus-dev ffmpeg wget curl -y

RUN cd /tmp && \
    wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb &&\
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt update && \
    apt install dotnet-sdk-8.0 -y && \
    rm -rf /var/lib/apt/lists/*

COPY . /tmp
RUN cd /tmp && \
    dotnet build --framework netcoreapp3.1 --configuration Release TS3AudioBot && \
    mv /tmp/TS3AudioBot/bin/Release/netcoreapp3.1 /app && \
    rm -rf /tmp*

ENTRYPOINT ["/app/netcoreapp3.1/TS3AudioBot"]
