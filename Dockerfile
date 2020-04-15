ARG HOST_ARCH
ARG VERSION

FROM tonglu-docker.pkg.coding.net/tergeo-app/tergeo-app/tergeo-app_base_${HOST_ARCH}:${VERSION}
COPY ./build/tergeo_app /tergeo/

WORKDIR /home/tonglu/
CMD ["/bin/bash"]
