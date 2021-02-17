FROM seegno/bitcoind:0.13-alpine
MAINTAINER Kim Duffy "kimhd@mit.edu"

COPY . /cert-issuer
COPY conf_ethtest.ini /etc/cert-issuer/conf_ethtest.ini
COPY conf_eth.ini /etc/cert-issuer/conf_eth.ini

RUN apk add --update \
        bash \
        ca-certificates \
        curl \
        gcc \
        gmp-dev \
        libffi-dev \
        libressl-dev \
        linux-headers \
        make \
        musl-dev \
        python \
        python3 \
        python3-dev \
        tar \
        libxml2-dev \
        libxslt-dev \
    && python3 -m ensurepip \
    && pip3 install --upgrade pip==20.2.4  setuptools==50.3.2 \
    && pip3 install cryptography==3.2.1 \
    && mkdir -p /etc/cert-issuer/data/unsigned_certificates \
    && mkdir /etc/cert-issuer/data/blockchain_certificates \
    && mkdir ~/.bitcoin \
    && echo $'rpcuser=foo\nrpcpassword=bar\nrpcport=8332\nregtest=1\nrelaypriority=0\nrpcallowip=127.0.0.1\nrpcconnect=127.0.0.1\n' > /root/.bitcoin/bitcoin.conf \
    && pip3 install /cert-issuer/. \
    && rm -r /usr/lib/python*/ensurepip \
    && rm -rf /var/cache/apk/* \
    && rm -rf /root/.cache \
    && sed -i.bak s/==1\.0b1/\>=1\.0\.2/g /usr/lib/python3.*/site-packages/merkletools-1.0.2-py3.*.egg-info/requires.txt


ENTRYPOINT bitcoind -daemon && bash

