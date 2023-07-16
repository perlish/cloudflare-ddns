FROM ubuntu:latest
LABEL authors="hadi"
RUN apt-get update && apt-get install -y jq curl && rm -rf /var/lib/apt/lists/*
COPY ddns.sh .
RUN chmod +x ddns.sh
ENTRYPOINT ["./ddns.sh"]