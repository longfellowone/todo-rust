FROM rust:1.45.2 AS builder

WORKDIR /builder

RUN USER=root cargo init

COPY todo/Cargo.toml .
COPY Cargo.lock .
RUN cargo build --release

COPY todo/src ./src
RUN cargo build --release
#RUN cargo install --path .

#FROM scratch
FROM alpine

COPY --from=builder /builder/target/release/todo .
#COPY --from=builder /usr/local/cargo/bin/todo .

CMD ["todo"]