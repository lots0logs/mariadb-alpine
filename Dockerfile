FROM alpine:latest
MAINTAINER Elegant Themes, Inc.

ENV LC_ALL=en_US.UTF-8

RUN apk --no-cache -U upgrade
RUN apk --no-cache add \
	bash \
	tzdata \
	mariadb \
	mariadb-client

SHELL ["/bin/bash", "-c"]

RUN mkdir -p /docker-entrypoint-initdb.d /var/run/mysqld

# comment out a few problematic configuration values
# don't reverse lookup hostnames, they are usually another container
RUN sed -Ei \
		's/^(bind-address|log|binlog_format)/#&/g; \
		 s/^\[mysqld\]/&\nskip-name-resolve\nskip-host-cache/g; \
		 s|\/run\/|/var/run/|g' /etc/mysql/my.cnf

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld", "--user=root"]
