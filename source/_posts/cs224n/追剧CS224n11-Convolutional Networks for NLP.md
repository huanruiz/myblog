---
title: 追剧CS224n|11-Convolutional Networks for NLP
thumbnail: /image/cs224n11_thumbnail.jpg
date: 2020/4/3
categories: 
- CS224n
tags: [NLP, deep learning]
---

RNN可以用于NLP, 那CNN当然也可以. 我觉得RNN, CNN的目的其实就是提取特征, 只要文字能被encoding, 那么剩下的任务就是尽可能使neural network去理解这些向量, 学到关键的特征. CNN的具体例子也可以看李宏毅老师的课程, 简单说就是用kernel(=filter)在矩阵上选特征. 对于文字来说通常就是1D convolution. 下图是大小为3的filter做了一个CNN. 
<!-- more -->
![](/image/cs224n11_1.png)

通常做CNN时需要加上**(zero) padding**, 如下图中的$\phi$. 对右边选出的特征矩阵, 可以对他做一个**max pooling**或者**average pooling**. 一般来说都会用max pooling, 因为语言信息一般比较sparse, 所以把握某个细节反而比整体好一点.
![](/image/cs224n11_2.png)

当然也有**local max pooling**, 下图就是步长为2的例子, 可以看出右下角最后选出的矩阵变成了4行.
![](/image/cs224n11_3.png)

**k-max pooling**就是选出最大的k个值, **dilation**就是pooling的时候跳过一些行. 需要了解这一些概念.

**Single Layer CNN for Sentence Classification**[3]就是用CNN对sentence进行分类, 比如情感分类等. 注意他在输入的时候用了pre-trained word vectors(word2vec or Glove), 用过两种一样的word vectors, 就实现了**Multi-channe**, 当反向传播时只对其中一个进行更新, 而另一个保持静止. 最后得到了**c**之后通过softmax得到概率分布来进行分类.
![](/image/cs224n11_4.png)

那么怎么**Regularization**模型呢, 通常办法有**Dropout**, 也就是在训练过程中忽略一些节点的值, 可以有效地防止过拟合. 对CNN的优化通常还有**batch normalization**, 对每一个minibatch做一个**z-transform**.

下面直接给出课件上对之前讲过的几**模型结构的对比**.
![](/image/cs224n11_5.png)

**VD-CNN**就是very deep CNN, 很多层叠加到一起. 课程最后还讲到了**Quasi-Recurrent Neural Network**, 目的是结合RNN和CNN的优点, 解决RNN计算缓慢的问题. 这里只要知道这些名词就好了. 

## REFERENCES
[1] CS224n: Natural Language Processing with Deep Learning. http://web.stanford.edu/class/cs224n/index.html#coursework.

[2] Stanford CS224n追剧计划-Week6. https://mp.weixin.qq.com/s/wsPLQV7FlWzAZ9YM_jKOZg

[3] Convolutional Neural Networks for Sentence Classification. Yoon Kim. EMNLP 2014. [paper](https://arxiv.org/pdf/1408.5882.pdf).

[4] Batch Normalization深度学习第八章(二）https://zhuanlan.zhihu.com/p/42982530.