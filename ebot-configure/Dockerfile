FROM ubuntu:18.04

RUN apt-get update && apt-get install -y git wget openssl

WORKDIR /app

COPY setup.sh .
COPY configure.sh .
COPY copy_data.sh .
COPY .env.sample .env
COPY docker-compose.yml .
COPY etc/ ./etc/

RUN chmod +x setup.sh
RUN chmod +x configure.sh
RUN chmod +x copy_data.sh

ENV OUTPUT_FODER=/data/

CMD ["./setup.sh"]
