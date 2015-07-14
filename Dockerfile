FROM debian:stable

RUN apt-get update && apt-get -y install gnupg2 libasound2 libdbus-glib-1-2 libgtk2.0-0 libxrender1 libxt6 wget xz-utils

ENV TOR_PGP_KEYID=0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290

WORKDIR /tmp
RUN rm -f /tmp/$TOR_PGP_KEYID.gpg
RUN gpg2 --no-default-keyring --keyring /tmp/$TOR_PGP_KEYID.gpg \
         --keyserver x-hkp://pool.sks-keyservers.net --recv-keys 0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290
RUN wget https://www.torproject.org/dist/torbrowser/4.5.3/tor-browser-linux64-4.5.3_en-US.tar.xz
RUN wget https://www.torproject.org/dist/torbrowser/4.5.3/tor-browser-linux64-4.5.3_en-US.tar.xz.asc
RUN gpgv --keyring /tmp/$TOR_PGP_KEYID.gpg tor-browser-linux64-4.5.3_en-US.tar.xz.asc tor-browser-linux64-4.5.3_en-US.tar.xz

WORKDIR /opt
RUN tar Jxvf /tmp/tor-browser-linux64-4.5.3_en-US.tar.xz
RUN chown -R daemon:daemon tor-browser_en-US

WORKDIR /
RUN apt-get -y purge gnupg2 wget xz-utils
RUN apt-get -y autoremove --purge
RUN apt-get clean && rm -rf /var/lib/{apt,cache,dpkg,log} /tmp/*

USER daemon

ENTRYPOINT ["/opt/tor-browser_en-US/Browser/start-tor-browser"]
