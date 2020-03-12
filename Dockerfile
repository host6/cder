FROM golang:1.11.9

RUN mkdir /cder
COPY directcd /cder/cder
COPY prep.sh /cder/prep.sh
RUN chmod 777 /cder/cder

ENTRYPOINT ["/cder/cder"]
