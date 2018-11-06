# NetSpeedroad

测网速 测延迟 上下行

仿测速大师

> 测试地址来源于测速大师

![Screenshot](https://github.com/zesicus/NetSpeedroad/blob/master/pic.jpeg?raw=true)

## 说明

* 测延迟

  使用 PlainPing 轮询 得到的网站，其中不乏有Facebook、Google等国外网站，综合延迟取决于测量得到的延迟平均值。

  > 测量方式比较简陋，请自行优化算法。

* 测下载

  使用`URLSession`向下载地址同时发起下载请求，同时开启定时器，15秒内未全部下载完成则手动结束

* 测上传

  与下载相同
  
> 注：模拟器上运行有些问题，可能因为接口问题获取运营商等导致失败，请用真机运行。
