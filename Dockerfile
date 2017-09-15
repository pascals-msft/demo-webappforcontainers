# Dockerfile
# Source: https://hub.docker.com/r/jcdemo/flaskapp/~/dockerfile/

FROM python:alpine

RUN pip install flask

COPY src /src/

EXPOSE 5000

ENTRYPOINT ["python", "/src/app.py"]
