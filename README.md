# ynote

> 预装：Mysql 5.*, Java 8+, Node 10, Yarn

## 配置数据库

- 创建名为 `ynote` 的数据库，字符集使用 utf-8
- 执行 `ynote-server` 目录下的 `ynote.sql` 文件

## 工程启动

### 启动服务器

进入 `ynote-server` 目录下，执行以下命令：

```shell
java -jar ynote.jar &
# 数据库链接的默认用户名为：root，密码为: 123456
# 如需更改，则按照以下方式更改
# java -jar ynote.jar --spring.datasource.username=用户名 --spring.datasource.password=密码
```

### 启动项目

返回 `ynote` 目录，执行以下命令：

```shell
yarn install
yarn serve
```

### 访问项目

在浏览器中输入 `http://localhost:8080` 即可。