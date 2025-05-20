FROM ubuntu:latest

WORKDIR /app

COPY jogo_teste.sh Hangman.sh

COPY portuguese portuguese

RUN apt-get update && apt-get install -y bash dos2unix 
	&& dos2unix Hangman.sh \
	&& chmod +x Hangman.sh

ENTRYPOINT ["bash", "./Hangman.sh"]
