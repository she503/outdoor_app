ARG HOST_ARCH
ARG VERSION

FROM ubuntu:latest
COPY ./build/tergeo_app /tergeo/

WORKDIR /home/tonglu/
CMD ["/bin/bash"]
