# docker build
#   docker build -t subicura/nginx-confd .
#
# docker run
#   docker run --rm -p 80:80 -p 8080:8080 subicura/nginx-confd

FROM ubuntu:14.04
MAINTAINER subicura@subicura.com

# update ubuntu latest
RUN \ 
  apt-get -qq update && \
  apt-get -qq -y dist-upgrade 

# install essential packages
RUN \
  apt-get -qq -y install build-essential software-properties-common python-software-properties curl git

# install confd
RUN \
  mkdir -p /app && \
  curl -s -L -o /app/confd https://github.com/kelseyhightower/confd/releases/download/v0.7.1/confd-0.7.1-linux-amd64 && \
  chmod +x /app/confd

# install nginx
RUN \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get -qq update && \
  apt-get -qq -y install nginx

# add confd config
ADD nginx.conf.tmpl /root/nginx.conf.tmpl
ADD nginx.toml /root/nginx.toml

# volume
VOLUME ["/etc/confd"]

# expose
EXPOSE 80

# run
ADD run.sh /app/run.sh
RUN chmod +x /app/run.sh
CMD /app/run.sh

