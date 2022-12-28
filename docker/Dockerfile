# builder
FROM ubuntu:20.04 as builder
RUN apt-get update && \
 DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential cmake clang-6.0 openssl libssl-dev zlib1g-dev gperf wget git ninja-build && \
 rm -rf /var/lib/apt/lists/*

ARG TON_REPO
RUN git clone --recursive ${TON_REPO:-https://github.com/ton-blockchain/ton} /ton
WORKDIR /ton
ARG TON_BRANCH
RUN git checkout ${TON_BRANCH:-testnet}

ENV CC clang-6.0
ENV CXX clang++-6.0
ENV CCACHE_DISABLE 1
RUN mkdir build && \
 cd build && \
 cmake -GNinja -DCMAKE_BUILD_TYPE=Release .. && \
 ninja storage-daemon storage-daemon-cli

# main
FROM ubuntu:20.04
RUN apt-get update && \
 apt-get install -y openssl curl gnupg wget libatomic1 gcc g++ make git supervisor && \
 rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/ton-work/db && mkdir -p /var/ton-work/db/static
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install nodejs && rm -rf /var/lib/apt/lists/*

COPY --from=builder /ton/build/storage/storage-daemon/storage-daemon-cli /usr/local/bin/
COPY --from=builder /ton/build/storage/storage-daemon/storage-daemon /usr/local/bin/

WORKDIR /app
COPY tonstorage-gateway  /app/
COPY tonstorage-cli /app/tonstorage-cli
RUN npm install

COPY docker/scripts /scripts
COPY docker/supervisord.conf /etc/supervisor/supervisord.conf

ENTRYPOINT [ "supervisord" ]
