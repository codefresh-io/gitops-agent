FROM golang:1.15.8-alpine3.13 as build

RUN apk -U add --no-cache git make ca-certificates && update-ca-certificates

ENV USER=gitops-agent
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

ARG gitops-agent
ARG OUT_DIR

# copy ca-certs and user details
COPY --chown=gitops-agent:gitops-agent --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/group /etc/group

# copy binary
COPY --chown=gitops-agent:gitops-agent --from=build /app/${OUT_DIR}/gitops-agent /usr/local/bin/

USER gitops-agent:gitops-agent

ENTRYPOINT [ "gitops-agent" ]

CMD [ "version" ]
