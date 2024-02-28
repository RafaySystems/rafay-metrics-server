# Update the base image in Makefile when updating golang version. This has to
# be pre-pulled in order to work on GCB.
FROM golang:1.21.6 as build

WORKDIR /go/src/sigs.k8s.io/metrics-server
COPY go.mod .
COPY go.sum .
RUN go mod download

COPY pkg pkg
COPY cmd cmd
COPY Makefile Makefile

RUN make metrics-server

FROM gcr.io/distroless/static:latest
COPY --from=build /go/src/sigs.k8s.io/metrics-server/metrics-server /
USER 65534
ENTRYPOINT ["/metrics-server"]
