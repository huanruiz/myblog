---
title: 追剧CS224n|12-Subword Models
thumbnail: /image/cs224n12_thumbnail.jpg
date: 2020/4/4
categories: 
- CS224n
tags: [NLP, deep learning]
---

之前介绍的模型都是基于词向量的, 自然我们就会想到能不能换一个角度来表示语言呢. 说英文的时候, 每个单词都是由音节构成的, 而人们听到了连续的音节就可以理解其中的含义, 而音节显然比词粒度更细. 我们想想再word-level存在的几个问题: 1.需要系统需要极大的词汇量; 2.如果遇到了不正式的拼写, 系统很难进行处理; 3.做翻译问题时, 音译姓名比较难做到. 为了解决这些问题, 那就只能考虑**Subword Models**了. 
<!-- more -->

其中**Character-Level Models**的好处是可以处理unknown word, 解决了OOV的问题, 而且拼写类似的单词具有相似的embedding. 这里要注意, 不同语言的writing system是不同的(**Phonemic**, **Ideographic**, etc.). 下图是Character-Level Models的例子, 可以看出filter在character embedding上滑动.
![](/image/cs224n12_1.png)

**Sub-word models**一般有两种结构, 一种是和word-level model一样, 只是用word pieces来代替单词; 另一种是**hybrid architectures**, 主要部分依然是基于word, 但是其他的一些部分用characters. 

**Byte Pair Encoding(BPE)**是一种压缩算法, 运用在NLP中就是把词汇中做常出现的ngram pairs组成新的ngram, 直到达到某个阈值. **Google NMT(GNMT)**用了这种方法的变种, v1是**wordpiece model**, v2是**sentencepiece model**(空格当成一个特殊的token). 其实BERT也用了wordpiece model, mask住了一部分, 剩下的不就是word pieces了吗.

下图是对character做卷积, 然后用fixed window做一个POS tagging.
![](/image/cs224n12_2.png)

当然也可以用RNN做类似的任务:
![](/image/cs224n12_3.png)

下面是一种**Hybrid NMT model**, 思想是大部分翻译都基于word level, 但当有需要时(遇到了OOV)就会使用character level. 它用了8-stacking LSTM layers.
![](/image/cs224n12_4.png)

**FastText embeddings**是一个word2vec like embedding. 用where举例, 它把单词表示成了: "where = <wh, whe, her, ere, re>, <where>", 这样的形式. 注意这里的"<>"符号是表达了开始和结束. 这样就可以有效地解决OOV的问题, 并且速度依然很快.

## REFERENCES
[1] CS224n: Natural Language Processing with Deep Learning. http://web.stanford.edu/class/cs224n/index.html#coursework.

[2] Stanford CS224n追剧计划-Week7. https://mp.weixin.qq.com/s/l_5W-2zIH3n8okiM0hXsew