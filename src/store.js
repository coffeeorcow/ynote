import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
state: {
    user: JSON.parse(window.localStorage.getItem('user')),
    updateNoteFlag: JSON.parse(window.localStorage.getItem('updateNoteFlag')),
    hasCategoryFlag: JSON.parse(window.localStorage.getItem('hasCategoryFlag')),
    showNoteFlag: JSON.parse(window.localStorage.getItem('showNoteFlag')),
    noteData: JSON.parse(window.localStorage.getItem('noteData'))
},
mutations: {
    setUser: (state, data) => {
        state.user = data;
        window.localStorage.setItem('user', JSON.stringify(data));
    },
    clearUser: (state) => {
        state.user = null;
        window.localStorage.removeItem('user');
    },
    setUpdateFlag: (state, flag) => {
        state.updateNoteFlag = flag;
        window.localStorage.setItem('updateNoteFlag', JSON.stringify(flag));
    },
    setHasCategoryFlag: (state, flag) => {
        state.hasCategoryFlag = flag;
        window.localStorage.setItem('hasCategoryFlag', JSON.stringify(flag));
    },
    setShowNoteFlag: (state, flag) => {
        state.showNoteFlag = flag;
        window.localStorage.setItem('showNoteFlag', JSON.stringify(flag));
    },
    setNoteData: (state, noteData) => {
        state.noteData = noteData;
        window.localStorage.setItem('noteData', JSON.stringify(noteData));
    },
    clearFlag: (state) => {
        state.updateNoteFlag = false;
        state.hasCategoryFlag = false;
        state.showNoteFlag = false;
        state.noteData = null;
    }
},
actions: {
}
})
