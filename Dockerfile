FROM ubuntu:16.04

RUN apt-get update && apt-get --yes install luarocks
RUN luarocks install busted
RUN luarocks install luacov
