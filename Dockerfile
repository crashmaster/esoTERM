FROM ubuntu:16.04

RUN apt update && apt --yes install luarocks
RUN luarocks install busted
RUN luarocks install luacov
