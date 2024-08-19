# syntax=docker/dockerfile:1

# Build state
FROM python:3.12.5-slim-bookworm AS build

WORKDIR /opt/app

RUN apt-get update && \
    apt-get install -yqq \
      libgraphviz-dev \
      build-essential && \
    apt-get clean

RUN python -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

ADD . .

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install .


# Application stage
FROM python:3.12.5-slim-bookworm

COPY --from=build /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

RUN apt-get update && \
    apt-get install -yqq \
      graphviz && \
    apt-get clean

RUN mkdir /output

WORKDIR /

ENTRYPOINT [ "trusttrees" ]
