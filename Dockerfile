From ubuntu:18.04

MAINTAINER linix

ENV DEBIAN_FRONTEND noninteractive

# Set time zone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    git \
    vim \
    python3 \
    python3-pip \
    nginx \
    supervisor \
    curl \
    pwgen && rm -rf /var/lib/apt/lists/*

RUN pip3 install uwsgi

# nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# supervisor config
COPY supervisor.conf /etc/supervisor/conf.d/

# uWSGI config
COPY uwsgi.ini /Work/ApiService/uwsgi.ini

#django config
ADD ApiService.tar.xz /Work/
WORKDIR /Work/ApiService/
ADD requirements.txt /Work/ApiService/
RUN pip3 install -r requirements.txt
COPY start.sh /Work/ApiService/
COPY addProxyWhiteList.py /Work/ApiService/
run python3 addProxyWhiteList.py
RUN chmod 777 start.sh

EXPOSE 80
CMD ["./start.sh"]
