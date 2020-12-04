FROM liumiaocn/golang:1.13.5-alpine3.11 as builder
ENV GO111MODULE on
ENV GOPROXY https://goproxy.cn
WORKDIR /build
RUN adduser -u 10001 -D app-runner
#RUN useradd --create-home --no-log-init --shell /bin/bash myappuser
#RUN adduser myappuser sudo
#RUN echo 'myappuser:mypassword'|chpasswd
#RUN groupadd -r redis && useradd -r -g redis redis
ADD go.mod .
ADD go.sum .
RUN go mod download


COPY . .
RUN GOOS=linux CGO_ENABLED=0 go build -ldflags="-s -w" -installsuffix cgo -o gin_demo main.go


#FROM scratch as prod

FROM alpine:3.10 AS final
#USER app-runner
WORKDIR /home/app-runner
COPY --from=builder /build/gin_demo /home/app-runner
#USER app-runner

CMD ["/home/app-runner/gin_demo"]

