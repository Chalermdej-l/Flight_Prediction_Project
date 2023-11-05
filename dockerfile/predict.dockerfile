FROM python:3.9-slim-buster

COPY requirement/requirement-predict.txt .

RUN pip install -r  requirement-predict.txt

RUN mkdir -p /code

COPY code/realtime/predict.py ./code

