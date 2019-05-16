<template>
<div :class="{'simple-note-lit': noteList.length>0}">
    <h1 v-if="noteList.length == 0" style="color: purple; margin: 20px;">没有笔记信息！</h1>
    <a-list
        v-else
        itemLayout="vertical"
        :pagination="pagination"
        :dataSource="noteList"
    >
        <a-list-item slot="renderItem" slot-scope="item, index" key="item.note.title">
            <a slot="actions" @click="editNote(item)">编辑</a>
            <a slot="actions" @click="viewNote(item)">查看</a>
            <a slot="actions" @click="deleteNote(item)">删除</a>
            <a-list-item-meta>
                <span slot="title" >
                    <span style="font-size: 22px; float: left;">{{item.note.title}}</span>
                    <span style="font-size: 14px; float: right; color: orange;">{{item.note.createTime}}</span>
                </span>
            </a-list-item-meta>
            <span style="">笔记位置：{{item.path}}</span>
            <br>
            <span>标签：</span>
            <template v-if="item.tags.length > 0">
                <template v-for="(tag, i) in item.tags">
                    <a-tag :color="color[(i+index)%7]">{{tag.tagName}}</a-tag>
                </template>
            </template>
            <span v-else>无</span>
        </a-list-item>
    </a-list>
</div>
</template>

<script>
export default {
    props: {
        cid: {
            type: Number,
            default: -1
        },
        searchStr: {
            type: String,
            default: ''
        },
        searchByTagFlag: {
            type: Boolean,
            default: true
        }
    },
    data() {
        return {
            noteList: [],
            pagination: {
                onChange: (page) => {
                    this.pagination.current = page;
                    this.loadData();
                },
                current: 1,
                total: 0,
                pageSize: 4,
                size: 'small',
                hideOnSinglePage: true
            },
            color: ['pink', 'red', 'orange', 'green', 'cyan', 'blue', 'purple']
        }
    },
    watch: {
        cid: {
            immediate: true,
            handler(val) {
                this.noteList = [];
                this.pagination.current = 1;
                this.fetchByCid(val);
            }
        },
        searchStr: {
            immediate: true,
            handler(val) {
                this.noteList = [];
                this.pagination.current = 1;
                this.fetchBySearchStr(val,this.searchByTagFlag);
            }
        },
        searchByTagFlag: {
            immediate: true,
            handler(val) {
                this.noteList = [];
                this.pagination.current = 1;
                this.fetchBySearchStr(this.searchStr, val);
            }
        }
    },
    methods: {
        // 查询某个目录下的笔记列表
        fetchByCid(cid) {
            if (cid != -1) {
                this.axios.get('/category/countNotesByCategory?cid='+cid)
                .then((resp) => {
                    this.pagination.total = resp.data;
                });
                let url = `/category/findNotesOfCategory?cid=${cid}&currentPage=${this.pagination.current}&pageSize=${this.pagination.pageSize}`;
                this.axios.get(url)
                .then((resp) => {
                    if (resp.data.status == '10000') {
                        this.noteList = resp.data.data;
                    }
                });
            }
        },

        editNote(noteData) {
            this.$store.commit('setUpdateFlag', true);
            this.$store.commit('setNoteData', noteData);
            this.$router.push('/home/editor');
        },

        deleteNote(noteData) {
            let _this = this;
            this.$confirm({
                title: '删除笔记',
                content: '确认删除该笔记吗? 删除后不可恢复',
                okText: '确定',
                okType: 'danger', 
                cancelText: '取消',
                onOk() {
                    // 从服务器中删除
                    _this.axios.get('/note/delete?id='+noteData.note.id)
                    .then((resp) => {
                        if (resp.data.status == '10000') {
                            _this.$message.success('笔记删除成功！');
                           _this.$emit('delete-note', noteData);
                            // 重新加载列表
                            _this.loadData();
                        } else {
                            _this.$message.error('笔记删除失败！');
                        }
                    });
                },
                onCancel() {}
            })
        },

        viewNote(noteData) {
            this.$emit('view-note', noteData);
        },

        fetchBySearchStr(searchStr, searchByTagFlag) {
            if (searchByTagFlag) {
                // 根据标签名查找
                this.axios.get('/note/countNotesLikeTagName?tagName='+searchStr)
                .then((resp) => {
                    this.pagination.total = resp.data;
                })
                this.axios.get(`/note/findNotesLikeTagName?tagName=${searchStr}&currentPage=${this.pagination.current}&pageSize=${this.pagination.pageSize}`)
                .then((resp) => {
                    if (resp.data.status === '10000') {
                        this.noteList = resp.data.data;
                    }
                });
            } else {
                // 根据笔记标题查找
                this.axios.get('/note/countNotesLikeTitle?title='+searchStr)
                .then((resp) => {
                    this.pagination.total = resp.data;
                })
                this.axios.get(`/note/findNotesLikeTitle?title=${searchStr}&currentPage=${this.pagination.current}&pageSize=${this.pagination.pageSize}`)
                .then((resp) => {
                    if (resp.data.status === '10000') {
                        this.noteList = resp.data.data;
                    }
                });
            }
        },

        loadData() {
            if (this.cid !== -1) {
                this.fetchByCid(this.cid);
            } else if (this.searchStr.trim() !== '') {
                this.fetchBySearchStr(this.searchStr);
            }
        }
    }

}
</script>

<style scoped>
.simple-note-lit {
    background: #fff;
    padding: 0 20px;
}
</style>
