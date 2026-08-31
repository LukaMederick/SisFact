FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY go.mod ./
# COPY go.sum ./ # when available
RUN go mod download || true

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o sisfact-api ./cmd/api/main.go

FROM alpine:latest
RUN apk --no-cache add ca-certificates tzdata
WORKDIR /root/
COPY --from=builder /app/sisfact-api .
COPY --from=builder /app/sql ./sql

EXPOSE 8080
CMD ["./sisfact-api"]
