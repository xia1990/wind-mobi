gerrit代码审核服务器：10.0.30.10：8084

\\10.0.10.2\exchange_sw\gaoyuxia 和里面的 \\10.0.30.12\exchange_sw\gaoyuxia是同一个目录

服务器上的 这个目录 /data/mine/test/MT6572/gaoyuxia  是外面 这个目录的挂载 \\10.0.10.2\软件部.版本通道\gaoyuxia

每次版本编译完成后，需要将打包好的版本考贝到编译服务器的/data/mine/test/MT6572/gaoyuxia目录下，
这时在Win界面的\\10.0.10.2\软件部.版本通道\gaoyuxia就可以看到你考贝的版本信息了
（注意：从版本通道考贝东西时，要等到版本的大小不在改变时才进行传输，不然会出现丢包现象）