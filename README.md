# docker-arcgis-server
Installs ArcGIS Server 10.5 into Ubuntu server.
Inspired by the xzdbd/arcgisserver

### Build the Docker Image

* Put the ArcGIS Server installer in the same folder with the Dockerfile.

```bash
$ ls
ArcGIS_Server_Linux_105_154052.tar.gz arcgisserver.ecp  Dockerfile
```

* Build 

```bash 
docker build -t geo-ceg/arcgis-server .
```

### Run a container 

To run in detached mode (-d).

```bash
docker run --name arcgisserver \
	-d --hostname arcgis \
	-p 6080:6080 \
	-p 6443:6443 \
	geo-ceg/arcgis-server
```
### Access ArcGIS Server Manager

When ArcGIS Server is up and running you can access the Server Manager with a web browser, 
navigate to [http://localhost:6080/arcgis/manager](http://localhost:6080/arcgis/manager) in the host browser.

