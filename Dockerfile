FROM golang:1.7
MAINTAINER Aditya Mukerjee <dev@chimeracoder.net>

RUN mkdir -p /build
ENV GOPATH=/go
RUN apt-get update
RUN apt-get install -y zip
RUN go get -u -v github.com/kardianos/govendor
RUN go get -u -v github.com/ChimeraCoder/gojson/gojson
RUN go get -u github.com/golang/protobuf/protoc-gen-go
RUN wget https://github.com/google/protobuf/releases/download/v3.1.0/protoc-3.1.0-linux-x86_64.zip
RUN unzip protoc-3.1.0-linux-x86_64.zip
RUN cp bin/protoc /usr/bin/protoc
RUN chmod 777 /usr/bin/protoc
RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64; \
	mv confd-0.11.0-linux-amd64 /usr/bin/confd; \
	chmod +x /usr/bin/confd

RUN go get -u github.com/stripe/veneur

WORKDIR /go/src/github.com/stripe/veneur


# If we wanted to peg ourselves to a given version we could replace HEAD here with a commit hash
# RUN git reset --hard HEAD

RUN govendor test -v -timeout 10s +local

RUN go build -a -v -ldflags "-X github.com/stripe/veneur.VERSION=$(git rev-parse HEAD)" -o /build/veneur ./cmd/veneur

ADD confd /etc/confd
ADD run.sh /go/src/github.com/stripe/veneur/
RUN chmod 777 /go/src/github.com/stripe/veneur/run.sh 

CMD /go/src/github.com/stripe/veneur/run.sh
