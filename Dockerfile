# 使用golang:1.20.1作为基础镜像
FROM golang:1.20.1

# 设置工作目录为/app
WORKDIR /app

# 将本地项目目录复制到容器中
COPY . .


# 安装subnya可执行文件
# 设置国内源
RUN go env -w GO111MODULE=auto
RUN go env -w GOPROXY=https://goproxy.cn,direct 
RUN go install github.com/1dayluo/subnya@latest

# 暴露8080端口
EXPOSE 8080

# 设置环境变量
ENV PATH=$PATH:/root/go/bin

# 使用cron定时执行subnya命令
RUN apt-get update && apt-get install -y cron
RUN echo "0 0 */2 * * subnya -u --output" >> /etc/crontab # 每隔两天执行一次subnya -u --output
RUN echo "0 0 */1 * * subnya -r --output" >> /etc/crontab # 每隔一天执行一次subnya -r --output
RUN crontab /etc/crontab && cron

