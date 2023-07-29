FROM python:3.10.4

RUN apt update
RUN apt install -y openjdk-17-jdk

# FROM openjdk:17
# # RUN apt update
# # RUN apt install python3.10.4
# COPY --from=python:3.10.4 / /

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN apt update

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "./run.py"]

EXPOSE 5000