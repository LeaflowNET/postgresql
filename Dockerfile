ARG PG_MAJOR=17
FROM postgres:${PG_MAJOR}

# re-declare ARG so it's available after FROM and export to environment
ARG PG_MAJOR
ENV PG_MAJOR=${PG_MAJOR}

# 复制并执行安装脚本（脚本内部使用 apt-get 并根据 PG_MAJOR 自动调整）
COPY setup.sh /setup.sh
RUN chmod +x /setup.sh && /setup.sh && rm -f /setup.sh


# Base
# RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list && \
# 	echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
# 	echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
# 	echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
# 	rm -rf /etc/apt/sources.list.d/debian.sources && \
# 	mkdir -p /tmp/build && apt-get update && \
# 	apt-mark hold locales && \
# 	apt-get install -y --no-install-recommends build-essential cmake postgresql-server-dev-$PG_MAJOR
		

# PG VECTOR
# COPY pgvector /tmp/build/pgvector
# RUN cd /tmp/build/pgvector && \
# 		make clean && \
# 		make OPTFLAGS="" && \
# 		make install && \
# 		mkdir /usr/share/doc/pgvector && \
# 		cp LICENSE README.md /usr/share/doc/pgvector


# # TIMESCALE
# COPY timescaledb /tmp/build/timescaledb
# RUN cd /tmp/build/timescaledb && ./bootstrap && cd build && make && make install

# CLEAN
# RUN	rm -rf /tmp/build && \
# 		apt-get autoremove --purge -y build-essential git postgresql-server-dev-$PG_MAJOR && \
# 		apt-mark unhold locales && \
# 		rm -rf /var/lib/apt/lists/*