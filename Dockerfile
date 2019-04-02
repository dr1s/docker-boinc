from ubuntu:latest

ENV builddeps "git m4 dh-autoreconf pkg-config libssl-dev libcurl4-openssl-dev libz-dev"
ENV runtimedeps "libcurl4"
ENV VERSION ${CLIENT_VERSION:-7.14.2}
ENV DEBIAN_FRONTEND="noninteractive"

WORKDIR /boinc

RUN apt-get update && apt-get install -y ${builddeps} \
    && rm -rf /var/lib/apt/lists/* \
    && git clone --branch client_release/${VERSION%.[0-9]*}/${VERSION} https://github.com/BOINC/boinc /boinc \
    && ./_autosetup \
    && ./configure --disable-server --disable-manager --enable-client XXFLAGS="-O3 " \
    && make \
    && make install \
    && rm -rf /boinc \
    && mkdir /boinc \
    && apt-get purge -y --auto-remove ${builddeps} $(apt-mark showauto)

RUN apt-get update && apt-get install --no-install-recommends -y ${runtimedeps} \
    && rm -rf /var/lib/apt/lists/*

COPY bin/ /usr/local/bin

EXPOSE 31416

ENTRYPOINT /usr/local/bin/boinc-start.sh
