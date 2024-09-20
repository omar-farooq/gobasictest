FROM golang:latest AS gobase
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /hellogo

FROM scratch AS production
COPY --from=gobase /hellogo /hellogo
CMD ["/hellogo"]
