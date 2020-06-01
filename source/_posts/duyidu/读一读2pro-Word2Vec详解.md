---
title: Word2Vec详解
thumbnail: /image/duyidu2pro_thumbnail.jpg
date: 2020/4/23
categories: 
- 读一读
tags: [NLP, 机器学习, 深度学习]
---

接着前一篇文章(读一读2), word2vec原论文分析了各种词嵌入模型的复杂度并且展示了word2vec的良好表现, 但是原论文没有深入的讲解word2vec的细节. 所以为了真正的理解word2vec, 我们需要更多的资料. 我找到了paper[1], [2]对word2vec的参数和推导进行了比较详细解释. 主要内容包括了**continuous bag-of-word(CBOW)**和**skip-gram(SG)**两种结构, 以及**hierarchical softmax**和**negative sampling**两种优化算法的解释. 下面我也将从这些方面来详细总结word2vec. 这篇文章的思路主要follow [1]中的内容. 
<!-- more -->

# CBOW
CBOW的结构如下, 让我们来一点一点分析.
![](/image/duyidu2pro_1.png)

先从左到右观察这个模型的结构, 左边的$x_{1k}, x_{2k}, ..., x_{Ck}$就是one-hot形式的词向量, 他们共同构成了input layer. 而中间的hidden layer把输入的onehot词向量encode成我们想要的词向量, 他的维度等于最后训练得到的词向量的维度. output layer代表了预测的中心单词. **所以说CBOW其实就是用上下文来预测中间的单词**, 而词向量是通过hidden layer产生的副产物. 那么顾名思义, CBOW中bag-of-word就是指的输入层连续的单词, 而continuous表示了这个选词的窗口在持续地滑动. CBOW大致的思想就是这样.

好, 为了详细的解释每一个参数, 我们把结构简化一下. 现在假设input只有一个context word, 也就是用一个context word去预测一个target word. 那么结构就成了这样.
![](/image/duyidu2pro_2.png)

input layer变成了单独的一个one-hot的输入(实际不一定是one-hot, 但是为了方便理解用one-hot解释会好一点), 而从input到hidden, 从hidden到output的weight用$W$和$W^{'}$来表示, 注意这里的$W$和$W^{'}$是完全不同的两个矩阵, 它们互相不构成转置关系. 下面开始解释神经网络向前传播的过程.

## 从左到右
首先我们看网络是怎么**正向传播**的.

**从input到hidden**, 可以看出$\boldsymbol{W}$中的每一行都是一个N-dimension的向量, 这个向量就表示了对应的单词, $\boldsymbol{W}$的V行就表达了整个语料的所有单词. 现在定义$\boldsymbol{W}$的第i行为$\boldsymbol{v}^{T}_{w}$(向量默认为列向量, 所以需要转置), 而$\boldsymbol{x}$是输入的那个词向量, 那么得到下面的式子. 

$\boldsymbol{h} = \boldsymbol{W}^{T}\boldsymbol{x} = \boldsymbol{v}^{T}_{w_{I}}$

因为$\boldsymbol{x}$是one-hot vector, 所以$\boldsymbol{h}$最后其实就等于$\boldsymbol{W}$的第k行, 这个k就是输入的$\boldsymbol{x}$为1的那一行, $w_{I}$表示input word. 注意在这里, 我们可以看出hidden layer的激活函数是线性的, 区别于NNLM中hidden layer的tanh激活. 

**从hidden到output**, 我们的目的是对每一个单词进行打分, 通过这个打分(预测值)和真实的出现的单词(实际值)做比较, 最后得到loss function来训练神经网络. 写成公式如下.

$u_{j} = \boldsymbol{v}_{w_{j}}^{'T}\boldsymbol{h}$

其中$\boldsymbol{v}_{w_{j}}$代表了权重矩阵$\boldsymbol{W}$的第j列, 这一列和$\boldsymbol{h}$相乘得到的就是第j个单词的分数. 最后为了得到单词的概率分布, 对$u_{j}$做softmax. 得到下式.

$p(w_{j}|w_{I}) = y_{j} = \frac{exp(u_{j})}{\sum^{V}_{j^{'}=1}exp(u_{j}^{'})}$

看$p(w_{j}|w_{I})$这个式子, 它长得多么像语言模型, 我们终于找到了输入单词和输出单词的概率关系. 而$y_{j}$就是output layer的第j个unit.

最后把上面的式子结合在一起, 我们得到下式. 这里的$\boldsymbol{v}_{w}$就是input vector, 而$\boldsymbol{v}_{w}^{'}$就是output vector.

$p(w_{j}|w_{I}) = \frac{exp(\boldsymbol{v}_{w_{j}}^{'T}\boldsymbol{v}_{w_{I}})}{\sum^{V}_{j^{'}=1}exp(\boldsymbol{v}_{w_{j}}^{'T}\boldsymbol{v}_{w_{I}})}$

**我觉得这个地方有趣的地方是括号中的向量相乘, 因为相似的向量点乘得到的值会更大**, 所以对应的$p(w_{j}|w_{I})$也会更大, 也就是说这个概率实际上也反映了输入向量和输出向量的相似度.

## 从右到左
正向传播解释清楚了, 那么神经网络是怎么反向传播的呢. 这里我们要脱离出训练词向量这个思维, 因为神经网络真正训练的东西应该是weight matrix, 也就是图中的$\boldsymbol{W}$和$\boldsymbol{W}^{'}$, 那么反向传播微分的目标其实也就是从loss function开始通过chain rule来找到weight matrix的更新公式. 

### $\boldsymbol{W}^{'}$更新公式
那么首先我们推导$\boldsymbol{W}^{'}$的更新公式. 从cost function出发, 目标是最大化$p(w_{O}|w_{I})$, 那么我们得到:

$\max p(w_{O}|w_{I})= \max y_{j^{*}}\\ = \max logy_{j^{*}}\\ = u_{j^{*}} - log\sum_{j^{'}=1}^{V}exp(u_{j^{'}}) := -E$

其中的E就是loss function, $j^{*}$是真正输出单词的index. 为了直观的解释, 我们在反向传播的时候也仅考虑对output layer中的第j个unit做微分. 就得到: 

$\frac{\partial E}{\partial u_{j}} = y_{j} - t_{j} := e_{j}$

其中$t_{j}$当且仅当第j个unit是真实的输出单词时才为1. 那么对$\boldsymbol{W}^{'}$的微分就是:

$\frac{\partial E}{\partial w_{ij}^{'}} = \frac{\partial E}{\partial u_{j}} \cdot \frac{\partial u_{j}}{\partial w_{ij}^{'}} = e_{j}\cdot h_{i}$

那么从hidden layer到output layer的权重更新公式就是:

$w_{ij}^{'(new)} = w_{ij}^{'(old)}- \eta\cdot e_{j}\cdot h_{i}$

如果从输出向量的角度来考虑, 那么更新公式如下, 这里的$v_{w_{j}}^{'}$指的是单词$w_{j}$所对应的output vector.

$v_{w_{j}}^{'(new)} = v_{w_{j}}^{'(old)}- \eta\cdot e_{j}\cdot \boldsymbol{h} \quad for\  j = 1, 2, \dots , V$

### $\boldsymbol{W}$更新公式
为了求$\boldsymbol{W}$的更新公式, 要做的依然是链式法则, 首先找loss function对hidden layer的微分:

$\frac{\partial E}{\partial h_{i}} = \sum^{V}_{j=1}\frac{\partial E}{\partial h_{j}} \cdot \frac{\partial h_{j}}{\partial h_{i}} = \sum^{V}_{j=1}e_{j}\cdot w_{ij} := EH_{i}$

这里的$h_{i}$是hidden layer的一个unit, 而$EH$是N维的向量, 上面的每一个unit就是对应的weight乘上output对应的error之和. 现在再考虑input layer到hidden layer的计算, 那么:

$h_{i} = \sum^{V}_{k=1}x_{k}\cdot w_{ki}$

注意这里的$w$没有上标了. 现在联立上面的式子, 并对weight求偏微分, 得到:

$\frac{\partial E}{\partial w_{ki}} = \frac{\partial E}{\partial h_{i}} \cdot \frac{\partial h_{i}}{\partial w_{ki}} = EH_{i}\cdot x_{k}$

或者写成张量积的形式, 

$\frac{\partial E}{\partial \boldsymbol{W}} = \boldsymbol{x}\bigotimes EH^{T} = \boldsymbol{x}EH^{T}$

在前面提到过, 输入的x是one-hot vector, 所以在相乘过后$\frac{\partial E}{\partial \boldsymbol{W}}$中其实只有一行是非0的. 那么仅考虑$\boldsymbol{W}$中更新的那一行, 便得到下面的权重更新公式, 它就是$\boldsymbol{W}$更新公式了~

$v_{w_{I}}^{(new)} = v_{w_{I}}^{(old)} - \eta EH^{T}$

$v_{w_{I}}$是$\boldsymbol{W}$中的一行. 这就给了我们比较直观的理解, 我们来看$EH$, 回顾前面的推导, $EH = \sum^{V}_{j=1}e_{j}\cdot w_{ij} = \sum^{V}_{j=1}(y_{j} - t_{j})\cdot w_{ij}$. 那么$y_{j}>t_{j}$时, 意味着预测的单词出现的概率大于了实际这个单词出现的概率, 权重更新方程就会使输入的context word $w_{I}$远离output vector $w_{j}$, 并且误差$e_{j}$越大, 这个远离的效果也会更强, 反之也是一个道理. 注意这里的远离是指两个向量的点积变小, 而不是Euclidean distance变小. 

## 多个context word
之前为了阐述CBOW原理, 把输入的context word简化成了单独的一个单词, 而实际上输入一般是多个context word, 如第一张图片那样的结构. 计算的时候把输入的单词取一个平均,

$h = \frac{1}{C}\boldsymbol{W}^{T}(x_1+x_{2}+\dots + x_{C})\\ = \frac{1}{C}(v_{w_{1}}+v_{w_{2}}+\dots +v_{w_{C}})$

C是context word的数量, 对应的$v_{w}$是input vector, 代表$\boldsymbol{W}$中的一行. 所以loss function是:

$E = -\log p(w_{O}|w_{I,1},\dots ,w_{I, C}) \\ = -u_{j^{*}}+\log \sum^{V}_{j^{'}=1}exp(u_{j^{'}}) \\ =-v_{w_{O}}^{'T}\boldsymbol{h}+\log \sum_{j^{'}}^{V}exp(v^{'T}_{w_{j}}\boldsymbol{h})$

形式上和单context word是一模一样的, 只是因为context word的变化导致了$\boldsymbol{h}$的变化. 而$\boldsymbol{W}^{'}$的更新公式没有变化, $\boldsymbol{W}$ 的更新公式变成了下式, c代表第c个context word.

$v_{w_{I, c}}^{(new)} = v_{w_{I, c}}^{(old)} - \frac{1}{C}\eta EH^{T}$

# Skip-Gram
对比CBOW, Skip-Gram的区别是用中间的单词去预测周围的context word. 两种结构推导的过程是类似的, 模们这里也使用同样的符号来表示各个参数.
![](/image/duyidu2pro_3.png)

**从input到hidden**, 和单context输入的CBOW没有区别: 

$\boldsymbol{h} = \boldsymbol{W}^{T}\boldsymbol{x} := \boldsymbol{v}^{T}_{w_{I}}$

**从hidden到output**, multinomial distribution从一个变成了多个, 下式中的c就是每一个概率分布的index.

$p(w_{c,j}=w_{O,c}|w_{I}) = y_{c,j} = \frac{exp(u_{c, j})}{\sum^{V}_{j^{'}=1}exp(u_{j}^{'})}$

而output layers是共享权重的, 所以

$u_{c,j}=u_{j}=\boldsymbol{v}_{w_{j}}^{'T}\cdot \boldsymbol{h}, \quad for\  c=1,2,\dots , C$

这不又和CBOW中一样了~ 因为输入是不变的, 唯一区别是真实的context word不同. 所以联立上面的式子, 就可以得到loss function:

$E = -\log p(w_{O,1},\dots ,w_{O, C}|W_{I}) \\ -log\prod^{C}_{c=1}\frac{exp(u_{c, j_{c}^{*}})}{\sum^{V}_{j^{'}=1}exp(u_{j'})}\\ = -u_{j^{*}}+\log \sum^{V}_{j^{'}=1}exp(u_{j^{'}})$

显然$j_{c}^{*}$对应的就是真实的context word. loss function对output的每个unit求微分, 就得到:

$\frac{\partial E}{\partial u_{c,j}} = y_{c,j} - t_{c,j} := e_{c,j}$

为了方便解释, 我们定义$EI = \{EI_{1}, \dots , EI_{V}\}$, 其中$EI_{j} = \sum_{c=1}^{C}e_{c,j}$. 那么和之前一样的步骤, 我们得到$\boldsymbol{W}^{'}$的更新公式是

$w_{ij}^{'(new)} = w_{ij}^{'(old)}- \eta\cdot EI_{j}\cdot h_{i}$

或者从输出向量的角度来考虑,

$v_{w_{j}}^{'(new)} = v_{w_{j}}^{'(old)}- \eta\cdot EI_{j}\cdot \boldsymbol{h} \quad for\  j = 1, 2, \dots , V$

$\boldsymbol{W}$的更新公式就是: 

$v_{w_{I}}^{(new)} = v_{w_{I}}^{(old)} - \eta EH^{T}$

这里的EH和之前稍有不同, EH是一个N维向量, 其中每一个元素等于$\sum^{V}_{j=1}EI_{j}\cdot {w_{ij}^{'}}$, i指EH中元素的index.

# 优化算法
在读一读2中提到过, CBOW和Skip-gram和NNLM相比, 简化的主要是hidden layer的计算. 说的更准确一点, 让我们看上面推导的概率公式, 可以发现在已知EH的情况下计算input vector $v_{w}$是容易的, 而复杂的计算主要存在于求output vector $v_{w}^{'}$时, 每一次的训练都需要对语料库中的每一个单词计算prediction error. 所以接下来我们需要思考怎么优化output vector $v_{w}^{'}$的计算. 

## Hierarchical Softmax
![](/image/duyidu2pro_4.png)
**Hierarchical Softmax**是优化softmax的算法. 其中白色的代表语料库中的单词, 深色的点代表Huffman Tree的inner units. 那么现在我们把一个单词是output word的概率定义为下式:

$p(w=w_{O}) = \prod^{L(w)-1}_{j=1}\sigma (F[n(w,j+1)=ch(n(w,j))]\cdot \boldsymbol{v}_{n(w,j)}^{'T}\cdot \boldsymbol{h})$

其中ch(n)指n的left child, $\boldsymbol{v}_{n(w,j)}^{'}$指每一个inner units对应的output vector, $\boldsymbol{h}$是hidden layer的输出(skip-gram中是$v_{w_{I}}$, CBOW中是$\frac{1}{C}\sum^{C}_{c=1}v_{w_{c}}$), F[]中等式成立则返回1, 不成立则返回-1, 在这里其实就是判断是否下一个inner unit是left child.

这样讲或许还不太清楚, 不如直接过一遍图中的计算. **记住我们最终的目的是让$w_{2}$是output word的概率尽量最大, 而现在这个概率通过求从root到leaf经过的每一个inner unit概率之积.** 现在首先定义在inner unit n向左走的概率是: $P(n, left) = \sigma (\boldsymbol{v}_{n}^{'T}\cdot \boldsymbol{h})$, 那么向右的概率就是$P(n, right) = 1-\sigma (\boldsymbol{v}_{n}^{'T}\cdot \boldsymbol{h})=sigma (-\boldsymbol{v}_{n}^{'T}\cdot \boldsymbol{h})$

那么整个路径走下来就是把这些概率连乘在一起, 也就是:

$p(w_{2}=w_{O}) \\= p(n(w_{2},1), left)\cdot p(n(w_{2},2), left) \cdot p(n(w_{2},3), right)\\= \sigma (-\boldsymbol{v}_{n(w_{2},1)}^{'T}\cdot \boldsymbol{h})\cdot \sigma (-\boldsymbol{v}_{n(w_{2},2)}^{'T}\cdot \boldsymbol{h}) \cdot \sigma (-\boldsymbol{v}_{n(w_{2},3)}^{'T}\cdot \boldsymbol{h})$

知道了这个公式的含义, 接下来我们就开始找loss function. 为了方便, 下面用$v_{j}^{'}$代替$-\boldsymbol{v}_{n(w,j)}^{'}$. 那么,

$E = -\log p(w=w_{O}|w_{I})=-\sum^{V}_{j=1}\log \sigma (F[...]v_{j}^{'T}\boldsymbol{h})$

对E做微分, 

$\frac{\partial E}{\partial \boldsymbol{v_{j}^{'}}\boldsymbol{h}} = \sigma (F[...] \boldsymbol{v}_{j}^{'T}\boldsymbol{h}-1)\cdot F[...] \\=\sigma (\boldsymbol{v}_{j}^{'T}\boldsymbol{h})-t_{j}\quad (t=1\ if\ F[...]=1\ otherwise\ 0)$ 

$\frac{\partial E}{\partial \boldsymbol{v_{j}^{'}}} = \frac{\partial E}{\partial \boldsymbol{v_{j}^{'}h}}\frac{\partial \boldsymbol{v_{j}^{'}h}}{\partial \boldsymbol{v_{j}^{'}}}=(\sigma (\boldsymbol{v_{j}^{'T}h})-t_{j})\cdot \boldsymbol{h}$ 

所以output vector的更新公式是:

$v_{j}^{'(new)}=v_{j}^{'(old)}-\eta (\sigma (\boldsymbol{v}_{j}^{'T}\boldsymbol{h})-t_{j})\cdot \boldsymbol{h}$

求$W$更新公式只需要求$\frac{\partial E}{\partial h}$也就是EH, 再代入没有优化的更新公式即可. 复杂度从原来的O(V)降到了O(log(V)). 注意才skip-gram中对每一个context word都需要进行一次计算. 在实际中用Huffman Tree可以使高频词更靠近root, 进一步减少计算.

## Negative Sampling
计算softmax时, 我们的问题是语料库极大所带来的大计算量, 那么为何不少计算一部分呢, 这就是Negative Sampling的idea. 每一轮的训练我们只考虑真实的样本(正样本)和sample出来的负样本. sample负样本的概率分布叫noise distribution, 写做$P_n(W)$. 在word2vec中, loss function被定义为了:

$E=-\log \sigma (\boldsymbol{v}_{\boldsymbol{w}_{O}^{'T}}\boldsymbol{h}) - \sum_{w_{j}\in W_{neg}} \log \sigma (-\boldsymbol{v_{w_{j}}}^{'T}\boldsymbol{h})$

还是求微分:

$\frac{\partial E}{\partial \boldsymbol{v_{w_{j}}^{'}}} = \frac{\partial E}{\partial \boldsymbol{v_{w_j}^{'}h}}\cdot \frac{\partial \boldsymbol{v_{w_j}^{'}h}}{\partial \boldsymbol{v_{w_j}^{'}}} = (\sigma (\boldsymbol{v_{w_j}^{'T}h})-t_j)\boldsymbol{h}$ 

其中$t_{j}$为正样本的时候值为1, 反之为0. 那么output vector的更新公式就是:

$v_{j}^{'(new)}=v_{w_j}^{'(old)}-\eta (\sigma (\boldsymbol{v_{w_j}}_{j}^{'T}\boldsymbol{h})-t_{j})\cdot \boldsymbol{h}$

其实和之前的公式长得一模一样, 只是这里的$w_j$只包含正样本和sample出的负样本. 求EH的方法不变, 把EH带入未做优化的更新公式就能得到input vector的更新公式, 这里不再赘述.

## REFERENCES
[1] **word2vec Parameter Learning Explained**. Xin Rong. [paper](https://arxiv.org/abs/1411.2738)

[2] **CS224n: Natural Language Processing with Deep Learning: note1**. [paper](http://web.stanford.edu/class/cs224n/readings/cs224n-2019-notes01-wordvecs1.pdf)