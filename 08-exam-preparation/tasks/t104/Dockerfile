FROM golang:1.24

WORKDIR /app

COPY app/go.mod ./
RUN go mod download

COPY app/*.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /hello-docker-world

EXPOSE 5000

CMD ["/hello-docker-world"]
