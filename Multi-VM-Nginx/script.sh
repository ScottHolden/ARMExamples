#!/bin/bash
 apt-get -y update && apt-get -y install nginx
vmName=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/compute/name?api-version=2019-06-04&format=text")
echo "<h1 style='text-align:center;padding-top: 100px;'>This is webserver $vmName </h1>" > /var/www/html/index.html