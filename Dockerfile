FROM debian:buster
ARG PUPPETBOARD_VERSION


RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        git \
        python3 \
        virtualenv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/puppetboard
RUN chown nobody:nogroup /opt/puppetboard
WORKDIR /opt/puppetboard
USER nobody

RUN git clone https://github.com/voxpupuli/puppetboard.git . \
    && git checkout $PUPPETBOARD_VERSION

COPY --chown=nobody:nogroup settings.py /opt/puppetboard

RUN virtualenv -ppython3 /opt/puppetboard/venv \
    && /opt/puppetboard/venv/bin/pip install \
        -r /opt/puppetboard/requirements-docker.txt

ENV PUPPETBOARD_SETTINGS /opt/puppetboard/settings.py

CMD ["/opt/puppetboard/venv/bin/gunicorn", "-b", "127.0.0.1:8000", "puppetboard.app:app"]
