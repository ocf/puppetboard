FROM docker.ocf.berkeley.edu/theocf/debian:buster
ARG PUPPETBOARD_VERSION


RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        git \
        libpam-krb5 \
        nginx \
        python3 \
        runit \
        virtualenv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY services/nginx/nginx.conf /etc/nginx
COPY puppetboard_pam /etc/pam.d/puppetboard

RUN mkdir -p /opt/puppetboard
RUN chown nobody:nogroup /opt/puppetboard
WORKDIR /opt/puppetboard
USER nobody

RUN git clone https://github.com/voxpupuli/puppetboard.git . \
    && git checkout $PUPPETBOARD_VERSION

# Only allow users in the ocfstaff group to access puppetboard
RUN echo "ocfstaff" > /opt/puppetboard/allowed-groups

COPY --chown=nobody:nogroup services /opt/puppetboard/services
COPY --chown=nobody:nogroup settings.py /opt/puppetboard

RUN virtualenv -ppython3 /opt/puppetboard/venv \
    && /opt/puppetboard/venv/bin/pip install \
        -r /opt/puppetboard/requirements-docker.txt

ENV PUPPETBOARD_SETTINGS /opt/puppetboard/settings.py

CMD ["runsvdir", "/opt/puppetboard/services"]
