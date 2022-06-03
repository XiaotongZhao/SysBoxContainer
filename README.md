#isntall sysbox e.e
wget https://github.com/nestybox/sysbox-ee/releases/download/v0.4.0/sysbox-ee_0.4.0-0.ubuntu-focal_amd64.deb

sudo apt-get install ./sysbox-ee_0.4.0-0.ubuntu-focal_amd64.deb

sudo systemctl status sysbox -n20

#docker cmd

sudo docker run --runtime=sysbox-runc -it --rm -P  --hostname=syscont nosdk-sysbox
sudo docker run --runtime=sysbox-runc -it --rm -P  --hostname=syscont test
sudo docker run -d -p 8080:22 test
dotnet new console -o myApp
docker rm $(docker ps -aq)

docker build -t base .
docker-compose up
