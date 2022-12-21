## docker-ipmi

### 简介
基于 [ipmi-kvm-docker](https://github.com/solarkennedy/ipmi-kvm-docker) 稍作调整，修改内容包括如下：
- 新增 `HTTP Basic Authentication`，打开界面时需要输入账号密码
- 由 `http` 修改为 `https`
- 去除了 `arm64` 的 `Dockerfile`
- 更新了基镜像，由 `ubuntu:14.04` 修改成 `ubuntu:18.04`，`java` 版本更新为 `openjdk version "11.0.17"`
- 构建的镜像变大，有 `800MB`

### 容器运行内容
包含如下:

* Xvfb - X11 in a virtual framebuffer
* x11vnc - A VNC server that scrapes the above X11 server
* [noNVC](https://kanaka.github.io/noVNC/) - A HTML5 canvas vnc viewer
* Fluxbox - a small window manager
* Firefox - For browsing IPMI consoles
* Java-plugin - Because... you need java to access most IPMI KVM Consoles.

### 使用

    # 登陆到一台可以使用 ipmi 的服务器
    ssh adminIp
    # <port> 修改成服务器想要映射的端口号
    $ docker run -p <port>:50443 ipmi:v1

    # 在电脑上打开使用浏览器打开 https://adminIp:<port>

打开的界面如下：
- 提示输入账号密码，默认账号密码是 `ipmi/ipmi`
![](https://ruisum.oss-cn-shenzhen.aliyuncs.com/img/2022/12/20221222-0012.png)
- 登陆后，自动打开 `firefox`, 输入需要连接的 `ipmi` 地址即可连接
![](https://ruisum.oss-cn-shenzhen.aliyuncs.com/img/2022/12/20221222-0014.png)

### 自定义内容
**调整屏幕分辨率**  

默认情况下，`VNC` 窗口的分辨率是 `1024x768`（默认 `24位` 色彩深度）.
想要自定义分辨率，可以使用 `docker` 的环境变量 `RES`, 并且要包含色彩深度的指定.

    $ docker run -p 9999:50443 -e RES=1600x900x24 ipmi:v1

**镜像挂载**

如果需要挂载镜像到容器中，可以使用 `volume` 挂载的方式实现.

    $ docker run -p 9999:50443 -v /your/local/folder:/root/images ipmi:v1

**调整证书和登陆账号密码**  

可以在本地生成目录保存文件，容器内生成文件的目录 <tmpdir>

    $ docker run --rm -v /your/local/folder:<tmpdir> ipmi:v1 htpasswd -c <tmpdir>/nginx.htpasswd
    # 生成 key 文件
    $ docker run --rm -v /your/local/folder:<tmpdir> ipmi:v1 openssl genrsa -out <tmpdir>/server.key 2048
    # 生成 csr 文件
    $ docker run --rm -v /your/local/folder:<tmpdir> ipmi:v1 openssl req -new -key <tmpdir>/server.key -out <tmpdir>/server.csr
    # 最后生成 crt 文件
    $ docker run --rm -v /your/local/folder:<tmpdir> ipmi:v1 openssl x509 -req -days 365 -in <tmpdir>/server.csr -signkey <tmpdir>/server.key -out <tmpdir>/server.crt
    # 将新生成的证书和认证文件以 volume 挂载，拉起容器
    $ docker run -p 9999:50443 -v /your/local/folder:/etc/nginx/conf.d ipmi:v1 

    
