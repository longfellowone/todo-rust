FROM rust:1.45.2 AS builder

WORKDIR /builder

RUN USER=root cargo init

COPY todo/Cargo.toml .
COPY Cargo.lock .

RUN cargo install --path .

COPY todo/src ./src

RUN cargo install --path .

FROM scratch

COPY --from=builder /usr/local/cargo/bin/todo .

CMD ["todo"]