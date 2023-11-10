FROM alpine:3.18 as builder
RUN apk add --update --no-cache build-base git bash gcc make g++ zlib-dev linux-headers pcre-dev openssl-dev && \
    git clone https://github.com/arut/nginx-rtmp-module.git && \
    git clone https://github.com/nginx/nginx.git && \
    cd nginx && ./auto/configure --add-module=../nginx-rtmp-module && make && make install

FROM alpine:3.18 as nginx
RUN addgroup -g 1001 nginx && \
    adduser -D -u 1001 -G nginx nginx && \
    apk add --update --no-cache tzdata pcre ffmpeg
COPY --from=builder --chown=nginx:nginx /usr/local/nginx /usr/local/nginx
USER nginx
WORKDIR /usr/local/nginx
ENTRYPOINT ["/usr/local/nginx/sbin/nginx"]
