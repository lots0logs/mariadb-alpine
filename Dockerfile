FROM alpine:latest
MAINTAINER Elegant Themes, Inc.

ENV LC_ALL=en_US.UTF-8

RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN apk --no-cache -U upgrade
RUN apk --no-cache add mariadb mariadb-client

RUN mkdir /docker-entrypoint-initdb.d

# comment out a few problematic configuration values
# don't reverse lookup hostnames, they are usually another container
RUN sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf \
	&& echo 'skip-host-cache\nskip-name-resolve' | awk '{ print } $1 == "[mysqld]" && c == 0 { c = 1; system("cat") }' /etc/mysql/my.cnf > /tmp/my.cnf \
	&& mv /tmp/my.cnf /etc/mysql/my.cnf

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
