FROM python:3.7
ARG WORKDIR=/code
RUN mkdir $WORKDIR
WORKDIR $WORKDIR
RUN pip install pgsync
COPY ./docker/wait-for-it.sh wait-for-it.sh
COPY ./runserver.sh runserver.sh
RUN chmod +x wait-for-it.sh
RUN chmod +x runserver.sh
