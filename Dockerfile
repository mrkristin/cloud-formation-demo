# Start from the latest golang base image
FROM golang:latest as builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# https://golang.org/cmd/go/
#     GOOS: go operating system ?
# https://golang.org/cmd/cgo/
#     CGO_ENABLED: C GO
# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build demo.go


######## Start a new stage from scratch #######
FROM alpine:latest

WORKDIR /root/

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/demo .

# Expose port 8080 to the outside world
EXPOSE 80

# Command to run the executable
CMD ["./demo"]