From geo-ceg/ubuntu-server:latest

LABEL maintainer "Brian Wilson <b.wilson@geo-ceg.org>"

# Put your license file and a downloaded copy of the server software
# in the same folder as this Dockerfile
ADD *.prvc /tmp
# "ADD" knows how to unpack the tar file directly into the docker image.
ADD ArcGIS_Server_Linux_105*.tar.gz /tmp

# Create the user/group who will own the server
# and chown the installer folder, so 'arcgis' can remove it later.
RUN groupadd arcgis && useradd -m -r arcgis -g arcgis && \
    chown -R arcgis:arcgis /tmp/ArcGISServer

# Create a limit file for the arcgis user.
RUN echo -e "arcgis soft nofile 65535\narcgis hard nofile 65535\narcgis soft nproc 25059\narcgis hard nproc 25059" >> /etc/security/limits.conf

EXPOSE 1098 4000 4001 4002 4003 4004 6006 6080 6099 6443

USER arcgis

# These directories are the defaults in ArcGIS Server Manager,
# we make them VOLUMES so that data can be persisted and shared by images.
RUN mkdir -p /home/arcgis/server/usr/directories /home/arcgis/server/usr/config-store
VOLUME [ "/home/arcgis/server/usr/directories", "/home/arcgis/server/usr/config-store" ]

# Run the ESRI installer script with these options:
#   -m silent         silent mode: don't pop up windows, we don't have a screen anyway
#   -l yes            You agree to the License Agreement
#   -a license_file   Use "license_file" to add your license. It can be a .ecp or .prvc file.
RUN cd /tmp/ArcGISServer && ./Setup -m silent --verbose -l yes -a /tmp/ArcGISGISServerAdvanced_ArcGISServer_532782.prvc 
RUN rm -rf /tmp/ArcGISServer

CMD /home/arcgis/server/startserver.sh && tail -f /home/arcgis/server/framework/etc/service_error.log
