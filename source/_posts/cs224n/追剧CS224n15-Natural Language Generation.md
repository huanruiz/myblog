---
title: 追剧CS224n|15-Natural Language Generation
thumbnail: /image/zhihu/cs224n15_thumbnail.jpg
date: 2020/4/7
catagories: 
- CS224n
tags: [NLP, deep learning]
---

**Natural Language Generation(NLG)**就是指需要生成新的文字信息的任务, 前面学到的Machine Translation其实也是NLG一种. 生成text的过程也就是decoding的过程, 之前我们学习了greedy decoding和beam search decoding. 现在我们介绍几种新的**Sampling-based decoding**方式.
<!-- more -->

**Pure sampling**和greedy decoding类似, greedy decoding每一步选的是argmax的单词, 而pure sampling则是从概率分布中随机的抽取一个单词成为下一个单词. 更进一步就是**Top-n sampling**, 每一步之根据概率分布在最有可能的n个单词里面sample. 也就是说在选择时截取了概率分布的一部分. 

那么考虑attention直接用来representation, 通过每个embedding的比较来得到特征. 对任意两个位置, 他们的path length是一个定值. 

**Softmax temperature**(不是decoding algorithm)就是指在普通的softmax上架了一个temperature $\tau$, 如果$\tau$升高, 那么概率分布会更加平缓, 反之就会更加尖锐. 在decoding的时候就可以引入它. 当然对于greedy decoding他是没有用的, 因为比较argmax结果依然不会变.
![](/image/zhihu/cs224n15_1.png)

下面是各种decoding算法的总结. 
![](/image/zhihu/cs224n15_2.png)

接下来介绍NLG task **Summarization**, 也就是说用更短的文字总结长的文字. 它包括了**Extractive summarization**和**Abstractive summarization**, 前者是从原文字中摘选总结, 后者是生成新的自然语言来总结, 所以后者更加灵活也更难.

**Pre-neural summarization**的方法大多是extractive summarization(不用神经网络可想而知得有多难...). 一般会有这样的pipeline: 1.Content selection(选择句子); 2.Information ordering(对句子排序); 3.Sentence realization(节选句子一部分). 其中content selection时, 有两种算法: Sentence scoring functions和Graph-based algorithms.

怎么**evaluate summarization**呢, 一般是用ROUGE, 它和BLEU一样也是基于n-gram overlap, 基于计算recall(BLEU基于precision), 因为模型希望的是竟可能的总结文字信息的所有部分. 但是BLEU最后返回的是几种grams的组合分数, 而ROUGE是对每一种gram的分数都做返回.

现在当然人们都喜欢**Neural summarization**了. Single-document abstractive summarization其实就是一个翻译任务, 也可以用seq2seq + attention NMT(copy mechanisms), 但是它对总结细节不太擅长. 而且copy mechanisms通常生成的总结太长了. 对比较长的document, 它的表现也不好, 为了解决这些问题就需要**Bottom-up summarization**.

Bottom-up summarization分离了content selection和surface realization这两个部分. 在content selection是用neural sequence-tagging model来标注是否包含某个词, 在Bottom-up attention部分, 系统无法读取上标注为无法读取的词.
![](/image/zhihu/cs224n15_3.png)

**Dialogue**也是一种NLG任务, 分类如下图. 人们首先尝试了Seq2Seq, 但是发现这样对话会有Genericness, Irrelevant responses, Repetition等等问题. 所以需要**Maximum Mutual Information(MMI)**, 它会惩罚generic response.
![](/image/zhihu/cs224n15_4.png)

下图介绍了其他方式来解决Genericness/boring response problem:
![](/image/zhihu/cs224n15_5.png)

对Repetition problem解决方式如下:
![](/image/zhihu/cs224n15_6.png)

**Storytelling**就是根据图片, 一段文字生成一个故事, 或者不断生成故事的下一句. 最后课上进一步介绍了evaluation. 其实发现各种automatic evaluation都不能完全展现模型的好坏, 而Human evaluation虽然可以作为标注, 但是人工评价效率比较低而且比较主观.

下面是老师的一些经验总结:
![](/image/zhihu/cs224n15_7.png)
![](/image/zhihu/cs224n15_8.png)

## REFERENCES
[1] CS224n: Natural Language Processing with Deep Learning. http://web.stanford.edu/class/cs224n/index.html#coursework.

[2] Stanford CS224n追剧计划-Week8. https://mp.weixin.qq.com/s/FBFL16QMp3Ob9VIp7pbBiA