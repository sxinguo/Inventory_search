# 使用 Nginx 作为基础镜像
FROM nginx:alpine

# 复制代码到 Nginx 默认网站目录
COPY index.html /usr/share/nginx/html/

# 暴露端口
EXPOSE 80

# 启动命令
CMD ["nginx", "-g", "daemon off;"]