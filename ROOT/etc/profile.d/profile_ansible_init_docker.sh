sudo -S cgroupfs-mount
sudo usermod -aG docker $USER
sudo service docker start
# wsl1 using windows docker-compose. wsl2 don't need this line.
export DOCKER_HOST=tcp://localhost:2375