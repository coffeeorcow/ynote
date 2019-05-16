<template>
<div class="note-show">
<template v-if="noteData == null || typeof(noteData) == 'undefined' || typeof(noteData.note) == 'undefined'">
</template>
<template v-else>
    <div class="head" style="margin-bottom: 10px;">
        <div style="clear:both;">
            <h1 style="float:left">{{noteData.note.title}}</h1>
            <span class="deleteBtn" @click="deleteNote"><a-icon type="delete" /> 删除 </span>
            <span class="editBtn" @click="editNote"><a-icon type="edit" /> 编辑 </span>
        </div>
        <div style="clear:both;">
            <template v-for="(v, i) in noteData.tags">
                <a-tag :color="color[i%7]">{{v.tagName}}</a-tag>
            </template>
            <span style="float:right;"><span style="font-weight: bold;">存放位置: </span>{{noteData.path}}</span>
            <br>
            <span style="float:right;"><span style="font-weight: bold;">创建于: </span>{{noteData.note.createTime}}</span>
            <br>
        </div>
    </div>
    <mavon-editor 
        class="editor-show"
        v-if="!(noteData.note.content.trim() == '')"
        v-model="noteData.note.content"
        :toolbarsFlag="false"
        :subfield="false"
        defaultOpen="preview"
    />
</template>
</div>
</template>

<script>
export default {
    props: {
        noteData: {
            type: Object,
            required: true
        }
    },
    data() {
        return {
            color: ['pink', 'red', 'orange', 'green', 'cyan', 'blue', 'purple']
        }
    },

    methods: {
        deleteNote() {
            // 删除笔记
            this.axios.get('/note/delete?id='+this.noteData.note.id)
            .then((resp) => {
                if (resp.data.status == '10000') {
                    this.$message.success('笔记删除成功！');
                    this.$emit('delete-note', this.noteData);
                } else {
                    this.$message.error('笔记删除失败！');
                }
            });
        },

        editNote() {
            // 修改笔记
            this.$store.commit('clearFlag');
            this.$store.commit('setUpdateFlag', true);
            this.$store.commit('setNoteData', this.noteData);
            this.$router.push('/home/editor');
        }
    }
}
</script>

<style scoped>
.note-show {
    background: #fff;
    padding: 10px;
}
.editor-show {
    z-index: 10;
    width: 100%;
    clear: both;
}
.deleteBtn {
    float: right; 
    margin-right: 15px;
    margin-bottom: 15px;
    cursor: default;
}
.deleteBtn:hover {
    color: red;
    cursor: default;
}
.editBtn {
    float: right; 
    margin-right: 15px;
    margin-bottom: 15px;
    cursor: default;
}
.editBtn:hover {
    color: orange;
    cursor: default;
}
</style>
