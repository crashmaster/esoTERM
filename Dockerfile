FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt --yes install luarocks
RUN luarocks install busted
RUN luarocks install luacov

RUN mkdir /dojos
VOLUME /dojos

CMD /bin/bash
