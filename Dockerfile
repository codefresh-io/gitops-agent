FROM golang:1.15.8-alpine3.13 as build

RUN apk -U add --no-cache git make ca-certificates && update-ca-certificates

ENV USER=BINARY_NAME
ENV UID=10001

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

WORKDIR /app

COPY . .

RUN go mod download -x
RUN go mod verify

# compile
RUN make build

FROM alpine:3.13

ARG BINARY_NAME
ARG OUT_DIR

# copy ca-certs and user details
COPY --chown=BINARY_NAME:BINARY_NAME --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/group /etc/group

# copy binary
COPY --chown=BINARY_NAME:BINARY_NAME --from=build /app/${OUT_DIR}/BINARY_NAME /usr/local/bin/

USER BINARY_NAME:BINARY_NAME

ENTRYPOINT [ "BINARY_NAME" ]

CMD [ "version" ]
