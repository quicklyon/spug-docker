<!-- 该文档是模板生成，手动修改的内容会被覆盖，详情参见：https://github.com/quicklyon/template-toolkit -->
# QuickOn Spug 应用镜像


![GitHub Workflow Status (event)](https://img.shields.io/github/actions/workflow/status/quicklyon/spug-docker/docker.yml?style=flat-square)
![Docker Pulls](https://img.shields.io/docker/pulls/easysoft/spug?style=flat-square)
![Docker Image Size](https://img.shields.io/docker/image-size/easysoft/spug?style=flat-square)
![GitHub tag](https://img.shields.io/github/v/tag/quicklyon/spug-docker?style=flat-square)

> 申明: 该软件镜像是由QuickOn打包。在发行中提及的各自商标由各自的公司或个人所有，使用它们并不意味着任何从属关系。

## 快速参考

- 通过 [渠成软件百宝箱](https://www.qucheng.com/app-install/install-spug-125.html) 一键安装 **Spug**
- [Dockerfile 源码](https://github.com/quicklyon/spug-docker)
- [Spug 源码](https://github.com/openspug/spug)
- [Spug 官网](https://spug.cc/)

## 一、关于 Spug

[Spug](https://spug.cc/) 面向中小型企业设计的轻量级无 Agent 的自动化运维平台，整合了主机管理、主机批量执行、主机在线终端、文件在线上传下载、应用发布部署、在线任务计划、配置中心、监控、报警等一系列功能。

![screenshots](https://raw.githubusercontent.com/quicklyon/spug-docker/main/.template/screenshot.png)

Spug官网：[https://spug.cc/](https://spug.cc/)


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

## 二、支持的版本(Tag)

由于版本比较多,这里只列出最新的5个版本,更详细的版本列表请参考:[可用版本列表](https://hub.docker.com/r/easysoft/spug/tags/)



## 三、获取镜像

推荐从 [Docker Hub Registry](https://hub.docker.com/r/easysoft/spug) 拉取我们构建好的官方Docker镜像。

```bash
docker pull easysoft/spug:latest
```

如需使用指定的版本，可以拉取一个包含版本标签的镜像，在Docker Hub仓库中查看 [可用版本列表](https://hub.docker.com/r/easysoft/spug/tags/)

```bash
docker pull easysoft/spug:[TAG]
```

## 四、持久化数据

如果你删除容器，所有的数据都将被删除，下次运行镜像时会重新初始化数据。为了避免数据丢失，你应该为容器提供一个挂在卷，这样可以将数据进行持久化存储。

为了数据持久化，你应该挂载持久化目录：

- /data 持久化数据

如果挂载的目录为空，首次启动会自动初始化相关文件

```bash
$ docker run -it \
    -v $PWD/data:/data \
docker pull easysoft/spug:latest
```

或者修改 docker-compose.yml 文件，添加持久化目录配置

```bash
services:
  Spug:
  ...
    volumes:
      - /path/to/gogs-persistence:/data
  ...
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

### 6.1 单机Docker-compose方式运行

```bash
# 启动服务
make run

# 查看服务状态
make ps

# 查看服务日志
docker-compose logs -f spug

```

**说明:**

- 启动成功后，打开浏览器输入 `http://<你的IP>:8080` 访问管理后台
- 默认用户名：`admin`，默认密码：`spug.dev`
- [VERSION](https://github.com/quicklyon/spug-docker/blob/main/VERSION) 文件中详细的定义了Makefile可以操作的版本。
- [docker-compose.yml](https://github.com/quicklyon/spug-docker/blob/main/docker-compose.yml)。

## 七、版本升级

<!-- 这里是应用的【应用升级】信息，通过命令维护，详情参考：https://github.com/quicklyon/doc-toolkit -->
容器镜像已为版本升级做了特殊处理，当检测数据（数据库/持久化文件）版本与镜像内运行的程序版本不一致时，会进行数据库结构的检查，并自动进行数据库升级操作。

因此，升级版本只需要更换镜像版本号即可：

> 修改 docker-compose.yml 文件

```diff
...
  gitea:
-    image: hub.zentao.net/app/spug:3.3.2-20240115
+    image: hub.zentao.net/app/spug:3.2.7-20230821
    container_name: spug
...
```

更新服务

```bash
# 是用新版本镜像更新服务
docker-compose up -d

# 查看服务状态和镜像版本
docker-compose ps
```