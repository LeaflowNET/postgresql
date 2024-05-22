#!/bin/bash

git clone https://github.com/pgvector/pgvector
cd pgvector && git checkout v0.7.0

cd ..

git clone https://github.com/timescale/timescaledb
cd timescaledb && git checkout 2.15.0