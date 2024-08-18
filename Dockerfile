# syntax=docker/dockerfile:1

FROM python:3.12.5-slim-bookworm AS build

WORKDIR /opt/app

RUN apt-get update && \
    apt-get install -yqq \
      graphviz \
      libgraphviz-dev \
      build-essential && \
    apt-get clean

RUN python -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

ADD . .

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install .


FROM python:3.12.5-slim-bookworm

COPY --from=build /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"


RUN apt-get update && \
    apt-get install -yqq \
      graphviz && \
    apt-get clean

RUN mkdir /output

RUN groupadd -r appuser && useradd -r -g appuser appuser

USER appuser

WORKDIR /

ENTRYPOINT [ "trusttrees" ]
