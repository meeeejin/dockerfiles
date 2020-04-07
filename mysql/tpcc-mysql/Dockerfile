# TPC-C benchmark suite for MySQL
FROM		mysql:5.7
MAINTAINER 	Mijin An <meeeeejin@gmail.com>

# Update the apt package index
RUN apt-get update 

# Install the prerequistes
RUN	\
	apt-get install -y \
		git \
		gcc \
		make \ 
		libmysqlclient-dev

# Clone tpcc-mysql
RUN \
	cd /root && \
	git clone https://github.com/Percona-Lab/tpcc-mysql

# Build binaries
RUN \
	cd /root/tpcc-mysql/src && \
	make

