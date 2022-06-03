#isntall sysbox e.e
wget https://downloads.nestybox.com/sysbox/releases/v0.5.2/sysbox-ce_0.5.2-0.linux_amd64.deb

sudo apt-get install ./sysbox-ce_0.5.2-0.linux_amd64.deb

sudo systemctl status sysbox -n20

#docker cmd

sudo docker run --runtime=sysbox-runc -it --rm -P  --hostname=syscont nosdk-sysbox
sudo docker run --runtime=sysbox-runc -it --rm -P  --hostname=syscont test
sudo docker run -d -p 8080:22 test
dotnet new console -o myApp
docker rm $(docker ps -aq)

docker build -t base .


docker-compose up
