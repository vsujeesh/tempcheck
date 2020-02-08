FROM python:3.6.9-slim

ARG APP_DIR=/opt/sensemaker
WORKDIR $APP_DIR

ARG APP_USER=sensemaker
ARG APP_USER_ID=111

RUN groupadd -r --gid $APP_USER_ID $APP_USER && \
    useradd --no-log-init -r -m --uid $APP_USER_ID -g $APP_USER $APP_USER && \
    chown -R $APP_USER:$APP_USER /opt/sensemaker

RUN apt-get update && apt-get install -y gcc libpq-dev

USER sensemaker

COPY templates templates
COPY sensemaker sensemaker
COPY requirements.txt scripts/start_app.sh manage.py ./
COPY frontend frontend
COPY solr solr

ENV VIRTUAL_ENV=$APP_DIR/venv

RUN python3 -m venv venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install -r requirements.txt && \
    python3 manage.py collectstatic

EXPOSE 8000

CMD ["./start_app.sh"]