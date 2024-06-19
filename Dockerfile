FROM rust:1.45 as builder
WORKDIR /usr/src/app
RUN apt install curl git build-essential libssl-dev pkg-config
RUN apt install protobuf-compiler libprotobuf-dev
RUN apt-get install clang-format clang-tidy \
clang-tools clang clangd libc++-dev \
libc++1 libc++abi-dev libc++abi1 \
libclang-dev libclang1 liblldb-dev \
libllvm-ocaml-dev libomp-dev libomp5 \
lld lldb llvm-dev llvm-runtime \
llvm python3-clang
RUN cargo install wasm-pack
RUN rustup target add wasm32-unknown-unknown
RUN git clone https://github.com/spectre-project/rusty-spectre
RUN cd rusty-spectre
COPY . .
RUN cargo build --release
FROM debian:buster-slim
COPY --from=builder /usr/src/app/target/release/app .
CMD ["./spectred --utxoindex --rpclisten-borsh=0.0.0.0:19110"]
