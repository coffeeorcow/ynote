<template>
<div class="edit-panel">
    <span style="font-weight: bold;">笔记标题:&nbsp;&nbsp;</span>
    <a-input placeholder="请输入文章标题" v-model="noteData.note.title" ref="titleInput" style="width: 200px;">
        <a-icon slot="prefix" type="pushpin" />
        <a-icon v-if="noteData.note.title" slot="suffix" type="close-circle" @click="clearTitle" />
    </a-input>
    <span style="margin-left:20px; font-weight: bold;">存放位置：</span>
    <a-button v-if="selectBtnShow" icon="hdd" @click="toSelectCategory">选择</a-button>
    <span v-else 
        @click="toSelectCategory" 
        :v-show="!selectBtnShow"
        style="cursor: default;"
    >{{ noteData.path }}</span>
    <a-modal
        title="选择存放位置"
        :visible="notebookVisible"
        @cancel="() => this.notebookVisible=false"
        @ok="handleNotebook">
        <template slot="footer">
            <a-button key="submit" @click="handleNotebook">确定</a-button>
        </template>
        <h2 v-if="categories.length == 0">还未创建过笔记本，现在去创建吗？</h2>
        <a-directory-tree v-else :loadData="onLoadCategory" :treeData="categories" @select="selectCategory"/>
    </a-modal>
    <span style="margin-left: 20px; font-weight: bold;">标签:&nbsp;&nbsp;</span>
    <template v-if="noteData.tags.length > 0">
        <template v-for="(tag, index) in noteData.tags">
            <a-tag 
                class="right"
                color="cyan"
                :key="tag.tagName" 
                :closable="true" 
                :afterClose="() => handleClose(tag)">
                {{ tag.tagName }}
            </a-tag>
        </template>
    </template>
    <a-input
        v-if="inputVisible"
        ref="input"
        type="text"
        size="small"
        :style="{ width: '78px' }"
        :value="tagName"
        @change="tagNameInputChange"
        @blur="tagNameInputConfirm"
        @keyup.enter="tagNameInputConfirm"
    />
    <a-tag v-else 
        color="pink"
        @click="showInput" style="background: #fff; borderStyle: dashed;">
        <a-icon type="plus" /> 添加标签
    </a-tag>

    <mavon-editor 
        class="editor"
        :toolbars="editorOption" 
        v-model="noteData.note.content" 
        :shortCut="true" 
        :boxShadow="false" 
        ref=md
        @imgAdd="$imgAdd"
        @imgDel="$imgDel"
        @save="uploadNote"
        />
</div>
</template>

<script>
import { setTimeout } from 'timers';
export default {
    data() {
        return {
            editorOption: {
                bold: true, // 粗体
                italic: true, // 斜体
                header: true, // 标题
                underline: true, // 下划线
                strikethrough: true, // 中划线
                mark: true, // 标记
                superscript: true, // 上角标
                subscript: true, // 下角标
                quote: true, // 引用
                ol: true, // 有序列表
                ul: true, // 无序列表
                link: true, // 链接
                imagelink: true, // 图片链接
                code: true, // code
                table: true, // 表格
                fullscreen: true, // 全屏编辑
                readmodel: true, // 沉浸式阅读
                htmlcode: false, // 展示html源码
                help: true, // 帮助
                /* 1.3.5 */
                undo: true, // 上一步
                redo: true, // 下一步
                trash: true, // 清空
                save: true, // 保存（触发events中的save事件）
                /* 1.4.2 */
                navigation: true, // 导航目录
                /* 2.1.8 */
                alignleft: true, // 左对齐
                aligncenter: true, // 居中
                alignright: true, // 右对齐
                /* 2.2.1 */
                subfield: true, // 单双栏模式
                preview: true, // 预览
            },
            inputVisible: false,
            selectBtnShow: true,
            notebookVisible: false,
            img_file: {},
            isNewNote: true,
            categories: [],
            tagName: '',
            noteData: {
                note: {
                    title: '',
                    content: ''
                },
                category: {
                    cateName: ''
                },
                tags: [],
                path: ''
            },
            contentChangedFlag: false
        }
    },

    watch: {
        contentChanged(newVal, oldVal) {
            if (!this.noteData.note.content.trim() === '') {
                this.contentChangedFlag = true;
            }
        }
    },

    computed: {
        contentChanged() {
            return this.noteData.note.content;
        }
    },

    methods: {
        // 删除已显示的标签
        handleClose(removedTag) {
            const tags = this.noteData.tags.filter(tag => tag.tagName !== removedTag.tagName);
            this.noteData.tags = tags;
        },

        // 显示添加标签的输入框
        showInput() {
            this.inputVisible = true;
            this.$nextTick(function() {
                this.$refs.input.focus();
            });
        },

        // 修改标签名触发的事件
        tagNameInputChange(e) {
            this.tagName = e.target.value;
        },

        // 确定添加标签
        tagNameInputConfirm() {
            const tagName = this.tagName;
            let tags = this.noteData.tags;
            if (tagName && tags.findIndex((t) => t.tagName == tagName) === -1) {
                tags = [...tags, {tagName: tagName}];
            }
            this.noteData.tags = tags;
            this.inputVisible = false;
            this.tagName = '';
        },

        // 打开选择存放位置组件
        toSelectCategory() {
            this.notebookVisible = true;
        },

        // 点击选择位置的确定按钮
        handleNotebook() {
            this.notebookVisible = false;
            if (this.categories.length == 0) {
                this.$router.push('/home/notebook');
            }
        },

        // 加载目录数据
        onLoadCategory(treeNode) {
            return new Promise((resolve) => {
                if (treeNode.dataRef.children) {
                    resolve();
                    return;
                }
                treeNode.dataRef.children = [];
                let cid = treeNode.dataRef.id;
                let uid = this.$store.state.user.id;
                // 加载目录
                this.axios.get(`/category/findCategory?uid=${uid}&cid=${cid}`)
                .then((resp) => {
                    let categories = resp.data.data;
                    if (categories.length != 0) {
                        for (let i = 0; i < categories.length; i++) {
                            let c = categories[i];
                            c.title = c.cateName;
                            c.key = c.id;
                            treeNode.dataRef.children.push(c);
                        }
                    }
                    this.categories = [...this.categories];
                    resolve();
                });
            })
        },

        // 点击目录树中的目录
        selectCategory(selectedKeys, {node}) {
            let c = node.dataRef;
            this.noteData.category = {
                id: c.id,
                cateName: c.cateName,
                uid: c.uid,
                cid: c.cid
            };
            this.axios.get('/category/findCategoryPath?cid='+c.id)
            .then((resp) => {
                this.noteData.path = resp.data.data.pathURL;
            })
            this.selectBtnShow = false;
        },

        // 添加图片触发事件
        $imgAdd(pos, $file) {
            this.img_file[pos] = $file;
        },

        // 删除图片触发事件
        $imgDel(pos) {
            delete this.img_file[pos];
        },

        // 保存，上传笔记信息
        uploadNote(value) {
            if (!this.isNewNote) {
                this.updateNote();
                return;
            }
            if (value.trim() == '') {
                this.$message.warning('笔记内容不能为空！');
                return;
            }
            if (this.noteData.note.title.trim() == '') {
                this.$message.warning('请填写笔记标题！');
                this.$refs.titleInput.focus();
                return;
            }
            if (typeof(this.noteData.category.id) == "undefined" || this.noteData.category.id == 0) {
                this.notebookVisible = true;
                this.$message.warning('请选择笔记存放位置');
                return;
            }
            let param = new FormData();
            // set uid
            param.set('uid', this.$store.state.user.id);
            // set note
            param.set('note.title', this.noteData.note.title);
            param.set('note.content', value);
            param.set('note.cid', this.noteData.category.id);
            // set tags
            this.noteData.tags.forEach((tag, index) => {
                param.append(`tags[${index}].tagName`, tag.tagName);
            });
            // append files
            for(var _img in this.img_file) {
                param.append(`files[${parseInt(_img)-1}]`, this.img_file[_img]);
                param.append(`images[${parseInt(_img)-1}].oldPos`, _img);
            }
            let config = {
                headers: {
                    "Content-Type": "multipart/form-data"
                }
            };
            this.axios.post('/note/insert', param, config)
            .then((resp) => {
                if (resp.data.status == '10000') {
                    // 笔记上传成功
                    let images = resp.data.data.images;
                    if (typeof(images) != 'undefined' && images!=null && images.length != 0) {
                        images.forEach((v, i) => {
                            this.$refs.md.$img2Url(v.oldPos, this.$baseURL+v.pos);
                        });
                        this.img_file = {};
                        this.$refs.md.$refs.toolbar_left.img_file = [[0, null]];
                    }
                    this.noteData.note = resp.data.data.note;
                    this.isNewNote = false;
                    this.$store.commit('setNoteData', resp.data.data.note);
                    this.updateNote();
                } else {
                    this.$message.error(resp.data.msg);
                }
            })
        },

        // 保存，更新笔记信息
        updateNote() {
            if (this.noteData.note.content.trim() == '') {
                this.$message.warning('笔记内容不能为空！');
                return;
            }
            if (this.noteData.note.title == '') {
                this.$message.warning('请填写笔记标题！');
                this.$refs.titleInput.focus();
                return;
            }
            if (this.noteData.category == null ||
                typeof(this.noteData.category.id) == "undefined" 
                || this.noteData.category.id ==  null
                || this.noteData.category.id == 0) {
                this.notebookVisible = true;
                this.$message.warning('请选择笔记存放位置');
                return;
            }
            let param = new FormData();
            // set uid
            param.set('uid', this.$store.state.user.id);
            // set note
            param.set('note.id', this.noteData.note.id);
            param.set('note.title', this.noteData.note.title);
            param.set('note.content', this.noteData.note.content);
            param.set('note.cid', this.noteData.category.id);
            // set tags
            this.noteData.tags.forEach((tag, index) => {
                param.append(`tags[${index}].tagName`, tag.tagName);
            });
            // append files
            for(var _img in this.img_file) {
                param.append(`files[${parseInt(_img)-1}]`, this.img_file[_img]);
                param.append(`images[${parseInt(_img)-1}].oldPos`, _img);
            }
            let config = {
                headers: {
                    "Content-Type": "multipart/form-data"
                }
            };
            this.axios.post('/note/update', param, config)
            .then((resp) => {
                if (resp.data.status == '10000') {
                    this.noteData.note = resp.data.data.note;
                    this.contentChangedFlag = false;
                    this.$store.commit('setNoteData', resp.data.data.note);
                    this.$message.success('笔记保存成功！');
                    let images = resp.data.data.images;
                    if (typeof(images) != 'undefined' && images!=null && images.length != 0) {
                        images.forEach((v, i) => {
                            if (typeof(v.oldPos) != 'undefined' && v.oldPos != null) {
                                this.$refs.md.$img2Url(v.oldPos, this.$baseURL+v.pos);
                            }
                        });
                        this.img_file = {};
                        this.$refs.md.$refs.toolbar_left.img_file = [[0, null]];
                    }
                } else {
                    this.$message.error(resp.data.msg);
                }
            })

        },

        // 清除笔记标题
        clearTitle() {
            this.$refs.titleInput.focus();
            this.noteData.note.title = '';
        },

    },

    mounted() {
        // 初始化目录
        this.axios.get(`/category/findCategory?uid=${this.$store.state.user.id}&cid=-1`)
        .then((resp) => {
            if (resp.data) {
                let categories = resp.data.data;
                if (categories.length != 0) {
                    for (let i = 0; i < categories.length; i++) {
                        let c = categories[i];
                        c.title = c.cateName;
                        c.key = c.id;
                        this.categories.push(c);
                    }
                }
            }
        });
        if (this.$store.state.updateNoteFlag) {
            // 更新笔记
            this.isNewNote = false;
            let noteData = this.$store.state.noteData;
            this.noteData = noteData;
            this.selectBtnShow = false;
        } else if (this.$store.state.hasCategoryFlag) {
            // 在指定目录下新建目录
            let noteData = this.$store.state.noteData;
            this.axios.get('/category/findCategoryPath?cid='+noteData.category.id)
            .then((resp) => {
                this.noteData.path = resp.data.data.pathURL;
                this.noteData.category = resp.data.data.category;
                this.selectBtnShow = false;
            });
        }
        this.$nextTick(() => {
            this.$refs.titleInput.focus();
        });
    },

    beforeRouteLeave (to, from, next) {
        let _this = this;
        if (to.path === '/home/editor') {
            // 当前页面
        } else {
            if (_this.contentChangedFlag) {
                _this.$confirm({
                    title: '警告',
                    content: '当前笔记未保存，是否仍要离开页面',
                    okText: '离开',
                    okType: 'danger',
                    cancelText: '取消',
                    onOk() {
                        _this.$store.commit('clearFlag');
                        next();
                    },
                    onCancel() {
                        _this.$emit('update-selected-keys', ['2']);
                        next(false);
                    }
                });
            } else {
                _this.$store.commit('clearFlag');
                next();
            }
        }
    }
}
</script>

<style scoped>
.edit-panel {
    margin: 5px;
    -webkit-box-shadow: 0 1px 4px rgba(0,21,41,.08);
    box-shadow: 0 1px 4px rgba(0,21,41,.08);
}
.editor {
    z-index: 10;
    clear: both;
    min-height: 500px;
}
</style>
