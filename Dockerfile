FROM rust:1.45.2 AS builder
WORKDIR /builder
RUN rustup target add x86_64-unknown-linux-musl

RUN USER=root cargo init
COPY todo/Cargo.toml .
#COPY Cargo.lock .
RUN cargo build --release

COPY todo/src ./src
RUN cargo install --target x86_64-unknown-linux-musl --path .

#FROM scratch
FROM rust:1.45.2

COPY --from=builder /usr/local/cargo/bin/todo .
EXPOSE 8080

CMD ["./todo"]