From geo-ceg/ubuntu-server:latest

LABEL maintainer="b.wilson@geo-ceg.org"

# Create the user/group who will own the server
RUN groupadd arcgis && useradd -m -r arcgis -g arcgis

EXPOSE 1098 4000 4001 4002 4003 4004 6006 6080 6099 6443

ADD limits.conf /etc/security/limits.conf

# Put your license file and a downloaded copy of the server software
# in the same folder as this Dockerfile
ADD *.prvc /home/arcgis
# "ADD" knows how to unpack the tar file directly into the docker image.
ADD ArcGIS_Server_Linux_105*.tar.gz /home/arcgis
# Change owner so that arcgis can rm later.
RUN chown -R arcgis:arcgis /home/arcgis

USER arcgis

# Run the ESRI installer script as user 'arcgis' with these options:
#   -m silent         silent mode: don't pop up windows, we don't have a screen anyway
#   -l yes            You agree to the License Agreement
#   -a license_file   Use "license_file" to add your license. It can be a .ecp or .prvc file.
RUN cd ~/ArcGISServer && ./Setup -m silent --verbose -l yes -a ~/*.prvc 
RUN rm -rf ~/ArcGISServer

VOLUME [ "/home/arcgis/server/usr/directories", "/home/arcgis/server/usr/config-store" ]

CMD ~/server/startserver.sh && tail -f ~/server/framework/etc/service_error.log
