---
title: Subjective Databases
thumbnail: /image/zhihu/duyidu1_thumbnail.jpg
date: 2020/3/24
categories: 
- 读一读
tags: [NLP, 机器学习, database]
---

## 为啥做
用户在使用搜索引擎的时候往往会使用主观的关键词搜索. 什么是主观和客观呢? 举个栗子, 情侣点外卖的时候可能会希望点适合约会的甜点, 这个"适合约会"就是主观的关键词, 那么搜索引擎返回的结果就应该是造型精致的小甜点而不是手掌那么大的豆沙包. 而客观就是指点外卖时要求价格不超过5块钱, 这个5块就是客观的事实. 人们倾向于主观的思考并且把任务交给系统来处理, 而传统的数据库存储的都是各种类型的客观数据, 所以这篇paper就设计了**直接存储主观数据的数据库**来解决这个痛点. 
<!-- more -->

## 咋做的
整个系统分为主要两个部分: processing subjective queries和designing subjective databases. 介绍这两方面之前, 要先知道整个系统使用的数据都是从用户的评价中提取的, 所以paper针对这些评论数据定义了两个重要的概念: "Linguistic domains"和"Markers and Marker summaries". 

同样用食物举例, 用面向对象的方式来思考, 食物就是一个大的类, 它具有各种属性, 比如食物的味道, 而Subjective Databases会在评论中提取很多短语来描述食物的味道, 比如{"太好吃了", "有点难吃", "味道还行", "挺香的", "一般般吧"}, 这个集合就是一个Linguistic domain, 食物的不同属性就构成了整个Linguistic domains. 

而Marker summaries就是对Linguistic domains的总结(方便存储在数据库中), 他们本质表达的是同样的意思, 每一个Marker相当于就是对Linguistic domains中的一些短语的总结. Marker summaries有linearly-ordered和categorical两种类型. 对食物的味道来说就是linearly-ordered, 比如可以分为[very_disgusting, disgusting, average, delicious, very_delicious], 他们由情感分析得到的分数依次递增; 而对于食物的风味就应该是categorical的, 比如[辣的, 甜的, 咸的].

数据库的结构如下(hotel example).
![](/image/duyidu1_1.png)

### Processing subjective queries
首先要明确虽然paper设计了全新的数据库, 但是它本质上还是基于PostgreSQL, 所以第一步就得把主观的query通过fuzzy logic翻译成传统的SQL query. 这里就出现了一个问题: 用户的query无法匹配数据库中的marker summary咋办? papar采用了下图的流程去寻找. 最后系统query结合数据库中的数据, 就可以共同算出每个结果的degree of truth, 许多传统机器学习的模型都可以做到这一点, 比如logistic regression最后的结果就是一个0到1之间分数. 
![](/image/duyidu1_2.png)

### Designing subjective databases
重头戏来了, 到底如何设计整个Subjective Databases呢? 首先就要解决怎么设计marker summary这个问题, 有了marker summary才能整合数据到数据库中. 对于每个评论都对其进行tagging(类似NER), 最后就可以得到很多个(aspect, opinion)这样的pair, 把这些pair分配到数据库开发者定义好的属性上, 就得到了Linguistic domains. 对于linearly-ordered的domain, 用sentiment analysis就可以把它们分配给每一级的marker, 而对于categorical的domain, 就可以使用基于cluster的算法对他们进行总结. paper现在只是把每一种marker对应短语或者说pair的出现次数进行累加并且存储到数据库中.

## REFERENCES
[1] **Subjective Databases**. Yuliang Li, Aaron Xixuan Feng, Jinfeng Li, Saran Mumick, Alon Halevy, Vivian Li, Wang-Chiew Tan. VLDB(2019). [paper](http://www.vldb.org/pvldb/vol12/p1330-li.pdf)

[2] **Subjective Databases**. Yuliang Li, Aaron Xixuan Feng, Jinfeng Li, Saran Mumick, Alon Halevy, Vivian Li, Wang-Chiew Tan. arXiv:1902.09661(2019). [paper](https://arxiv.org/abs/1902.09661) (有附录)