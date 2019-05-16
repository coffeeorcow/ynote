<template>
<div class="search-detail">
<a-row type="flex" justify="space-between">
    <a-col :span="10">
        <SimpleNoteList 
            class="note-list"
            :searchStr="searchStr"
            :searchByTagFlag="searchByTagFlag"
            @view-note="viewNote"
        />
    </a-col>
    <a-col :span="13">
        <Note 
            class="note"
            v-if="showNote"
            v-bind:note-data="noteData" 
            @delete-note="deleteNote"
        />
    </a-col>
</a-row>
</div>
</template>

<script>
import SimpleNoteList from '@/components/SimpleNoteList.vue';
import Note from '@/components/Note.vue';

export default {
    components: {
        SimpleNoteList,
        Note
    },

    props: {
        searchStr: {
            type: String,
            required: true
        },
        searchByTagFlag: {
            type: Boolean,
            required: true
        }
    },

    data() {
        return {
            noteData: {},
            showNote: false
        }
    },

    methods: {
        viewNote(noteData) {
            this.noteData = noteData;
            this.showNote = true;
        },

        deleteNote(noteData) {
            this.showNote = false;
        }
    }
}
</script>

<style scoped>
.search-detail {
    width: 100%;
    height: 100%;
    margin: 10px 0 0 10px;
}
.note-list {

}
.note {
    margin-right: 20px;
}
</style>
