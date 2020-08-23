FROM rust:1.45.2 AS builder
WORKDIR /builder

RUN USER=root cargo init
COPY todo/Cargo.toml .
RUN cargo build --release

COPY todo/src ./src
RUN cargo install --path .

FROM rust:1.45.2
#FROM rust:1.45.2-alpine

COPY --from=builder /usr/local/cargo/bin/todo .
EXPOSE 8080

CMD ["./todo"]