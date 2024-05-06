ARG PG_MAJOR=16
FROM postgres:$PG_MAJOR
ARG PG_MAJOR
# Base
RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list && \
	echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
	echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
	echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
	rm -rf /etc/apt/sources.list.d/debian.sources && \
	mkdir -p /tmp/build && apt-get update && \
	apt-mark hold locales && \
	apt-get install -y --no-install-recommends build-essential git postgresql-server-dev-$PG_MAJOR
		

# PG VECTOR
RUN git clone https://github.com/pgvector/pgvector /tmp/build/pgvector && cd /tmp/build/pgvector && \
		make clean && \
		make OPTFLAGS="" && \
		make install && \
		mkdir /usr/share/doc/pgvector && \
		cp LICENSE README.md /usr/share/doc/pgvector


# TIMESCALE
RUN git clone https://github.com/timescale/timescaledb /tmp/build/timescaledb && cd /tmp/build/timescaledb && \
    git checkout 2.14.2 && ./bootstrap && cd build && make && make install

# CLEAN
RUN	rm -r /tmp/build && \
		apt-get remove -y build-essential postgresql-server-dev-$PG_MAJOR && \
		apt-get autoremove -y && \
		apt-mark unhold locales && \
		rm -rf /var/lib/apt/lists/*