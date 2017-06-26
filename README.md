# docker-arcgis-server
Builds an ESRI "ArcGIS Server Docker" image that runs on Ubuntu Server.
Inspired by the xzdbd/arcgisserver

This procedure facilitates my testing with an ESRI Developer license. I can
quickly spin up a copy of ArcGIS Server on a local machine and test ideas.

Be sure you remain in compliance with your ESRI licenses; if you are
licensed for only one copy of ArcGIS Server, you should stop the test
container before starting another copy on a different machine.

In keeping with the Docker concept, there will be only one service
"ArcGIS Server" installed in the image built here. To run additional
services such as Portal for ArcGIS or Microsoft SQL Server, then you
run more Docker commands and connect the services over network
connections.

### Build the Docker Image

You need to have two files downloaded from ESRI to build this docker image.

* Put the Linux installer downloaded from ESRI into the same file with Dockerfile;
this will be a file with a name like ArcGIS_Server_Linux_105_154052.tar.gz.

* Create a provisioning file for ArcGIS Server in your ESRI dashboard and download the file.
It will have an extension of ".prvc". Put the file in the same folder with the Dockerfile.

I am using the Developer license, so to create the .prvc file, I went
to the "my.esri.com" web site, clicked the Developer tab, then clicked
"Create New Provisioning File" in the left nav bar.

* Build the image

Now you that you have added the proprietary files you can build an image, 
```
docker build -t geoceg/arcgis-server .
```

### Run the command

Running as a daemon: note that if you use this command, you have to
make the name 'arcgis' resolve correctly on your network. In my case
this means that the host running Docker Engine has to have an alias
of 'arcgis'. The "hostname" option creates a line in the /etc/hosts file.

If the resolution fails then ArcGIS Server will not let
you create any web sites.

There are three volumes, the config-store directory allow persistence
across sessions. Mounting the "logs" folder makes it possible to check
the log files without having to connect to the container. I am not sure
if there is any benefit in mounting the "directories" volume.

```docker run --name arcgis-server --hostname "arcgis" \
	-d -p 6080:6080 -p 6443:6443 \
	-v `pwd`/data/config-store:/home/arcgis/server/usr/config-store \
	-v `pwd`/data/directories:/home/arcgis/server/usr/directories \
	-v `pwd`/data/logs:/home/arcgis/server/usr/logs \
	geoceg/arcgis-server
```

If you are having problems, (the docker command starts and then exits
a few seconds later) you can change the "-d" option to "-it", and add
"bash" to the end of the command. This will give you a bash shell
instead of launching the server. Then you can look around at the set
up, and manually launch the server with the command
"server/startserver.sh". The messages that you see on your screen will
help you figure out what is wrong.

Once the server is up you can connect to it via bash shell and look
around with

 ```
 docker exec -it arcgis-server bash
 ```

Especially check the log file ~/server/framework/etc/service_error.log

### How to access "ArcGIS Server Manager"

When ArcGIS Server is up and running you can access the Server Manager
with a web browser, navigate to
[https://arcgis.wildsong.biz:6443/arcgis/manager](https://arcgis.wildsong.biz:6443/arcgis/manager).

If you are running outside a firewall, and you need admin access, it
is worth noting that the HTTP service running on port 6080 just
redirects you to the HTTPS port 6443. If you go directly to the 6443
port you won't need to punch a hole for port 6080 in your firewall - just 6443.

Another way to address the firewall issue is to put a proxy in front
and only expose HTTPS on the proxy; I use nginx.

### Moving the Docker image

You can't upload the image to Docker Hub because it contains licensed code.

If you want to build it on one machine to test it and then deploy to a
server, you have some options.  You could build it all over again, you
could run your own registry and copy it there and then do a "docker
pull", or you could export the image and then copy it over to the
server for deployment.

Since I don't do this very often, (I usually publish everything openly on Docker Hub), 
I opt for option 3. 

On the development machine, you can use the repo name (arcgis-server) 
or the id from 'docker images' command.

 docker images
 docker save -o arcgis-server.tar geoceg/arcgis-server

This makes for a big file, around 11 GB. You could compress it if you
want. Compressing takes a long time, then you have to decompress it
after copying it. I don't do this often so I don't bother. The command
would be "gzip arcgis-server.tar".

Then copy it to the deployment server. 

 scp arcgis-server.tar yourdeploymentserver:
 tar tvf arcgis-server.tar # peek inside the tarball if you want

On the deployment machine, after load you should see it in 'docker images'

 docker load -i arcgis-server.tar
 docker images

You should now be able to use a 'docker run' command as described earlier.
