---
title: 追剧CS224n|1-Introduction and Word Vectors
thumbnail: /image/zhihu/cs224n1_thumbnail.png
date: 2020/3/26
categories: 
- CS224n
tags: [NLP, deep learning]
---

怎么使语言被计算机理解呢, 这是NLP与CV不同的地方. 图像数据在计算机中就是数字信号, 每一个像素存储的数字本身就是有意义的. 而自然语言对于计算机就是抽象的符号而已, 所以人们需要找到方法来使自然语言被表达成计算机能理解的形式.
<!-- more -->

最早的表达词的方式是**WordNet**, 它记录的是synonym sets和hypernyms, 但是同一个词在不同语境下可能有不同的意思, 而WordNet并没有考虑这个维度, 并且WordNet很难对已有的词表进行更新, 如果一个词有了新的意思或者有了新的词汇需要加入整个网络就很麻烦了.

计算机想要的东西是可以计算的向量, 那么用**one-hot vector**来表示单词就是非常intuitive的想法了. 但是这样的vector就会非常大(向量长度等于词表的大小), 而且极其sparse. 对于one-hot vector中的向量都是正交的, 这意味着一对向量所表达两个单词是没有关系的, 这当然是不符合事实, 一个词的出现当然会与**上下文(context)**有千丝万缕的联系. 
![](/image/zhihu/cs224n1_1.png)

那么我们的目标就是让词向量可以记录每两个词之间的关系, 并且把sparse的词向量转化为dense的词向量. **Word2vec**就诞生了(这里的Word2vec指CBOW和skip-gram, Word2vec之前也有转化词成词向量的方法, 不能混淆了). Word2vec要找的关系就是center word和context word的关系, 如下图, 发现这和IR学过的的language model很类似, 只不过Word2vec的窗口框住了上下文而不是单纯的上文.
![](/image/zhihu/cs224n1_2.png)

Word2vec的objective function如下. 从likelihood可以看出这是用center word去预测context words, 也就是说这其实是skip-gram; 如果反过来用context words去预测center word, 那就是CBOW了.  这里的objective function$J_{\theta}$就是(average) negative log likelihood. 负号把最大化问题转化成最小化问题, T起了scaling的作用, log把连乘转化连加并且在后面可以直接与自然对数化简.
![](/image/zhihu/cs224n1_3.png)

接下来就是想办法去表示$logP(w_{t+j}|w_{t}; \theta)$. 每个单词存在center word和context word两种状态, 进而得到下图的定义. 分子的点乘其实就是测量o和c的相似度, 越相似的向量点乘过后得到的值自然就越大; 而分母就是做了normalize. 可以看出分子分母整体做了个softmax.
![](/image/zhihu/cs224n1_4.png)

有了loss function之后就是微分微分, 链式链式, gradient descent去minimize这个loss function了. 最后结果是$u_{o}-\sum_{x=1}^{V}P(x|c)u_{x}$. x是化简时为了区分w新定义的参数, 这个slope的表达就很有意思了, $u_{o}$就是真实的context word, 减号后面是预测出的context word, 相减就是对他们进行比较, 这也就是模型本身的目的.

## REFERENCES
[1] CS224n: Natural Language Processing with Deep Learning. http://web.stanford.edu/class/cs224n/index.html#coursework.