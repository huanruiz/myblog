---
title: 追剧CS224n|20-Future of NLP + Deep Learning
thumbnail: /image/zhihu/cs224n20_thumbnail.jpg
date: 2020/4/13
categories: 
- CS224n
tags: [NLP, deep learning]
---

数据是有限的, 能supervised learning的时候我们当然希望尽量用监督的方法来训练模型. 所以考虑现实情况, 平时我们用到的数据集通常并不会很大, 就需要一些方法来尽量优化模型的表现. 这一节主要讲machine translation现实中的应用.
<!-- more -->

比较popular的就是**Pre-Training**了. 现在大的数据集上训练, 再fine-tune到小的数据集上.
![](/image/zhihu/cs224n20_1.png)

**Self-Training**就是用MT model对语言进行翻译, 在用得到的labeled data进行训练, 这显然会给数据集带来噪声. 
![](/image/zhihu/cs224n20_2.png)

而**Back-Translation**则是用两个MT model对语言进行正向反向翻译, 这然就防止模型遇到之前自己预测到的翻译, 避免了循环.
![](/image/zhihu/cs224n20_3.png)

那完全没有**bilingual data**怎么办呢? 一种解决方案是用**cross-lingual word embeddings**, 也就是两种语言共享通的歌vector space, 去使得单词接近他们的翻译. 不同语言的词向量有各种结构但是我们假设他们的结构是类似的. 如下图, 那么现在的任务就是去找这个W. 方法是用adversarial training, discriminator去预测是来自Y还是从X通过Wx得到的.
![](/image/zhihu/cs224n20_4.png)

上面是基于单词粒度的, 怎么翻译一个句子呢. 就是用ross-lingual word embeddings在同样的encoder-decoder训练正向反向的翻译任务. 但是这样的模型对比较类似的语言有效(English, French, German), 对English<->Turkish这样的翻译就不是那么有效了.
![](/image/zhihu/cs224n20_5.png)

**Cross-Lingual BERT**在这样的任务取得了较好的结果. 上面是谷歌的原BERT模型, 下图是facebook的结合MLM和翻译任务的模型. 可以看到输入变成了两种语言(en, fr). 
![](/image/zhihu/cs224n20_6.png)

后来的GPT-2增加了数据量, 所以表现比之前的模型效果更好了. 他可以做到zero-shot learning, 也就是在没有supervised training data的情况下来做Reading Comprehension, Summarization, Translation, Question Answering等任务.
![](/image/zhihu/cs224n20_7.png)

接下来讲NLP未来的发展(时间是2019年冬季, 不知道再过5年, 10年回头看是怎样的感觉). 其实看课件就可以了, 主要就是讲了复杂的阅读理解, 对话中的问答, 多任务学习, 怎么找到一个不需要强大环境的方法(数据有限, 针对移动设备).

## REFERENCES
[1] CS224n: Natural Language Processing with Deep Learning. http://web.stanford.edu/class/cs224n/index.html#coursework.

[2] Stanford CS224n追剧计划-Week11. https://mp.weixin.qq.com/s/1tKX6j5JTIYwTujIW1RrtA.