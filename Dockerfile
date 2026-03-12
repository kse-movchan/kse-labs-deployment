FROM golang:1.21-alpine AS builder
WORKDIR /app

# Копіюємо все, що є в репозиторії
COPY . .

# Перевіряємо, чи є go.mod, і якщо немає — створюємо його на льоту
RUN if [ ! -f go.mod ]; then go mod init microservice; fi

# Завантажуємо залежності та збираємо
RUN go mod tidy
RUN go build -o main .

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/main .
CMD ["./main"]
