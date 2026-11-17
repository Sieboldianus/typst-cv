FROM python:3.12-slim-bookworm

ARG TYPST_VERSION=0.15.1
ENV TYPST_FONT_PATHS=/usr/share/fonts/ebgaramond \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      tar \
      xz-utils \
      unzip \
      fontconfig \
      openssh-client \
      rsync \
      git \
    && rm -rf /var/lib/apt/lists/*

# 1. Install pinned Typst CLI
RUN ARCH=$(dpkg --print-architecture) && \
    case "$ARCH" in \
      amd64) TYPST_ARCH="x86_64-unknown-linux-musl" ;; \
      arm64) TYPST_ARCH="aarch64-unknown-linux-musl" ;; \
      *) echo "Unsupported arch: $ARCH" && exit 1 ;; \
    esac && \
    curl -fsSL "https://github.com/typst/typst/releases/download/v${TYPST_VERSION}/typst-${TYPST_ARCH}.tar.xz" \
      -o /tmp/typst.tar.xz && \
    tar -xJf /tmp/typst.tar.xz -C /tmp && \
    mv /tmp/typst-${TYPST_ARCH}/typst /usr/local/bin/typst && \
    chmod +x /usr/local/bin/typst && \
    rm -rf /tmp/typst* && \
    typst --version

# 2. Install Octavio Pardo's EB Garamond (includes true Bold & BoldItalic)
RUN mkdir -p /usr/share/fonts/ebgaramond && \
    for f in Regular Italic Medium MediumItalic SemiBold SemiBoldItalic Bold BoldItalic; do \
      curl -fsSL "https://raw.githubusercontent.com/octaviopardo/EBGaramond12/master/fonts/otf/EBGaramond-${f}.otf" \
        -o "/usr/share/fonts/ebgaramond/EBGaramond-${f}.otf"; \
    done && \
    fc-cache -f && \
    typst fonts --variants | grep -i "EB Garamond"

# 3. Python dependencies for YAML resolution, validation, HTML/BibTeX export
RUN pip install --no-cache-dir \
      pyyaml==6.0.2 \
      jinja2==3.1.5 \
      jsonschema==4.23.0

WORKDIR /work