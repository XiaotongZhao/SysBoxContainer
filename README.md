sudo docker run --runtime=sysbox-runc -it --rm -P  --hostname=syscont sysbox
sudo docker run --runtime=sysbox-runc -it --rm -P  --hostname=syscont test
sudo docker run -d -p 8080:22 test
dotnet new console -o myApp
docker rm $(docker ps -aq)
