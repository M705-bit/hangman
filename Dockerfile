FROM ubuntu:latest

WORKDIR /app

COPY Hangman.sh Hangman.sh

COPY data1/ data1/

RUN apt-get update && apt-get install -y bash dos2unix \
    && dos2unix Hangman.sh \
    && chmod +x Hangman.sh

ENTRYPOINT ["bash", "./Hangman.sh"]
 
