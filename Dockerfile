# ---
# Go Builder Image
FROM golang:1.11.1-alpine AS builder

RUN apk update && apk add curl git

RUN go get github.com/davecgh/go-spew/spew
RUN go get github.com/gorilla/sessions
RUN go get golang.org/x/oauth2
RUN go get golang.org/x/net/context

# set build arguments: GitHub user and repository
ARG GH_USER
ARG GH_REPO

# Create and set working directory
RUN mkdir -p /go/src/github.com/$GH_USER/$GH_REPO
WORKDIR /go/src/github.com//$GH_USER/$GH_REPO

# copy sources
COPY . .

# Run tests, skip 'vendor'
# RUN go test -v $(go list ./... | grep -v /vendor/)

# Build application
RUN go build -v -o "dist/myapp"

# ---
# Application Runtime Image
#FROM alpine:latest

# set build arguments: GitHub user and repository
#ARG GH_USER
#ARG GH_REPO

# copy file from builder image
#COPY --from=builder /go/src/github.com/$GH_USER/$GH_REPO/dist/myapp /usr/bin/myapp

EXPOSE 8080

CMD ["dist/myapp", "--help"]