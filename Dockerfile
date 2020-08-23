# https://github.com/rust-lang/cargo/issues/2644
FROM rust:1.45.2 AS builder
WORKDIR /builder

COPY todo/Cargo.toml Cargo.lock ./
RUN set -x\
 && mkdir -p src\
 && echo "fn main() {println!(\"broken\")}" > src/main.rs\
 && cargo build --release

COPY todo/src ./src
RUN set -x\
 && find target/release/ -type f -executable -maxdepth 1 -delete\
 && cargo build --release

FROM rust:1.45.2-slim
COPY --from=builder /builder/target/release/todo .

EXPOSE 8080

CMD ["./todo"]