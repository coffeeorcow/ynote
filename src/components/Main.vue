<template>
<div class="main">
<a-row type="flex" justify="center">
<a-col :xs="24" :sm="24" :md="24" :lg="20" :xl="20">
    <div class="infinite-container"
    v-infinite-scroll="handleInfiniteOnLoad"
    :infinite-scroll-disabled="busy"
    infinite-scroll-distance=20
    >
        <h1 v-if="noteList.length == 0" style="text-align:center;padding-top: 100px;">还未添加任何笔记~</h1>
        <a-list v-else
            itemLayout="vertical"
            :loading="loading"
            :dataSource="noteList"
        >
            <a-list-item slot="renderItem" slot-scope="item, index" key="item.title" @click="viewNote(item)">
                
                <span slot="actions" style="margin-right: 8px">分类：{{item.path}}</span>
                <span slot="actions" style="margin-right: 8px">标签：
                    <span v-if="item.tags.length == 0">无</span>
                    <template v-else v-for="(tag, i) in item.tags">
                        <a-tag :color="color[(i+index)%7]">{{tag.tagName}}</a-tag>
                    </template>
                </span>

                <img v-if="item.images.length > 0" slot="extra" width="180" alt="picture" 
                    :src="imagesBaseUrl+item.images[item.images.length-1].pos" />
                <a-list-item-meta>
                    <a slot="title">{{item.note.title}}</a>
                    <a-avatar slot="avatar" icon="file" style="background: pink;"/>
                </a-list-item-meta>
                <div class="list-item-content">
                    <span style="float: right; margin-bottom: 14px;">更新时间：{{item.note.updateTime}}</span>
                    <p style="clear:both;">{{item.note.content}}</p>
                </div>
            </a-list-item>
            <div v-if="loading && !busy" class="loading-container">
                <a-spin />
            </div>
        </a-list>

        <a-drawer
            placement="right"
            @close="closeNoData"
            :visible="noDataVisble">
            <h1 style="color: orange;"><a-icon type="warning" /> &nbsp;提示</h1>
            <a-divider />
            <h2 style="color: purple;">没有更多的笔记信息了~</h2>
            <img style="position: absolute; bottom: 0px; right: 10px;" src="../assets/dog.jpg" width="90%" alt="图片找不到了" />
        </a-drawer>
    </div>
</a-col>
</a-row>
</div>
</template>

<script>
import infiniteScroll from 'vue-infinite-scroll'

export default {
    directives: {
        infiniteScroll 
    },

    data() {
        return {
            loading: false,
            busy: false,
            noteList: [],
            page: {nextPage: 1, pageSize: 5},
            color: ['pink', 'red', 'orange', 'green', 'cyan', 'blue', 'purple'],
            imagesBaseUrl: this.$baseURL,
            noNoteFlag: false,
            noDataVisble: false
        }
    },

    mounted() {
        this.noteList = [];
        let url = `/note/findRecent?uid=${this.$store.state.user.id}&currentPage=${this.page.nextPage}&pageSize=${this.page.pageSize}`;
        this.axios.get(url)
        .then((resp) => {
            if (resp.data != null && resp.data.length > 0 && this.noteList.length == 0) {
                // this.page.nextPage++;
                this.filterNoteContent(resp.data);
                this.noteList = resp.data;
            }
        });
    },

    methods: {
        // 下拉加载数据
        handleInfiniteOnLoad() {
            let noteList = this.noteList;
            this.loading = true;
            if (this.noNoteFlag) {
                this.noDataVisble = true;
                this.busy = true;
                this.loading = false;
            } else if (noteList.length > 30) {
                this.noDataVisble = true;
                this.busy = true;
                this.loading = false;
                return;
            }
            let url = `/note/findRecent?uid=${this.$store.state.user.id}&currentPage=${this.page.nextPage}&pageSize=${this.page.pageSize}`;
            this.axios.get(url)
            .then((resp) => {
                if (resp.data != null && resp.data.length > 0 && noteList.length <= (this.page.nextPage*this.page.pageSize)) {
                    this.filterNoteContent(resp.data);
                    this.noteList = noteList.concat(resp.data);
                    this.page.nextPage++;
                    this.loading = false;
                } else {
                    this.noNoteFlag = true;
                    this.noDataVisble = true;
                    this.busy = true;
                    this.loading = false;
                }
            });
        },

        // 处理笔记内容显示
        filterNoteContent(notes) {
            if (notes != null && notes.length > 0) {
                let html, div, ps, str;
                notes.forEach((n, i) => {
                    html = this.$markdownIt.render(n.note.content);
                    div = document.createElement('div');
                    div.innerHTML = html;
                    ps = div.getElementsByTagName('p');
                    str = '';
                    if (ps.length > 0 && ps.length <= 3) {
                        switch(ps.length) {
                            case 3:
                                str = ps[2].innerText;
                            case 2:
                                str = ps[1].innerText + ' ' + str;
                            case 1:
                                str = ps[0].innerText + ' ' + str;
                                n.note.content = str;
                                break;
                        }
                    } else if(ps.length > 3) {
                        n.note.content = ps[0].innerText + ps[1].innerText + ps[2].innerText;
                    } else {
                        n.note.content = '点击查看更多内容';
                    }
                    if (n.note.content.trim() === '') {
                        n.note.content = '点击查看更多内容';
                    }
                });
            }
        },

        // 查看笔记详情
        viewNote(noteData) {
            this.axios.get('/note/findOne?id='+noteData.note.id)
            .then((resp) => {
                this.$store.commit('clearFlag');
                this.$store.commit('setNoteData', resp.data.data);
                this.$store.commit('setShowNoteFlag', true);
                this.$router.push('/home/notebook');
            });
        },

        closeNoData() {
            // 关闭提示抽屉
            this.noDataVisble = false;
        }
    }
    
}
</script>

<style scoped>
.main {
    margin: 5px;
    height: 95%;
}
.infinite-container {
    border: 1px solid #e8e8e8;
    border-radius: 4px;
    overflow: auto;
    padding: 8px 24px;
    height: 600px;
    background: #fff;
}
.loading-container {
    position: absolute;
    bottom: 40px;
    width: 100%;
    text-align: center;
}
</style>
