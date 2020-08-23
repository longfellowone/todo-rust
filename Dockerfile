FROM scratch

RUN mkdir -p /app
WORKDIR /app

COPY ./target/release/todo .
EXPOSE 8080
CMD ["./todo"]


#FROM rust:1.45.2 AS builder
#
#WORKDIR /builder
#
#RUN USER=root cargo init
#
#COPY todo/Cargo.toml .
#COPY Cargo.lock .
#RUN cargo build --release
#
#COPY todo/src ./src
#RUN cargo build --release
#
##FROM scratch
#FROM alpine
#
#COPY --from=builder /builder/target/release/todo .
#EXPOSE 8080
#
#CMD ["todo"]