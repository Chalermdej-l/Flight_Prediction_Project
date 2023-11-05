FROM python:3.9-slim-buster

COPY requirement/requirement-consume.txt .

RUN pip install -r  requirement-consume.txt

RUN mkdir -p /code
RUN mkdir -p /artifact

COPY code/realtime/consumer.py ./code
COPY artifact/dv.sav ./artifact
COPY artifact/model.sav ./artifact

