FROM bash:4.4

RUN apk add git
RUN apk add fzf

WORKDIR '/app'

COPY . . 

CMD ["bash", "./test.sh"]
