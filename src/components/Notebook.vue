<template>
<div class="notebook">
<a-row type="flex" justify="space-between">
<a-col :span="9">
    <a-card class="category-tree">
        <h1 style="float: left; color: purple;">笔记本</h1>
        <div v-if="hasNode" style="float: right; margin-bottom: 15px;">
            <span class="rename" @click="renameNode"><a-icon type="tool" /> 重命名 </span>
            <span class="delete" @click="deleteNode"><a-icon type="delete" /> 删除 </span>
            <span v-if="!currentNode.isLeaf" class="insert-note" @click="insertNote"><a-icon type="file-add" /> 添加笔记</span>
        </div>
        <div style="clear:both;">
            <!-- 修改目录/笔记名称 -->
            <a-modal v-model="rename.modalVisible" :title="rename.title" @ok="updateNoteName">
                <a-input v-model="rename.value" ref="renameInput" placeholder="请输入新名称" @keyup.enter="updateNoteName">
                    <a-icon slot="prefix" type="book" />
                    <a-icon v-if="rename.value" slot="suffix" type="close-circle" @click="rename.value = ''" />
                </a-input>
            </a-modal>

            <a-input placeholder="在当前位置插入目录" 
                v-model="category.cateName"
                ref="cateNameInput"
                class="cateNameInput">
                    <a-icon slot="prefix" type="book" />
                    <a-icon v-if="category.cateName" slot="suffix" type="close-circle" @click="()=>category.cateName=''" />
            </a-input>
            <a-icon type="plus-circle" @click="addCategory" class="addCategoryBtn" />
        </div>
        <h1 v-if="treeData.length == 0" style="margin-top: 10px;">暂未添加任何笔记本~</h1>
        <a-directory-tree
            v-else
            :v-show="false"
            :loadData="onLoadData" 
            :treeData="treeData"
            draggable
            @dragenter="onDragEnter"
            @drop="onDrop"
            @select="selectedNote"
        />
    </a-card>
</a-col>
<a-col v-if="showNote" :span="14">
    <note 
        v-bind:note-data="notedata" 
        style="margin-right: 10px;"
        @delete-note="deleteNote"
    />
</a-col>
<a-col v-if="showNoteList" :span="12">
    <SimpleNoteList
        :cid="cid"
        style="margin-right: 20px;" 
        @delete-note="deleteNoteFromCategory"
        @view-note="viewNote"
     />
</a-col>
</a-row>
</div>
</template>

<script>
import Note from '@/components/Note.vue';
import SimpleNoteList from '@/components/SimpleNoteList.vue';

const find = (data, key, callback) => {
    data.forEach((item, index, arr) => {
        if (item.key == key) {
            return callback(item, index, arr);
        }
        if (item.children) {
            find(item.children, key, callback);
        }
    })
}

export default {
    components: {
        Note,
        SimpleNoteList
    },
    data() {
        return {
            treeData: [],
            currentNode: {},
            hasNode: false,
            category: {
                cateName: ''
            },
            notedata: {},
            showNote: false,
            rename: {
                modalVisible: false,
                value: '',
                title: ''
            },
            showNoteList: false,
            cid: -1
        }
    },

    methods: {
        onLoadData(treeNode) {
            return new Promise((resolve) => {
                if(treeNode.dataRef.children) {
                    resolve()
                    return;
                }
                treeNode.dataRef.children = [];
                let cid = treeNode.dataRef.id;
                // 加载目录
                this.axios.get(`/category/find?uid=${this.$store.state.user.id}&cid=${cid}`)
                .then((resp) => {
                    let categories = resp.data.categories;
                    let notes = resp.data.notes;
                    if (categories.length != 0) {
                        for (let i = 0; i < categories.length; i++) {
                            let c = categories[i];
                            c.title = c.cateName;
                            c.key = '0' + c.id;
                            treeNode.dataRef.children.push(c);
                        }
                    }
                    if (notes.length != 0) {
                        for (let i = 0; i < notes.length; i++) {
                            let n = notes[i];
                            delete n.content;
                            n.key = n.id;
                            n.content = null;   // 减少资源占用
                            n.isLeaf = true;
                            treeNode.dataRef.children.push(n);
                        }
                    }
                    this.treeData = [...this.treeData];
                    resolve();
                })
                .catch((err) => {
                    this.$message.error('服务器出错了~~');
                });
            })
        },

        onDragEnter(info) {
            // console.log("onDragEnter...")
            // console.log(info);
        },

        onDrop(info) {
            const dropKey = info.node.eventKey;
            const dragKey = info.dragNode.eventKey;
            const dropPos = info.node.pos.split('-');
            const dropPosition = info.dropPosition - Number(dropPos[dropPos.length - 1]);
            const loop = (data, key, callback) => {
                data.forEach((item, index, arr) => {
                    if (item.key === key) {
                        return callback(item, index, arr);
                    }
                    if (item.children) {
                        return loop(item.children, key, callback);
                    }
                })
            }
            const treeData = [...this.treeData];

            // 修改目录请求
            let updateCategory = (param) => {
                if (param.isLeaf) {
                    this.axios.post('/note/onlyUpdateNote', param)
                    .then((resp) => {
                        if (resp.data.status == '10000') {
                            this.$message.success('移动成功！')
                        } else {
                            this.$message.error('移动失败！');
                        }
                    })
                } else {
                    this.axios.post('/category/update', param)
                    .then((resp) => {
                        if (resp.data.status == '10000') {
                            this.$message.success('移动成功！')
                        } else {
                            this.$message.error('移动失败！');
                        }
                    });
                }
            };

            // 找到拖拽的元素
            let dragNode;
            if (!info.dropToGap) {
                // 选中插入
                loop(treeData, dragKey, (item, index, arr) => {
                    arr.splice(index, 1);
                    dragNode = item;
                });
                loop(treeData, dropKey, (item) =>{
                    item.children = item.children || [];
                    item.children.push(dragNode);
                    dragNode.cid = item.id;
                    updateCategory(dragNode);
                });
            } else if (
                (info.node.children || []).length > 0
                && info.node.expand
                && dropPosition === 1
            ) {
                // 缺口处插入
                loop(treeData, dragKey, (item, index, arr) => {
                    arr.splice(index, 1);
                    dragNode = item;
                });
                loop(treeData, dropKey, (item) => {
                    item.children = item.children || [];
                    item.children.unshift(dragNode);
                    dragNode.cid = item.id;
                    updateCategory(dragNode);
                });
            } else {
                loop(treeData, dragKey, (item) => {
                    dragNode = item;
                })
                if (dropPosition === -1) {
                    this.$message.warning('请移动到正确的位置！');
                }
            }
            this.treeData = treeData;
        },
        
        selectedNote(selectedKeys, {node}) {
            this.hasNode = true;
            this.currentNode = node.dataRef;
            if (this.currentNode.isLeaf) {
                // 显示笔记
                this.showNoteList = false;
                this.axios.get('/note/findOne?id='+this.currentNode.id)
                .then((resp) => {
                    if (resp.data.status == '10000') {
                        this.notedata = resp.data.data;
                        if (this.notedata) {
                            this.showNote = true;
                        }
                    }
                })
            } else {
                // 显示笔记列表
                this.showNote = false;
                this.showNoteList = true;
                this.cid = node.dataRef.id;
            }
        },

        renameNode() {
            if (this.currentNode.isLeaf) {
                this.rename.title = '修改笔记名称';
            } else {
                this.rename.title = '修改目录名称';
            }
            this.rename.modalVisible = true;
            this.$nextTick(() => {
                this.$refs.renameInput.focus();
            });
        },
        
        updateNoteName() {
            // 更新笔记名
            if (this.rename.value.trim() == '') {
                this.$message.error('新名称不能为空！');
                return;
            }
            let currentNode = this.currentNode;
            if (this.currentNode.isLeaf) {
                // 更新笔记
                let param = {
                    id: currentNode.id,
                    title: this.rename.value
                };
                currentNode.title = this.rename.value;
                this.axios.post('/note/onlyUpdateNote', param)
                .then((resp) => {
                    if (resp.data.status == '10000') {
                        this.$message.success('修改成功！');
                        let treeData = this.treeData;
                        find(treeData, currentNode.key, (item, index, arr)=> {
                            item.title = currentNode.title;
                        });
                        this.treeData = [...treeData];
                        this.rename.modalVisible = false;
                    } else {
                        this.$message.error('修改失败！');
                    }
                })
            } else {
                // 更新目录
                let param = {
                    id: currentNode.id,
                    cateName: this.rename.value
                };
                currentNode.cateName = this.rename.value;
                currentNode.title = currentNode.cateName;
                this.axios.post('/category/update', param)
                .then((resp) => {
                    if (resp.data.status == '10000') {
                        this.$message.success('修改成功！');
                        let treeData = this.treeData;
                        find(treeData, currentNode.key, (item, index, arr)=> {
                            item.title = currentNode.cateName;
                            item.cateName = currentNode.cateName;
                        });
                        this.treeData = [...treeData];
                        this.rename.modalVisible = false;
                    } else {
                        this.$message.error('修改失败！');
                    }
                });
                this.rename.modalVisible = false;
            }
        },
         
        deleteNode() {
            let _this = this;
            const loop = (data, key, callback) => {
                data.forEach((item, index, arr) => {
                    if (item.key === key) {
                        return callback(item, index, arr);
                    }
                    if (item.children) {
                        return loop(item.children, key, callback);
                    }
                });
            }
            if (this.currentNode.isLeaf) {
                // 笔记
                _this.$confirm({
                    title: '确定要删除该笔记吗?',
                    content: '删除后将不可撤回！',
                    onOk() {
                        _this.axios.get('/note/delete?id='+_this.currentNode.id)
                        .then((resp) => {
                            if (resp.data.status == '10000') {
                                _this.$message.success('笔记删除成功！');
                                let treeData = _this.treeData;
                                loop(treeData, _this.currentNode.key, (item, index, arr) => {
                                    arr.splice(index, 1);
                                });
                                _this.hasNode = false;
                                _this.treeData = [...treeData];
                            } else {
                                _this.$message.error('笔记删除失败!');
                            }
                        })
                    },
                    onCancel() {},
                });
            } else {
                // 目录
                _this.$confirm({
                    title: '确定要删除该笔记本吗?',
                    content: '这将删除该目录下的所有笔记，且不可撤回！',
                    onOk() {
                        _this.axios.get('/category/delete?id='+_this.currentNode.id)
                        .then((resp) => {
                            if (resp.data.status == '10000') {
                                _this.$message.success('目录删除成功！');
                                let treeData = _this.treeData;
                                loop(treeData, _this.currentNode.key, (item, index, arr) => {
                                    arr.splice(index, 1);
                                });
                                _this.hasNode=false;
                                _this.treeData = [...treeData];
                            } else {
                                _this.$message.error('目录删除失败!');
                            }
                        })
                    },
                    onCancel() {},
                });
            }
        },

        addCategory() {
            if (this.category.cateName.trim() == '') {
                this.$message.error('目录名不能为空');
                this.$refs.cateNameInput.focus();
                return;
            }
            this.category.uid = this.$store.state.user.id;
            if (this.hasNode) {
                this.category.cid = this.currentNode.isLeaf ? this.currentNode.cid : this.currentNode.id;
            } else {
                this.category.cid = -1;
            }
            this.axios.post('/category/insert', this.category)
            .then((resp) => {
                if (resp.data.status == '10000') {
                    this.$message.success('目录添加成功');
                    this.$nextTick(() => {
                        this.$router.go(0);
                    });
                } else {
                    this.$message.error(resp.data.msg);
                }
            })
        },

        insertNote() {
            let noteData = {
                category: this.currentNode,
                note: {
                    title: '',
                    content: '',
                },
                tags: [],
                path: ''
            };
            this.axios.get('/category/findCategoryPath?cid='+noteData.category.id)
            .then((resp) => {
                if (resp.data.status == '10000') {
                    noteData.path = resp.data.data.pathURL;
                    this.$store.commit('clearFlag');
                    this.$store.commit('setHasCategoryFlag', true);
                    this.$store.commit('setNoteData', noteData);
                    this.$router.push('/home/editor');
                }
            });
        },

        deleteNote(noteData) {
            // 删除笔记后需要做的事
            // 更新目录
            if (this.notedata.note) {
                let treeData = this.treeData;
                find(treeData, this.notedata.note.id, (item, index, arr) => {
                    arr.splice(index, 1);
                });
                this.treeData = [...treeData];
            }
            this.showNote = false;
        },

        deleteNoteFromCategory(noteData) {
            let treeData = this.treeData;
            find(treeData, this.notedata.note.id, (item, index, arr) => {
                arr.splice(index, 1);
            });
            this.treeData = [...treeData];
        },

        viewNote(noteData) {
            this.notedata = noteData;
            this.showNoteList = false;
            this.showNote = true;
        }

    },

    mounted() {
        // 设置文件树
        this.axios.get(`/category/find?uid=${this.$store.state.user.id}&cid=-1`)
        .then((resp) => {
            if(resp.data) {
                let categories = resp.data.categories;
                if (categories.length != 0) {
                    for (let i = 0; i < categories.length; i++) {
                        let v = categories[i];
                        v.title = v.cateName;
                        v.key = '0'+v.id;
                        this.treeData.push(v);
                    }
                }
            }
        })
        .catch((err) => {
            this.$message.error('服务器出错了~~');
        });
        if (this.$store.state.showNoteFlag) {
            // 由主页点击笔记跳转过来的
            this.notedata = this.$store.state.noteData;
            this.showNoteList = false;
            this.showNote = true;
            this.$store.commit('setShowNoteFlag', false);
        }
    },

}
</script>


<style scoped>
.notebook {
    width: 100%;
    height: 100%;
    margin: 10px 0 0 10px;
}
.right-menu {
    border: 1px solid #eee;
    box-shadow: 0 0.5em 1em 0 rgba(0,0,0,.1);
    position: fixed;
    background: #fff;
    border: solid 1px rgba(0, 0, 0, .2);
    border-radius: 3px;
    z-index: 999;
    display: none;
}
.right-menu a {
  width: 75px;
  height: 32px;
  line-height: 28px;
  text-align: center;
  display: block;
  color: #1a1a1a;
}
a {
    text-decoration: none;
}
.right-menu a:hover {
    background: #42b983;
}
.rename {
    margin-right: 20px;
    cursor: default;
}
.rename:hover {
    color: orange;
    font-weight: bold;
    cursor: default;
}
.delete {
    margin-right: 20px;
    cursor: default;
}
.delete:hover {
    color: red;
    font-weight: bold;
    cursor: default;
}
.insert-note {
    cursor: default;
}
.insert-note:hover {
    color: green;
    font-weight: bold;
    cursor: default;
}
.cateNameInput {
    width: 200px;
    margin-right: 10px;
}
.addCategoryBtn {
    font-size: 22px;
}
.addCategoryBtn:hover {
    color: green;
}
</style>
