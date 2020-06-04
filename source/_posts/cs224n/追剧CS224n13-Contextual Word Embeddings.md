---
title: 追剧CS224n|13-Contextual Word Embeddings
thumbnail: /image/cs224n13_thumbnail.jpg
date: 2020/4/5
categories: 
- CS224n
tags: [NLP, deep learning]
---

到现在我们主要学了三种word vectors(word2vec, glove, fasttext), 他们主要的问题是**每个单词只有基于context的一种表示**, 而事实上一个word具有很多不同的属性, 比如semantics, syntactic behavior, and register/connotations等等.
<!-- more -->

下图是**Tag LM**, 可以就看出最后做NER的时, 同时用到了word embedding和LM embedding两种词嵌入, 也就是说用两种方式表达了一个单词.
![](/image/cs224n13_1.png)

**ELMO(Embeddings from Language Models)**的主要思想就是如下, h是hidden state, 它针对某一个neural LM. 整体来说, lower layer学到的是**lower-level syntax**, 比如part-of-speech tagging, syntactic dependencies, NER; 而higher layer学到的是**higher-level semantics**, 比如sentiment, semantic role labeling, question answering, SNLI. 具体细节看paper[3].
![](/image/cs224n13_2.png)

**ULMfit**主要展现了**pre-training**加**fine-tune**的力量. 把source model(很大的训练集学到的模型)迁移到target model. 从下图可以看出pre-training过后, error rate显著下降, 如果再加上一些fine-tune, error rate可以进一步下降. 具体细节看paper[4].
![](/image/cs224n13_3.png)

之前我们介绍过attention的强大, 那么我们能否只用attention但是不基于RNN呢, **self-attention**来了[5]. multihead使attention注意的具体特征有所不用. 
![](/image/cs224n13_4.png)

**BERT(Bidirectional Encoder Representations from Transformers):**[6]和GPT相似, 不过是双向的. 思想主要是两个, 第一个是15%的词语被mask住(希望把这个词填回来), 然后mask这个词汇生成的embedding放到一个Linear Multi-class Classifier里面去预测这个词. 也就是说如果两个词有类似的语义, 他们就会有类似的embedding. 
![](/image/cs224n13_5.png)

第二种是Next Sentence Prediction. 就是判断两个句子是否是接在一起的. SEP是句子分隔符, CLS是一个特殊的token, 这个位置输出的embedding会被当做输入放在Linear Binary Classifier中输出这个分类. 这个CLS的位置是没有关系的, 因为BERT的内部是self-attention.
![](/image/cs224n13_6.png)

## REFERENCES
[1] CS224n: Natural Language Processing with Deep Learning. http://web.stanford.edu/class/cs224n/index.html#coursework.

[2] Stanford CS224n追剧计划-Week7. https://mp.weixin.qq.com/s/l_5W-2zIH3n8okiM0hXsew

[3] **ELMO**: **Deep contextualized word representations**. Matthew E. Peters, Mark Neumann, Mohit Iyyer, Matt Gardner, Christopher Clark, Kenton Lee, Luke Zettlemoyer. NAACL 2018. https://arxiv.org/abs/1802.05365. [paper](https://arxiv.org/abs/1802.05365)

[4] **ULMfit**: **Universal Language Model Fine-tuning for Text Classification**. Howard and Ruder(2018). [paper](https://arxiv.org/pdf/1801.06146.pdf)

[5] **Attention Is All You Need**. Aswani, Shazeer, Parmar, Uszkoreit,
Jones, Gomez, Kaiser, Polosukhin(2017). [paper](https://arxiv.org/pdf/1706.03762.pdf)

[6] **BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding**. Jacob Devlin, Ming-Wei Chang, Kenton Lee, Kristina Toutanova(2018).[paper](https://arxiv.org/abs/1810.04805)

[7] Machine Learning(2019, Spring). http://speech.ee.ntu.edu.tw/~tlkagk/courses_ML19.html.

[8] CS224N笔记(十三): ELMO, GPT与BERT. https://zhuanlan.zhihu.com/p/72309137.