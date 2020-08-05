---
title: 读一读5|Sentence-BERT
date: 2020/8/5
categories: 
- 读一读
tags: [NLP, 机器学习, 深度学习]
---

最近用到了语义相似度这个feature, 又刚好看到了Sentence-BERT这篇论文, 在此做一个小小的总结.
<!-- more -->

Word2Vec是以前可以做语义相似度的方法, 本身Word2Vec的训练目标也是最大化词向量的相似度, 最后用余弦线相似度就可以知道两个单词是否相似. 但是, word2vec产生的向量是比较naive的, 比如苹果这个词语, 它既有可能是指水果, 也有可能指手机, 所以在18年Bert出来之后, 自然我们就希望用contextual word embedding的方法, 来完成计算相似度的任务.

有多篇论文发现直接用Bert形成的词向量其实效果对一些任务并不好, 并且Bert原生也没有计算一个单独的句向量, bert-as-a-service的库中产生向量的方法是给Bert喂一个句子, 然后通过平均输出的向量, 得到句向量. 或者用一个CLS在句子开头来获取向量. 而Sentence-BERT结合了Bert和siamese/triplet networks, 用以生产语义相似的词向量. 如下图.
![](/image/duyidu5_1.png)

左边是以分类作为目标函数的结构, 右边是regression的目标函数. Bert通过pooling产生了sentence embedding, 论文中尝试了CLS-token, mean pooling, max pooling来做pooling. 然后通过siamese network就可以产生词向量.

对于目标函数, 也有三种. **Classification Objective Function**作为目标函数的表达式是$o=softmax(W_{t}(u, v, |u − v|))$. $W_{t}$是$3n\times k$的可训练权重, 其中n是句向量的维度, k是classes的数量. **Regression Objective Function**就是计算两个句子的余弦相似度, 然后用squared-error loss作为目标函数. **Triplet Objective Function**利用三个句子: anchor sentence a, positive sentence p和negative sentence n, 牢共同构成目标函数, 目的是让a和p的距离小于a和n的距离, 表达式为$max(||s_{a}-s_{p}|| - ||s_{a}-s_{n}|| + \epsilon, 0)$. $\epsilon$是一个margin, 保证了正向靠近的距离比负向的多这么多. 作者用了Euclidean distance来衡量距离. (为什么不是余弦距离呢), $\epsilon$为1.

STS任务训练的结果为下.
![](/image/duyidu5_2.png)

所以可以看出, Bert直接生成的词向量作为语义相似度的测量工具效果并不好(不如Glove). 而sBert针对不同的目标函数fine-tuned之后效果变的更好了. 并且计算时间也有所下降.

## REFERENCES
[1] **Sentence-BERT: Sentence Embeddings using Siamese BERT-Networks**. Nils Reimers and Iryna Gurevych. [paper](https://arxiv.org/pdf/1908.10084.pdf)