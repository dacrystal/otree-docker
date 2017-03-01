FROM python:3-alpine

ARG SRC=app
ENV APP_DIR=/opt/otree
 
ENV REDIS_URL 'redis://redis:6379'
ENV DJANGO_SETTINGS_MODULE 'settings'

# app dirs
RUN mkdir -p ${APP_DIR} \
    && mkdir -p /opt/init

# dev tools & forego
RUN apk -U add --no-cache postgresql-dev gcc musl-dev curl \
                          bash postgresql \
    && curl https://bin.equinox.io/c/ekMN3bCZFUn/forego-stable-linux-amd64.tgz -O \
	&& cd /usr/local/bin \
	&& tar -xf /forego-stable-linux-amd64.tgz \
	&& rm /forego-stable-linux-amd64.tgz

# startup script
ADD entrypoint.sh ${APP_DIR}
ADD pg_ping.py ${APP_DIR}
RUN chmod +x ${APP_DIR}/entrypoint.sh \
    && echo "oTree: /bin/bash -c 'cd ${APP_DIR} && otree runprodserver --port=80'"> /Procfile


# app base requirements
COPY ${SRC}/requirements_base.txt ${APP_DIR}
COPY ${SRC}/requirements_heroku.txt ${APP_DIR}
RUN pip install --no-cache-dir -r ${APP_DIR}/requirements_heroku.txt

# app additional requirements
COPY ${SRC}/requirements.txt ${APP_DIR}
RUN pip install --no-cache-dir -r ${APP_DIR}/requirements.txt \
    && apk del postgresql-dev gcc musl-dev curl


# copy app source
ADD ${SRC} ${APP_DIR}

WORKDIR ${APP_DIR}
VOLUME /opt/init
ENTRYPOINT ${APP_DIR}/entrypoint.sh
EXPOSE 80
