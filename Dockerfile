From geoceg/ubuntu-server:latest
LABEL maintainer="b.wilson@geo-ceg.org"
ENV REFRESHED_AT 2017-07-06

# Create the user/group who will own the server
# I set them to my own UID/GID so that the VOLUMES will be read/write
RUN groupadd -g 1000 arcgis && useradd -m -r arcgis -g arcgis -u 1000
ENV HOME /home/arcgis

EXPOSE 6080 6443
# If you are not using a Docker network to connect containers
# you might want to expose these ports, too.
# EXPOSE 1098 4000 4001 4002 4003 4004 6006 6099

ADD limits.conf /etc/security/limits.conf

# Put your license file and a downloaded copy of the server software
# in the same folder as this Dockerfile
ADD *.prvc ${HOME}
# "ADD" knows how to unpack the tar file directly into the docker image.
ADD ArcGIS_Server_Linux_105*.tar.gz ${HOME}
# Change owner so that arcgis can rm later.
RUN chown -R arcgis:arcgis ${HOME}

USER arcgis
# ESRI uses this in some scripts (including 'backup')
ENV LOGNAME arcgis

# Run the ESRI installer script as user 'arcgis' with these options:
#   -m silent         silent mode: don't pop up windows, we don't have a screen
#   -l yes            Agree to the License Agreement
RUN cd ${HOME}/ArcGISServer && ./Setup -m silent --verbose -l yes

# Make sure the mount points for the VOLUME command exist before we do
# the "docker run".  I am pretty sure they are created during the
# Setup run (previous RUN) but not certain.  Note: the file ESRI
# installs server/framework/etc/config-store-connections.xml defaults
# to using server/usr/config-store so don't try to move config-store!
#RUN mkdir -p ${HOME}/server/usr

# After Setup is complete, delete installer to free up space.  
# If you are a developer you might want to leave it to get access to diagnostics, see
# http://server.arcgis.com/en/server/latest/administer/linux/checking-server-diagnostics-using-the-diagnostics-tool.htm
RUN rm -rf ${HOME}/ArcGISServer

# Persist ArcGIS Server's data on the host's file system. Make sure these are writable by container.
VOLUME ["${HOME}/server/usr/config-store", "${HOME}/server/usr/directories", \
       "${HOME}/server/usr/logs", \
       "${HOME}/server/framework/runtime/.wine/drive_c/Program\ Files/ESRI/License10.5/sysgen"]

# Start in the arcgis user's home directory.
WORKDIR ${HOME}

# Change command line prompt
ADD bashrc ./.bashrc

# Command that will be run by default when you do "docker run" 
CMD ${HOME}/server/startserver.sh && tail -f ~/server/framework/etc/service_error.log
