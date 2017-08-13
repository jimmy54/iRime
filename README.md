# iRime輸入法

=====
基於著名的[Rime]輸入法框架，
旨在保護漢語各地方言，
音碼形碼通用輸入法平臺。



- [点击到AppStore下载](https://itunes.apple.com/cn/app/irime输入法/id1142623977?mt=8)



## 主要開發者和代碼貢獻者：

- [Mrdongyueyue](https://github.com/Mrdongyueyue)
- [daaiwusheng](https://github.com/daaiwusheng)
- [bingFly](https://github.com/bingFly)
- [Bighit](https://github.com/Bighit)



## iOS平臺RIME框架底层庫：

- [iRimeLib] (https://github.com/jimmy54/iRimeLib)


## 第三方庫/3rd Party Library
- [OpenCC](https://github.com/BYVoid/OpenCC) (Apache License 2.0)
- [neolee/SCU](https://github.com/BYVoid/OpenCC) (Apache License 2.0)
- [stackia/XIME](https://github.com/stackia/XIME) (GPL v3)
- [RIME](http://rime.im)(BSD License)
 - [Boost C++ Libraries](http://www.boost.org/) (Boost Software License)
   - [libiconv](http://www.gnu.org/software/libiconv/) (LGPL License)
 - [darts-clone](https://code.google.com/p/darts-clone/) (New BSD License)
 - [marisa-trie](https://code.google.com/p/marisa-trie/) (BSD License)
 - [UTF8-CPP](http://utfcpp.sourceforge.net/) (Boost Software License)
 - [yaml-cpp](https://code.google.com/p/yaml-cpp/) (MIT License)
 - [LevelDB](https://github.com/google/leveldb) (New BSD License)
   - [snappy](https://google.github.io/snappy/)(BSD License)


## 鳴謝/Credits
- \[Rime\]: [佛振](https://github.com/lotem)
- 圖文教程：[xiaoqun2016](https://github.com/xiaoqun2016)
- 在[Issues](https://github.com/jimmy54/iRime/issues)、[貼吧](http://tieba.baidu.com/f?kw=rime)、QQ羣中反饋意見的網友
- 依賴的第三方庫等開源項目

[Rime]: http://rime.im


## License
The GNU General Public License v3.0 (GPL v3)

>Copyright (C) 2014 Stackia
>
>This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
>
>This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
>
>You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.



---

## 克隆本仓库, 并下载所依赖的第三方库(`LibAndResource`)

`LibAndResource` 下载地址:
链接: http://pan.baidu.com/s/1mi0wt88 密码: ey9v
下载之后将解压出来的文件夹 `LibAndResource` 放置在 `iRime` 目录下, 具体位置可参考下图:
![位置参考](https://raw.githubusercontent.com/xqin/iRime/master/LibAndResource.png "位置参考")



## 如果你有MAC电脑的话, 可以跳到本步骤.

#### 在 `Windows` 上使用 `VMWare Player` 安装 `macOS Sierra(10.12)`
教程如下(网页中有相关工具下载地址):
https://techsviewer.com/install-macos-sierra-vmware-windows/

> `VMWare` 的虚拟机文件, 百度盘下载地址:
链接:http://pan.baidu.com/s/1eR9L1KY 密码:qcm9

> `VMware Player` 请从 [VMWare官网](https://www.vmware.com/products/player/playerpro-evaluation.html) 直接下载(免费).


### 下载 `XCode 8.3.3` 并安装至MAC系统中

[XCode 8.3.3下载地址](https://developer.apple.com/download/)


完成上面的操作之后, 用 `XCode` 打开  `iRime` 目录下的 `iRime.xcworkspace` 文件,
更新 项目中 所关联的 Apple Id 为您自己的账号及对应的group.
然后将手机连接至电脑上, 将目标选择为自己的手机,
然后按 `Command+R` 就可以编译代码并将编译后的程序安装到您的手机上了.

## PS: 该仓库中原有代码版权归原作者所有, 请在使用时遵守相关的 LICENSE.
