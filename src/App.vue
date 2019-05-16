<template>
<div id="main">
    <router-view></router-view>
</div>
</template>

<script>
export default {
    beforeCreate() {
        // this.$store.commit('clearFlag');
    }
}
</script>


<style scoped>
#main {
    height: 100%;
}
</style>
