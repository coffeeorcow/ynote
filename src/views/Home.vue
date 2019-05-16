<template>
<a-layout class="sidebar-panel">
    <a-layout-sider :trigger="null" collapsible v-model="collapsed">
        <a-menu theme="dark" mode="inline" v-model:selectedKeys="selectedKeys" @click="clickMenuItem">
            <a-menu-item key="0" class="menu-title" disabled>
                 <img :src="logo" ></img>
                 <span class="ynote">&nbsp;&nbsp;YNote</span>
            </a-menu-item>
            <a-menu-item key="1">
                <a-icon type="home" />
                <span class="nav-text">首页</span>
            </a-menu-item>
            <a-menu-item key="2">
                <a-icon type="plus" />
                <span class="nav-text">新建笔记</span>
            </a-menu-item>
            <a-menu-item key="3">
                <a-icon type="book" />
                <span class="nav-text">笔记本</span>
            </a-menu-item>
            <a-menu-item key="4">
                <a-icon type="user" />
                <span class="nav-text">个人中心</span>
            </a-menu-item>
            <a-menu-item key="5">
                <a-icon type="question-circle" />
                <span class="nav-text">帮助</span>
            </a-menu-item>
        </a-menu>
    </a-layout-sider>

    <a-layout>
        <a-layout-header class="layout-header" style="background: #fff; padding: 0">
            <a-icon class="trigger" 
                :type="collapsed ? 'menu-unfold' : 'menu-fold'"
                @click="() => collapsed =! collapsed"
            />
            <div class="header-menu">
                <a-switch 
                    class="search-switch" 
                    checkedChildren="根据标签搜索" 
                    unCheckedChildren="根据标题搜索" 
                    defaultChecked
                    @change="switchSearch"
                />
                <a-input-search
                    ref="searchInput"
                    class="serach-input"
                    required="required"
                    placeholder="搜索笔记"
                    style="width: 200px"
                    @click="clickSearchInput"
                    @search="searchNote"
                />

                <a-dropdown>
                    <a href="#" class="avatar-link">
                        <a-avatar :src="this.$baseURL + user.avatar" size="large"/>
                        <span class="username">{{ user.username }}</span>
                    </a>
                    <a-menu slot="overlay" @click="selectAvatar">
                        <a-menu-item key="1">
                            <a-icon type="user" />
                            <span>个人中心</span>
                        </a-menu-item>
                        <a-menu-item key="2">
                            <a-icon type="radar-chart" />
                            <span>变更密码</span>
                        </a-menu-item>
                        <a-divider class="divider"/>
                         <a-menu-item key="3">
                            <a-icon type="retweet" />
                            <span>切换用户</span>
                        </a-menu-item>
                        <a-menu-item key="4">
                            <a-icon type="logout" />
                            <span>注销</span>
                        </a-menu-item>
                    </a-menu>
                </a-dropdown>

                <!-- 修改密码 Modal -->
                <a-modal v-model="passwordSet.visible" title="修改密码" @ok="updatePassword" okText="修改" cancelText="取消">
                    <a-input type="password" class="pwd-input" v-model="passwordSet.oldpwd" ref="oldPasswordInput" placeholder="请输入原密码">
                        <a-icon slot="prefix" type="key" />
                        <a-icon v-if="passwordSet.oldpwd" slot="suffix" type="close-circle" @click="passwordSet.oldpwd = ''" />
                    </a-input>
                    <a-input type="password" class="pwd-input" v-model="passwordSet.newpwd" placeholder="请输入新密码">
                        <a-icon slot="prefix" type="lock" />
                        <a-icon v-if="passwordSet.newpwd" slot="suffix" type="close-circle" @click="passwordSet.newpwd = ''" />
                    </a-input>
                    <a-input type="password" class="pwd-input" v-model="passwordSet.confirmpwd" ref="confirmPasswordInput" placeholder="请确认密码">
                        <a-icon slot="prefix" type="select" />
                        <a-icon v-if="passwordSet.confirmpwd" slot="suffix" type="close-circle" @click="passwordSet.confirmpwd = ''" />
                    </a-input>
                </a-modal>
            </div>
            
        </a-layout-header>
        <a-layout-content>
            <router-view 
                v-if="showRouterView"
                class="home-content" 
                @update-selected-keys="updateSelectedKeys"
                :searchStr="searchStr"
                :searchByTagFlag="searchByTagFlag"
            />
        </a-layout-content>
    </a-layout>
</a-layout>
</template>

<script>
export default {
    data() {
        return {
            user: this.$store.state.user,
            logo: require('../assets/avatar.png'),
            collapsed: false,
            selectedKeys: [],
            showRouterView: true,
            searchByTagFlag: true,
            searchStr: '',
            passwordSet: {
                visible: false,
                oldpwd: '',
                newpwd: '',
                confirmpwd: ''
            }
        }
    },

    methods: {
        refreshComponent(callback) {
            this.showRouterView = false;
            this.$nextTick(() => {
                if(!callback || typeof callback === 'undefined' || callback == undefined) {
                    callback();
                }
                this.showRouterView = true;
            });
        },

        clickMenuItem(item, key, selectedKeys) {
            switch(item.key) {
                case '1':
                    this.refreshComponent(()=>{});
                    this.$router.push('/home/main');
                    break;
                case '2':
                    this.refreshComponent(()=> {
                        this.$store.commit('clearFlag');
                    });
                    this.$router.push('/home/editor');
                    break;
                case '3':
                    this.refreshComponent(()=>{});
                    this.$router.push('/home/notebook');
                    break;
                case '4':
                    this.refreshComponent(()=>{});
                    this.$router.push('/home/setting');
                    break;
                case '5':
                    this.refreshComponent(()=>{});
                    this.$router.push('/home/help');
                    break;
                default:
                    console.log('无选项！');
            }
        },

        searchNote(value) {
            if (value.trim() === '') {
                this.$message.error('搜索内容不能为空！');
                return;
            }
            this.searchStr = value;
            this.$router.push('/home/searchDetail');
        },

        clickSearchInput() {
            // this.$refs.searchInput.focus();
        },

        switchSearch(checked) {
            this.searchByTagFlag = checked;
        },
        
        selectAvatar({ key }) {
            switch(key) {
                case '1':
                    this.$router.push('/home/setting');
                    break;
                case '2':
                    this.passwordSet.visible = true;
                    this.$nextTick(()=>this.$refs.oldPasswordInput.focus());
                    break;
                case '3':
                    this.$router.push('/toLogin');
                    break;
                case '4':
                    this.$store.commit('clearFlag');
                    this.$store.commit('clearUser');
                    this.$router.push('/toLogin');
                    break;
                default:
                    console.log('无选项！');
            }
        },

        updateSelectedKeys(keys) {
            this.selectedKeys = keys;
        },

        updatePassword() {
            if (this.passwordSet.oldpwd.trim() == ''
                || this.passwordSet.newpwd.trim() == ''
                || this.passwordSet.confirmpwd.trim() == '') {
                this.$message.error('密码不能为空！');
                return;
            } else if (this.passwordSet.newpwd !== this.passwordSet.confirmpwd) {
                this.$message.error('两次密码不一致！');
                return;
            }
            this.axios.post('/user/isAuth', {
                username: this.user.username, 
                password: this.passwordSet.oldpwd})
            .then((resp) => {
                if (resp.data.status == '10000') {
                    // 修改密码
                    this.axios.post('/user/udpatePassword', {
                        id: this.user.id, 
                        password: this.passwordSet.newpwd})
                    .then((resp) => {
                        if (resp.data.status == '10000') {
                            this.$message.success('密码修改成功！');
                            this.passwordSet.visible = false;
                        } else {
                            this.$message.error(resp.data.msg);
                        }
                    })
                } else {
                    this.$message.error('密码不正确，请重新输入密码');
                    this.$nextTick(()=>this.$refs.oldPasswordInput.focus());
                }
            });
        }
    },

}
</script>

<style css>
.sidebar-panel {
    height: 100%;
}
.sidebar-panel .logo {
    height: 32px;
    margin: 16px;
}
.menu-title {
    height: 50px;
    margin-bottom: 5px;
}
.ynote {
    color: pink !important;
    font-size: 24px;
    font-weight: bold;
}
.home-content {
    height: 100%;
}
.trigger {
    font-size: 18px;
    line-height: 64px;
    padding: 0 24px;
    cursor: pointer;
    transition: color .3s;
}
.header-menu {
    float: right;
    padding: 0 15px 0 15px;
}
.layout-header {
    position: relative;
    padding: 10px, 10px, 0px, 0px;
    -webkit-box-shadow: 0 1px 4px rgba(0,21,41,.08);
    box-shadow: 0 1px 4px rgba(0,21,41,.08);
}
.search-switch {
    right: 40px;
}
.serach-input {
    right: 30px;
}
.avatar-link {
    text-decoration: none;
    color: pink;
    outline: none;
    margin-right: 20px;
}
.avatar-link:active {
   text-decoration: none;
}
.username {
    margin-left: 10px;
    text-decoration: none;
    color: black;
    outline: none;
    font-weight: bold;
    font-size: 20px;
}
.divider {
    margin: 0 !important;
}
.pwd-input {
    margin-bottom: 20px;
}
</style>
