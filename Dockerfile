FROM alpine:edge as fswatch_builder

ENV FSWATCH_BRANCH master

RUN apk add --no-cache file git autoconf automake libtool gettext gettext-dev make g++ texinfo curl
RUN git clone https://github.com/emcrisostomo/fswatch.git /root/fswatch

WORKDIR /root/fswatch

RUN git checkout ${FSWATCH_BRANCH}
RUN ./autogen.sh && ./configure --prefix=/fswatch && make -j && make install

# -- Final image

FROM alpine:edge

RUN apk add --no-cache bash gettext libstdc++ rsync supervisor tzdata shadow

COPY --from=fswatch_builder /fswatch /usr
COPY entrypoint.sh /entrypoint.sh
COPY fswatch-rsync.sh /usr/bin/fswatch-rsync.sh

RUN mkdir -p /docker-entrypoint.d \
	&& chmod +x /entrypoint.sh /usr/bin/fswatch-rsync.sh \
	&& mkdir -p /etc/supervisor.conf.d

COPY supervisord.conf /etc/supervisord.conf
COPY supervisor.daemon.conf /etc/supervisor.conf.d/supervisor.daemon.conf

ENTRYPOINT ["/entrypoint.sh"]
CMD ["supervisord"]