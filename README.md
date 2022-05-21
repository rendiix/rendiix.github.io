![GitHub](https://img.shields.io/github/license/rendiix/rendiix.github.io.svg)
[![HitCount](http://hits.dwyl.io/rendiix/rendiix.github.io.svg)](http://github.com/rendiix/rendiix.github.io)
[![GitHub forks](https://img.shields.io/github/forks/rendiix/rendiix.github.io.svg?style=social&label=Fork&maxAge=2592000)](https://GitHub.com/rendiix/rendiix.github.io/network/)
[![GitHub stars](https://img.shields.io/github/stars/rendiix/rendiix.github.io.svg?style=social&label=Star&maxAge=2592000)](https://GitHub.com/rendiix/rendiix.github.io/stargazers/)
![GitHub watchers](https://img.shields.io/github/watchers/rendiix/rendiix.github.io.svg?style=social)
[![GitHub followers](https://img.shields.io/github/followers/rendiix.svg?style=social&label=Follow&maxAge=2592000)](https://github.com/rendiix?tab=followers)
[![GitHub contributors](https://img.shields.io/github/contributors/rendiix/rendiix.github.io.svg)](https://GitHub.com/rendiix/rendiix.github.io/graphs/contributors/)

# THIRD PARTY TERMUX REPOSITORIES
## Android development tools

#### Join Discord or follow me on Twitter:

[![Discord](https://img.shields.io/discord/404576842419273729.svg?label=join%20discord&logo=discord)](https://discord.gg/5PmKhrc)
[![Twitter Follow](https://img.shields.io/twitter/follow/rendiix.svg?color=green&label=follow&logo=twitter&style=social)](https://twitter.com/rendiix)

#### Subscribe to this repository
``` console
user@termux:~$ apt-get update && apt-get upgrade -y
user@termux:~$ apt-get install wget
user@termux:~$ wget https://rendiix.github.io/install-repo.sh
user@termux:~$ bash install-repo.sh
``` 
#### Example installing package
``` console
user@termux:~$ apt-get install shc
Reading package lists...
Building dependency tree...
Reading state information...
The following NEW packages will be installed:
  shc
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 185 kB of archives.
After this operation, 580 kB of additional disk space will be used.
Get:1 https://rendiix.github.io stable/main aarch64 shc aarch64 4.0.3 [185 kB]
Fetched 185 kB in 0s (193 kB/s)
Selecting previously unselected package shc.
(Reading database ... 47407 files and directories currently installed.)
Preparing to unpack .../archives/shc_4.0.3_aarch64.deb ...
Unpacking shc (4.0.3) ...
Setting up shc (4.0.3) ...
Processing triggers for man (1.14.5-1) ...
user@termux:~$
```

#### Table of contents


| Package | Version | Descriptions |
| --- | :---: | --- |
| [android-partition-tools](https://android.googlesource.com/platform/system/extras/+/master/partition_tools/README.md) | 31.0.0 | Android dynamic partition tools. visit: https://android.googlesource.com/platform/system/extras/+/master/partition_tools/README.md for more informations |
| [android-sdk-build-tools](https://github.com/rendiix/termux-aapt) | 31.0.3 | aapt aapt2 aidl tools |
| [apktool](https://ibotpeaches.github.io/Apktool/) | 2.6.2-6-SNAPSHOT | A tool for reverse engineering 3rd party, closed, binary Android apps. It can decode resources to nearly original form and rebuild them after making some modifications. It also makes working with an app easier because of the project like file structure and automation of some repetitive tasks like building apk, etc. |
| [dex2jar](https://github.com/ThexXTURBOXx/dex2jar) | 2.1-SNAPSHOT | Tools to work with android .dex and java .class files |
| [ext4fs-tools](https://github.com/rendiix/make_ext4fs) | 8.1.0 | Android img tools: make_ext4fs img2simg simg2img sefcontext_decompile. |
| [img2sdat](https://github.com/xpirt/img2sdat) | 1.7 | Convert sparse EXT4 image to sparse Android data image |
| [lolcat](https://github.com/jaseg/lolcat) | 1.2 | A Command Line Tool to Output Rainbow Of Colors in Linux Terminal. This version is High-performance implementation of https://github.com/busyloop/lolcat |
| [mkbootimg](https://github.com/osm0sis/mkbootimg) | 2019.04.13 | mkbootimg + unpackbootimg, forked and updated |
| [platform-tools](https://github.com/rendiix/termux-adb-fastboot) | 31.0.3 | adb fastboot tools |
| [sdat2img](https://github.com/xpirt/sdat2img) | 1.2-1 | Convert sparse Android data image to filesystem ext4 image |
| [shc](https://github.com/neurobin/shc) | 4.0.3 | A generic shell script compiler. Shc takes a script, which is specified on the command line and produces C source code. The generated source code is then compiled and linked to produce a stripped binary executable. |
| [vdexExtractor](https://github.com/anestisb/vdexExtractor) | 0.6.0 | Tool to decompile and extract Android Dex bytecode from Vdex files |
| [ytb-player](https://github.com/rendiix/rendiix.github.io) | 4.4 | Simple CLI YouTube downloader |
| [zipalign](https://github.com/rendiix/termux-zipalign) | 31.0.3 | zip archive alignment tool |
