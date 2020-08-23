FROM rust

WORKDIR /usr/src/myapp
COPY . .

RUN cargo install --path ./todo

CMD ["myapp"]

#RUN apt-get update && \
#    apt-get upgrade -y && \
#    rustup target add x86_64-unknown-linux-musl

#VOLUME /code
#WORKDIR /code
#
#ENTRYPOINT ["cargo"]