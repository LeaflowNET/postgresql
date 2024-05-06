ARG PG_MAJOR=16
FROM postgres:$PG_MAJOR
ARG PG_MAJOR


# Base
RUN mkdir -p /tmp/build && apt-get update && \
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