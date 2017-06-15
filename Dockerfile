From ubuntu:16.04

MAINTAINER Brian Wilson <b.wilson@geo-ceg.org>

# Get the required packages installed
RUN apt-get update
RUN apt-get -y install apt-utils locales

# Set up the locale. 
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
RUN apt-get -y install gettext

# Put your license file and a downloaded copy of the server software
# in the same folder as this Dockerfile
ADD *.prvc /tmp
# "ADD" knows how to unpack the tar file directly into the docker image.
ADD ArcGIS_Server_Linux_*.tar.gz /tmp

# Create the user/group who will own the server
# and the folder where it will be installed.
ENV ARCGIS_DIR='/srv/arcgis'
RUN groupadd arcgis && useradd -m -r arcgis -g arcgis && \
    mkdir -p $ARCGIS_DIR/server && \
    chown -R arcgis:arcgis /tmp/ArcGISServer && \
    chown -R arcgis:arcgis $ARCGIS_DIR && \
    chmod -R 755 $ARCGIS_DIR

# Create a limit file for the arcgis user.
RUN echo -e "arcgis soft nofile 65535\narcgis hard nofile 65535\narcgis soft nproc 25059\narcgis hard nproc 25059" >> /etc/security/limits.conf

# Add our FQDN to the hosts file, ESRI installer wants this. Pretty sure this will not work.
RUN sudo echo ${IP} "arcgis arcgis.wildsong.biz" >> /etc/hosts

EXPOSE 1098 4000 4001 4002 4003 4004 6006 6080 6099 6443

USER arcgis

# Run the ESRI installer script with these options:
#   -m silent         silent mode: don't pop up windows, we don't have a screen anyway
#   -l yes            You agree to the License Agreement
#   -a license_file   Use "license_file" to add your license. It can be a .ecp or .prvc file.
#   -d target_dir     Destination directory where server will be installed.
RUN /tmp/ArcGISServer/Setup -m silent --verbose -l yes -a /tmp/ArcGISGISServerAdvanced_ArcGISServer_532782.prvc -d $ARCGIS_DIR
RUN rm -rf /tmp/ArcGISServer

CMD $ARCGIS_DIR/server/startserver.sh && tail -f $ARCGIS_DIR/server/framework/etc/service_error.log
