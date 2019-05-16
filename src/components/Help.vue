<template>
<div class="help">
<a-row type="flex" justify="center">
    <a-col :span="16">
        <a-card title="基于Java的云端笔记">
            <p><span class="attr-str">开发者：</span>吴俊逸</p>
            <p><span class="attr-str">指导老师：</span>李文军</p>
            <a-divider />

<div class="scroll-style v-note-help-show"><ul><li><a href="#Markdown__2">Markdown 语法简介</a></li><ul><li><a href="#_6">**粗体**</a></li><li><a href="#_11">*斜体*</a></li><li><a href="#_16">标题</a></li><li><a href="#_29">分割线</a></li><li><a href="#_35">^上^角~下~标</a></li><li><a href="#__40">++下划线++ ~~中划线~~</a></li><li><a href="#_45">==标记==</a></li><li><a href="#_49">段落引用</a></li><li><a href="#_57">列表</a></li><li><a href="#_70">任务列表</a></li><li><a href="#_80">链接</a></li><li><a href="#_85">代码段落</a></li><li><a href="#table_101">表格(table)</a></li><li><a href="#footnote_112">脚注(footnote)</a></li><li><a href="#emoji_121">表情(emoji)</a></li><li><a href="#KaTeX_132">$\KaTeX$公式</a></li><li><a href="#_139">布局</a></li><li><a href="#_159">定义</a></li><li><a href="#abbr_188">abbr</a></li></ul></ul><p></p>
<h1><a id="Markdown__2"></a>Markdown 语法简介</h1>
<blockquote>
<p><a href="http://commonmark.org/help/" target="_blank">语法详解</a></p>
</blockquote>
<h2><a id="_6"></a><strong>粗体</strong></h2>
<pre><code class="lang-">**粗体**
__粗体__
</code></pre>
<h2><a id="_11"></a><em>斜体</em></h2>
<pre><code class="lang-">*斜体*
_斜体_
</code></pre>
<h2><a id="_16"></a>标题</h2>
<pre><code class="lang-"># 一级标题 #
一级标题
====
## 二级标题 ##
二级标题
----
### 三级标题 ###
#### 四级标题 ####
##### 五级标题 #####
###### 六级标题 ######
</code></pre>
<h2><a id="_29"></a>分割线</h2>
<pre><code class="lang-">***
---
</code></pre>
<hr>
<h2><a id="_35"></a><sup>上</sup>角<sub>下</sub>标</h2>
<pre><code class="lang-">上角标 x^2^
下角标 H~2~0
</code></pre>
<h2><a id="__40"></a><ins>下划线</ins> <s>中划线</s></h2>
<pre><code class="lang-">++下划线++
~~中划线~~
</code></pre>
<h2><a id="_45"></a><mark>标记</mark></h2>
<pre><code class="lang-">==标记==
</code></pre>
<h2><a id="_49"></a>段落引用</h2>
<pre><code class="lang-">&gt; 一级
&gt;&gt; 二级
&gt;&gt;&gt; 三级
...
</code></pre>
<h2><a id="_57"></a>列表</h2>
<pre><code class="lang-">有序列表
1.
2.
3.
...
无序列表
-
-
...
</code></pre>
<h2><a id="_70"></a>任务列表</h2>
<ul class="contains-task-list">
<li class="task-list-item"><input class="task-list-item-checkbox" checked="" disabled="" type="checkbox"> 已完成任务</li>
<li class="task-list-item"><input class="task-list-item-checkbox" disabled="" type="checkbox"> 未完成任务</li>
</ul>
<pre><code class="lang-">- [x] 已完成任务
- [ ] 未完成任务
</code></pre>
<h2><a id="_80"></a>链接</h2>
<pre><code class="lang-">[链接](www.baidu.com)
![图片描述](http://www.image.com)
</code></pre>
<h2><a id="_85"></a>代码段落</h2>
<p>``` type</p>
<p>代码段落</p>
<p>```</p>
<p>` 代码块 `</p>
<pre><code class="lang-c++">int main()
{
    printf("hello world!");
}
</code></pre>
<p><code>code</code></p>
<h2><a id="table_101"></a>表格(table)</h2>
<pre><code class="lang-">| 标题1 | 标题2 | 标题3 |
| :--  | :--: | ----: |
| 左对齐 | 居中 | 右对齐 |
| ---------------------- | ------------- | ----------------- |
</code></pre>
<table>
<thead>
<tr>
<th style="text-align:left">标题1</th>
<th style="text-align:center">标题2</th>
<th style="text-align:right">标题3</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left">左对齐</td>
<td style="text-align:center">居中</td>
<td style="text-align:right">右对齐</td>
</tr>
<tr>
<td style="text-align:left">----------------------</td>
<td style="text-align:center">-------------</td>
<td style="text-align:right">-----------------</td>
</tr>
</tbody>
</table>
<h2><a id="footnote_112"></a>脚注(footnote)</h2>
<pre><code class="lang-">hello[^hello]
</code></pre>
<p>见底部脚注<sup class="footnote-ref"><a href="#fn1" id="fnref1">[1]</a></sup></p>
<h2><a id="emoji_121"></a>表情(emoji)</h2>
<p><a href="https://www.webpagefx.com/tools/emoji-cheat-sheet/" target="_blank">参考网站: https://www.webpagefx.com/tools/emoji-cheat-sheet/</a></p>
<pre><code class="lang-">:laughing:
:blush:
:smiley:
:)
...
</code></pre>
<p>😆😊😃😃</p>
<h2><a id="KaTeX_132"></a>$\KaTeX$公式</h2>
<p>我们可以渲染公式例如：$x_i + y_i = z_i$和$\sum_{i=1}^n a_i=0$<br>
我们也可以单行渲染<br>
$$\sum_{i=1}^n a_i=0$$<br>
具体可参照<a href="http://www.intmath.com/cg5/katex-mathjax-comparison.php" target="_blank">katex文档</a>和<a href="https://github.com/Khan/KaTeX/wiki/Function-Support-in-KaTeX" target="_blank">katex支持的函数</a>以及<a href="https://math.meta.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference" target="_blank">latex文档</a></p>
<h2><a id="_139"></a>布局</h2>
<div class="hljs-left">
<p><code>::: hljs-left</code><br>
<code>居左</code><br>
<code>:::</code></p>
</div>
<div class="hljs-center">
<p><code>::: hljs-center</code><br>
<code>居中</code><br>
<code>:::</code></p>
</div>
<div class="hljs-right">
<p><code>::: hljs-right</code><br>
<code>居右</code><br>
<code>:::</code></p>
</div>
<h2><a id="_159"></a>定义</h2>
<dl>
<dt>术语一</dt>
<dd>
<p>定义一</p>
</dd>
<dt>包含有<em>行内标记</em>的术语二</dt>
<dd>
<p>定义二</p>
<pre><code>  {一些定义二的文字或代码}
</code></pre>
<p>定义二的第三段</p>
</dd>
</dl>
<pre><code class="lang-">术语一

:   定义一

包含有*行内标记*的术语二

:   定义二

        {一些定义二的文字或代码}

    定义二的第三段

</code></pre>
<h2><a id="abbr_188"></a>abbr</h2>
<p><abbr title="Hyper Text Markup Language">HTML</abbr> 规范由 <abbr title="World Wide Web Consortium">W3C</abbr> 维护</p>
<pre><code class="lang-">*[HTML]: Hyper Text Markup Language
*[W3C]:  World Wide Web Consortium
HTML 规范由 W3C 维护
</code></pre>
<hr class="footnotes-sep">
<section class="footnotes">
<ol class="footnotes-list">
<li id="fn1" class="footnote-item"><p>一个注脚 <a href="#fnref1" class="footnote-backref">↩︎</a></p>
</li>
</ol>
</section>
</div>


        </a-card>
    </a-col>
</a-row>
</div>
</template>

<style scoped>
.help {
    width: 100%;
    height: 100%;
    margin: 10px 0 0 10px;
}
.attr-str {
    font-weight: bold;
}
.scroll-style {
    height: 400px;
    overflow: auto;
}
</style>
