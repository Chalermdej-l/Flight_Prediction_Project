FROM python:3.9-slim-buster

COPY requirement/requirement-produce.txt .

RUN pip install -r  requirement-produce.txt

RUN mkdir -p /code

COPY code/realtime/producer.py ./code

