# フェーズ1: Fluent Bitのビルド
FROM debian:buster as fluentbit-builder

RUN apt-get update && \
    apt-get install -y \
    cmake \
    make \
    gcc \
    g++ \
    curl \
    pkg-config \
    flex \
    bison \
    zlib1g-dev \
    libssl-dev \
    libsystemd-dev

# Fluent Bitのソースをダウンロードしてビルド
WORKDIR /fluentbit-build
RUN curl -L https://github.com/fluent/fluent-bit/archive/refs/tags/v1.8.3.tar.gz | tar xz --strip-components=1
RUN cmake -DFLB_RELEASE=On . && make

# フェーズ2: アプリケーションとFluent Bitの組み込み
FROM python:3.9-slim

# Fluent Bitのビルド成果物をコピー
COPY --from=fluentbit-builder /fluentbit-build/bin/fluent-bit /fluent-bit/bin/

# Fluent Bitの設定ファイルをコピー
COPY fluent-bit-config/fluent-bit-config.conf /fluent-bit/etc/

# ワーキングディレクトリの設定
WORKDIR /app

# Pythonアプリケーションのソースをコンテナにコピー
COPY app/app.py .

# Fluent Bitとアプリケーションを実行するエントリポイントを設定
CMD /fluent-bit/bin/fluent-bit -c /fluent-bit/etc/fluent-bit-config.conf & python app.py
