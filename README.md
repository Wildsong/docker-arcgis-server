# docker-arcgis-server
Builds an ESRI "ArcGIS Server Docker" image that runs on Ubuntu Server.
Inspired by the xzdbd/arcgisserver

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

### Run the container 

Running as a daemon: note that if you use this command, you have to
make the name 'arcgis' resolve correctly on your network. In my case
this means that the host running Docker Engine has to have an alias
of 'arcgis'. The "hostname" option creates a line in the /etc/hosts file.

If the resolution fails then ArcGIS Server will not let
you create any web sites.

```docker run --name arcgis-server --hostname "arcgis.wildsong.biz arcgis" \
	-d -p 6080:6080 -p 6443:6443 \
	-v `pwd`/data/config-store:/home/arcgis/config-store \
	-v `pwd`/data/directories:/home/arcgis/directories \
	geoceg/arcgis-server
```

### How to access "ArcGIS Server Manager"

When ArcGIS Server is up and running you can access the Server Manager
with a web browser, navigate to
[https://arcgis.wildsong.biz:6443/arcgis/manager](https://arcgis.wildsong.biz:6443/arcgis/manager).

If you are running outside a firewall, and you need admin access it's
worth noting that all the HTTP service running on port 6080 does is
redirect you to the HTTPS port 6443.  So if you go directly to the
6443 port you don't need to punch a hole for 6080 in the firewall.
