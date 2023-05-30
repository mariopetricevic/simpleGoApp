# Koristite multi-stage build kako biste smanjili veličinu konačnog Docker image-a
# Prva faza: Izgradnja Go aplikacije
FROM golang:1.19-buster AS builder

# Postavite radni direktorij
WORKDIR /app

# Kopirajte go.mod i go.sum
COPY go.mod ./

# Preuzmite Go pakete
RUN go mod download

# Kopirajte izvorni kod projekta
COPY . .

# Izgradite Go aplikaciju za armv7l (Raspberry Pi 4) arhitekturu
RUN GOOS=linux GOARCH=arm GOARM=7 CGO_ENABLED=0 go build -o simple .

# Druga faza: Izgradnja konačnog Docker image-a
FROM arm32v7/debian:buster-slim

# Kopirajte izgrađenu Go aplikaciju iz builder faze
COPY --from=builder /app /app

# Postavite radni direktorij
WORKDIR /app

# Postavite izvršnu aplikaciju kao ulaznu točku
#ENTRYPOINT ["/app/main"]

# Postavite CMD naredbu (opcionalno)
CMD ["/app/simple"]

