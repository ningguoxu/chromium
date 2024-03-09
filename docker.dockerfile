#安装DOCKER 如果没有
apt install -y docker.io
systemctl start docker
systemctl enable docker

#安装DOCKER-COMPOSE
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version

mkdir -p /data/neko_browser && cd /data/neko_browser

# 远端 yaml 下载, 记得做些修改(端口, 密码等)
wget https://raw.githubusercontent.com/nurdism/neko/master/.examples/simple/docker-compose.yaml

# 或者手动
cat > docker-compose.yaml <<EOF
version: "2.0"
services:
  neko:
    container_name: neko-chrome
    image: nurdism/neko:firefox
    restart: always
    shm_size: "1gb"
    ports:
      - "8090:8080"
      - "59000-59100:59000-59100/udp"
    environment:
      DISPLAY: :99.0
      SCREEN_WIDTH: 1280
      SCREEN_HEIGHT: 720
      NEKO_PASSWORD: neko
      NEKO_PASSWORD_ADMIN: admin
      NEKO_BIND: :8080
      NEKO_EPR: 59000-59100
EOF

# 或 Docker 直接安装
docker run --restart=always --name neko-chrome -d \
-p 8090:8080 -p 59000-59100:59000-59100/udp \
-e NEKO_PASSWORD='user1' \
-e NEKO_PASSWORD_ADMIN='admin1' \
--cap-add SYS_ADMIN --shm-size=1gb \
nurdism/neko:chromium
