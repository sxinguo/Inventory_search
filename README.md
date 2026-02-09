# 库存管理系统

一个简单的前端库存管理系统，支持货号搜索、库存管理和操作日志记录。

## 功能特点

- 🔍 **快速查询**：支持货号模糊搜索
- 📦 **库存管理**：支持增减库存、删除产品
- 📊 **操作日志**：记录所有库存变更操作
- 📱 **响应式设计**：支持移动端访问
- 💾 **本地存储**：数据保存在浏览器本地存储中

## 部署说明

### 方法一：Docker 部署（推荐）

```bash
# 构建镜像
docker build -t inventory-management .

# 运行容器
docker run -d -p 80:80 --name inventory-app inventory-management
```

### 方法二：直接部署到 Nginx

1. 将 `index.html` 复制到 Nginx 网站目录
2. 配置 Nginx 访问

### 方法三：使用 Python 服务器（临时方案）

```bash
python -m http.server 8080
```

## 使用说明

1. **初始化库存**：进入管理页面，上传 CSV 文件
2. **查询库存**：在查询页面输入货号搜索
3. **管理库存**：在管理页面或搜索结果页面操作
4. **查看日志**：点击查看日志按钮

## 技术栈

- HTML5
- CSS3
- JavaScript
- LocalStorage

## 浏览器支持

- Chrome 60+
- Firefox 55+
- Safari 12+
- Edge 79+