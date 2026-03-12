# 1. Використовуємо офіційний образ Go для збірки
FROM golang:1.21-alpine AS builder

# 2. Встановлюємо робочу директорію
WORKDIR /app

# 3. Копіюємо файли залежностей
COPY go.mod ./
# Якщо у вас є go.sum, розкоментуйте рядок нижче:
# COPY go.sum ./
RUN go mod download

# 4. Копіюємо весь код і збираємо бінарний файл
COPY . .
RUN go build -o main .

# 5. Створюємо фінальний легкий образ
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/main .

# 6. Запускаємо програму
CMD ["./main"]
