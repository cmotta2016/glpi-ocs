FROM nginx
MAINTAINER Carlos Motta <motta.carlos08@gmail.com>

COPY ./default.conf /etc/nginx/conf.d/default.conf

ADD run.sh /sbin/run

RUN chmod +x /sbin/run

WORKDIR /tmp
EXPOSE 80
CMD run
