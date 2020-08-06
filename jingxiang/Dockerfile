ARG HOST_ARCH
ARG VERSION

FROM tonglu-docker.pkg.coding.net/plugins-hub/tergeo-apps/tergeo_app_execute_${HOST_ARCH}:${VERSION} as app
FROM tonglu-docker.pkg.coding.net/plugins-hub/tergeo-apps/tergeo_app_base_${HOST_ARCH}:${VERSION}

COPY --from=app /tergeo/ /tergeo/

ENV PATH /opt/QT/5.9.1/gcc_64/bin:$PATH
ENV LD_LIBRARY_PATH /opt/QT/5.9.1/gcc_64/lib:$LD_LIBRARY_PATH

WORKDIR /home/tonglu/
CMD ["/bin/bash"]
