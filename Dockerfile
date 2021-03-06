CMD ["/bin/sh"]
COPY dir:8953456e14df8cba6e02e6afe1a2e419aaa8d06fb212052b146f8f86361de7e6 in /venv

WORKDIR /pgadmin4
ENV PYTHONPATH=/pgadmin4
COPY dir:2c4ee6a21d817da1ccfbb5259289f1759f5fd8ce4bb4dc4a536b1e4214ae0847 in /pgadmin4

COPY file:d7b4a5bf183fe2383e008753c8afa8b39c3f61907fdc7ded5007241f12d69468 in /pgadmin4
        pgadmin4/
        pgadmin4/run_pgadmin.py

COPY file:02e042dfbfbef1f48e0551315d70a88c40932b31ac17e51038fda08cd740b036 in /pgadmin4
        pgadmin4/
        pgadmin4/gunicorn_config.py

COPY file:573f3545acfd2151e09eaa9dd3e2566396edd5959e7f290d8a2052ff46a25ed7 in /entrypoint.sh
        entrypoint.sh

COPY file:fd755eb8f34119c2eee7c7a5f66cdd010299e11d489f62cacebf0f6e83550c7c in /pgadmin4/LICENSE
        pgadmin4/
        pgadmin4/LICENSE

COPY file:606e5592dfdc275e13207b30dbd889c30572c2d3358d2df88cc1820422a0a1b0 in /pgadmin4/DEPENDENCIES
        pgadmin4/
        pgadmin4/DEPENDENCIES

RUN apk add python3 py3-pip postfix postgresql-libs krb5-libs shadow sudo libedit libcap  \
        && /venv/bin/python3 -m pip install --no-cache-dir gunicorn  \
        && find / -type d -name '__pycache__' -exec rm -rf {} +  \
        && groupadd -g 5050 pgadmin  \
        && useradd -r -u 5050 -g pgadmin pgadmin  \
        && mkdir -p /var/lib/pgadmin  \
        && chown pgadmin:pgadmin /var/lib/pgadmin  \
        && touch /pgadmin4/config_distro.py  \
        && chown pgadmin:pgadmin /pgadmin4/config_distro.py  \
        && setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/python3.8  \
        && echo "pgadmin ALL = NOPASSWD: /usr/sbin/postfix start" > /etc/sudoers.d/postfix
USER pgadmin
VOLUME [/var/lib/pgadmin]
EXPOSE 443 80
ENTRYPOINT ["/entrypoint.sh"]
