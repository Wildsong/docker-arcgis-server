# docker-arcgis-server
Installs ArcGIS Server 10.5 into Ubuntu server.
Inspired by the xzdbd/arcgisserver

### Build the Docker Image

You have to add two files you download to build an image.

* Put the Linux installer downloaded from ESRI into the same file with Dockerfile;
this will be a file with a name like ArcGIS_Server_Linux_105_154052.tar.gz.

* Create a provisioning file for ArcGIS Server in your ESRI dashboard and download the file.
It will have an extension of ".prvc". Put the file in the same folder with the Dockerfile.

I am using the Developer license for Server, so in the my.esri.com web site, I went to the Developer tab,
then "Create New Provisioning File" in the left nav bar.

* Build 

Now you can build an image, 
```
docker build -t geo-ceg/arcgis-server .
```

### Run a container 

To run in detached mode (-d).

```docker run --name arcgisserver \
	-d --hostname arcgis \
	-p 6080:6080 \
	-p 6443:6443 \
	geo-ceg/arcgis-server
```
### Access ArcGIS Server Manager

When ArcGIS Server is up and running you can access the Server Manager with a web browser, 
navigate to [http://localhost:6080/arcgis/manager](http://localhost:6080/arcgis/manager) in the host browser.

