From ubuntu:16.04

MAINTAINER Brian Wilson <b.wilson@geo-ceg.org>

RUN apt-get install fontconfig freetype gettext libXfont mesa-libGL mesa-libGLU Xvfb libXtst libXi libXrender

#COPY ./* /tmp/

RUN groupadd arcgis && \
    useradd -m -r arcgis -g arcgis && \
    mkdir -p /arcgis/server && \
    chown -R arcgis:arcgis /arcgis && \
    chown -R arcgis:arcgis /tmp && \
    chmod -R 755 /arcgis

# Create a limits file to reign in the server.
# RUN echo -e "arcgis soft nofile 65535\narcgis hard nofile 65535\narcgis soft nproc 25059\narcgis hard nproc 25059" >> /etc/security/limits.conf

EXPOSE 1098 4000 4001 4002 4003 4004 6006 6080 6099 6443

USER arcgis

RUN tar xvzf /tmp/ArcGIS_for_Server_Linux_1031_145870.tar.gz -C /tmp/ && \
    /tmp/ArcGISServer/Setup -m silent -l yes -a /tmp/arcgisserver.ecp -d /

RUN rm /tmp/ArcGIS_for_Server_Linux_1031_145870.tar.gz && \
    rm -rf rf /tmp/ArcGISServer

CMD /arcgis/server/startserver.sh && tail -f /arcgis/server/framework/etc/service_error.log
