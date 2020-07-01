---
title: week5-6|Git
date: 2020/6/30
categories: 
- 学习笔记
- software construction
tags: [git]
---

接下来讲git, 我们的终极目标是用shell写出一个模拟的git. 课程结束之后我也会把我做的仿真git代码放出来.
<!-- more -->

我觉得这个[教程](https://www.liaoxuefeng.com/wiki/896043488029600)更容易理解.

很多version control system都用了repository. repo是

- store all versions of all objects (files) managed by VCS
- may be single file, directory tree, database,...
- possibly accessed by filesystem, http, ssh or custom protocol
- possibly structured as a collection of projects

常用命令有

- **blobs** file contents identified by SHA-1 hash
- **tree objects** links blobs to info about directories, link, permissions (limited)
- **commit objects** links trees objects with info about parents, time, log message
- Create repository **git init**
- Copy exiting repository **git clone**
- **git log**打印之前的操作历史
- **git checkout + id号**切换分支或恢复到某个版本
- **git status .**查看当前状态.