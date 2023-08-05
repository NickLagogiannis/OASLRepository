FROM python:3.10.4


# Set environment variables for Java
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# RUN apt update
RUN apt-get update && apt-get install -y openjdk-17-jre
# RUN apt install -y openjdk-17-jdk

# FROM openjdk:17
# # RUN apt update
# # RUN apt install python3.10.4
# COPY --from=python:3.10.4 / /

WORKDIR /usr/src/app

COPY requirements.txt ./
# COPY /flask_app/static/miscellaneous /usr/src/app

RUN apt update

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "./run.py"]

EXPOSE 5000
