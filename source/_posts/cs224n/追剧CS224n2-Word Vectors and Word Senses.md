---
title: 追剧CS224n|2-Word Vectors and Word Senses
thumbnail: /image/zhihu/cs224n2_thumbnail.jpg
date: 2020/3/27
categories: 
- CS224n
tags: [NLP, deep learning]
---

接着上一节课的内容, 课件直接用下图形象的解释了计算过程. 用5维向量表示单词, outside word和center word做点积再softmax得到概率分布, 而目的就是使context word的概率最高.
<!-- more -->
![](/image/zhihu/cs224n2_1.png)

那么怎么minimize cost function? 当然还是用**Gradient Descent**了. 但是直接求$J_{theta}$的梯度是不现实的, 因为它包含了所有窗口的计算, 这会使得计算量极大. 解决方法就是**Stochastic gradient descent (SGD)**, 每一个step只处理一个batch内的training data, 不断循环直到达到某一个阈值. 同时naive softmax也应该被优化, 主要的方法是negative sampling和hierarchical softmax.

Word2vec的思想总的来说就是找每一个词和上下文的词构成的概率分布, 自然我们就会想单词的co-occurrence counts是否也可以被model呢. 下图是window length为1的例子, 用三个document的corpus构成了一个co-occurrence matrix.
![](/image/zhihu/cs224n2_2.png)

问题是这样的矩阵维度太高了, 我们想要的是像word2vec那样最后50, 100等等那样的小词向量. 自然就会想到用SVD分解矩阵(和图片压缩一个道理). SVD相对于特征值分解厉害的地方在于它可以分解不是方阵的矩阵. 如下图, 等式左边就是原矩阵, 等式右边是分解过后的矩阵. 这里我们关注等式右边中间那个矩阵, 如果只保留非零的行和列, 那么他就是一个对角矩阵, 对角线保存的是singular value. 有相应的左边$A^{'}$矩阵的rank也会减1, 也就是说我们在**竟可能保证矩阵信息不丢失的情况下压缩了矩阵**. 
![](/image/zhihu/cs224n2_3.png)

课件对比了**count based和direct prediction**两种模型的优缺点.为了结合这两种方法, **Glove**就出现了.
![](/image/zhihu/cs224n2_4.png)

Glove encode了**Ratios of co-occurrence probabilities**, 这就是把概率和number of co-occurrence结合了起来. loss function的平方项内就是为了使点积的结果更加接近$logX_{ij}$这个co-occurrence probability, b是bias(有些词本身就会有高的词频), f是一个trick, 使得高频词的影响不要过大. *Glove需要看paper理解*. 
![](/image/zhihu/cs224n2_5.png)

得到了word vector有什么标准去衡量它的好坏呢? 这里直接给出课件的总结:
![](/image/zhihu/cs224n2_10.png)

## REFERENCES
[1] CS224n: Natural Language Processing with Deep Learning. http://web.stanford.edu/class/cs224n/index.html#coursework.

[2] Stanford CS224n追剧计划-Week2. https://mp.weixin.qq.com/s/GsnhifWkd_lh88d3---4RQ.

[3] **Distributed Representations of Words and Phrases and their Compositionality**. Tomas Mikolov, Ilya Sutskever, Kai Chen, Greg Corrado, Jeffrey Dean. 2013. [paper](http://papers.nips.cc/paper/5021-distributed-representations-of-words-and-phrases-and-their-compositionality.pdf)

[4] **GloVe: Global Vectors for Word Representation**. Jeffrey Pennington, Richard Socher, Christopher D. Manning. 2014. [paper](https://nlp.stanford.edu/pubs/glove.pdf)

[5] Linear Algebra. http://speech.ee.ntu.edu.tw/~tlkagk/courses_LA19.html.

[6] 奇异值分解(SVD). https://zhuanlan.zhihu.com/p/29846048.