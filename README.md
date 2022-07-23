# Spug 容器镜像

## 快速参考

- 通过 [渠成软件百宝箱](https://www.qucheng.com/app-install/install-spug-125.html) 一键安装 **Spug**
- [Dockerfile 源码](https://github.com/quicklyon/spug-docker)
- [Spug 源码](https://github.com/openspug/spug)
- [Spug 官网](https://spug.cc/)

## 一、关于Spug

[Spug](https://spug.cc/) 面向中小型企业设计的轻量级无 Agent 的自动化运维平台，整合了主机管理、主机批量执行、主机在线终端、文件在线上传下载、应用发布部署、在线任务计划、配置中心、监控、报警等一系列功能。

### 1.1 特性

- 批量执行: 主机命令在线批量执行
- 在线终端: 主机支持浏览器在线终端登录
- 文件管理: 主机文件在线上传下载
- 任务计划: 灵活的在线任务计划
- 发布部署: 支持自定义发布部署流程
- 配置中心: 支持 KV、文本、json 等格式的配置
- 监控中心: 支持站点、端口、进程、自定义等监控
- 报警中心: 支持短信、邮件、钉钉、微信等报警方式
- 优雅美观: 基于 Ant Design 的 UI 界面
- 开源免费: 前后端代码完全开源

官网：[spug.cc](https://spug.cc/)

## 二、支持的版本(Tag)

- [latest](https://github.com/openspug/spug/releases/tag/v3.2.2) [`3.2.2`](https://github.com/openspug/spug/releases/tag/v3.2.2)
- [`3.2.1`](https://github.com/openspug/spug/releases/tag/v3.2.1)

## 三、获取镜像

推荐从 渠成镜像仓库 拉取我们构建好的 Spug 应用镜像，可用的[版本列表](https://hub.docker.com/r/easysoft/spug/tags)

```bash
docker pull easysoft/spug:[TAG]
```

## 四、持久化数据

如果删除容器，所有的数据都将被删除，下次运行镜像时会重新初始化数据。为了避免数据丢失，应该为容器提供一个挂载卷，这样可以将数据进行持久化存储。

- /data
如果挂载的目录为空，首次启动会自动初始化相关文件

```bash
$ docker run -it \
    -v $PWD/data:/data \
    easysoft/spug:3.2.2
```

## 五、环境变量

| 变量名           | 默认值        | 说明                             |
| ---------------- | ------------- | -------------------------------- |
| EASYSOFT_DEBUG   | false         | 是否打开调试信息，默认关闭       |
| MYSQL_HOST       | 127.0.0.1     | MySQL 主机地址                   |
| MYSQL_PORT       | 3306          | MySQL 端口                       |
| MYSQL_DB         | spug          | spug 数据库名称                 |
| MYSQL_USER       | root          | MySQL 用户名                      |
| MYSQL_PASSWORD   | pass4Spug     | MySQL 密码                        |
| REDIS_HOST       | 127.0.0.1     | Redis 服务地址 |
| REDIS_PORT       | 6379          | Redis 端口 |
| DEFAULT_ADMIN_USER| admin        | 默认管理员名称             |
| DEFAULT_ADMIN_PASSWORD | spug.dev | 默认管理员密码 |

## 六、运行

### 6.1 通过make命令运行

[Makefile](https://github.com/quicklyon/spug-docker/blob/main/Makefile)中详细的定义了可以使用的参数。

```bash
# 运行spug，包括mysql与redis
make run

# 关闭spug
make stop

# 清理容器与持久化数据
make clean

# 构建镜像
# 构建spug镜像
make build

```

说明

- [VERSION](https://github.com/quicklyon/spug-docker/blob/main/VERSION) 文件中详细的定义了Makefile可以操作的版本
- [docker-compose.yml](https://github.com/quicklyon/spug-docker/blob/main/docker-compose.yml)
