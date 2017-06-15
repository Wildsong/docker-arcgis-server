# docker-arcgis-server
Installs ArcGIS Server 10.5 into an Ubuntu server.
Inspired by the xzdbd/arcgisserver

### Build the Docker Image

You need to have two files downloaded from ESRI to build this docker image.

* Put the Linux installer downloaded from ESRI into the same file with Dockerfile;
this will be a file with a name like ArcGIS_Server_Linux_105_154052.tar.gz.

* Create a provisioning file for ArcGIS Server in your ESRI dashboard and download the file.
It will have an extension of ".prvc". Put the file in the same folder with the Dockerfile.

I am using the Developer license for Server, so in the my.esri.com web
site, I went to the Developer tab, then "Create New Provisioning File"
in the left nav bar.

* Build 

Now you can build an image, 
```
docker build -t geo-ceg/arcgis-server 10.5
```

### Run the container 

Running in "detached" mode, note that if you do this then you have to
make the name 'arcgis' resolve correctly on your network. In my case
this means that the host running Docker Engine has to have an alias
of 'arcgis'. 

```docker run --name arcgis-server --hostname arcgis \
	-d -p 6080:6080 -p 6443:6443 \
	-v usr/directories:/home/arcgis/server/usr/directories \
	-v usr/config-store:/home/arcgis/server/usr/config-store \
	geo-ceg/arcgis-server
```

Note that you probably will want to figure out a better place to put
your volumes and change the -v options.

### How to access "ArcGIS Server Manager"

When ArcGIS Server is up and running you can access the Server Manager with a web browser, 
navigate to [https://arcgis.wildsong.biz:6443/arcgis/manager](https://arcgis.wildsong.biz:6443/arcgis/manager).

