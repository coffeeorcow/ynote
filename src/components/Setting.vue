<template>
<div class="setting">
<a-card class="setting-card">
    <h1 style="color: purple;">个人中心</h1>
    <a-divider />
    <a-row type="flex" justify="space-between">
        <a-col :span="12">
            <a-card>
                <span class="attribute-name">用户名：{{user.username}} </span>
                <a-button style="float: right;" @click="toUpdateUsername">更名</a-button>
                <a-divider />
                <span class="attribute-name">已有笔记：{{noteNum}} 条</span>
                <a-divider />
                <span class="attribute-name">注册时间：{{user.registerTime}}</span>
                <a-divider />
                <span class="attribute-name">上次登录时间：{{user.loginTime}}</span>
                <a-divider />
            </a-card>
        </a-col>
        <a-col :span="12">
            <a-card>
                <h1 class="attribute-name">当前头像：</h1>
                <div>
                    <a-avatar 
                        shape="square" 
                        :size="100" 
                        :src="avatarURL" 
                        style="float: left; margin-right: 20px;"
                    />
                    <a-upload
                        name="avatar"
                        :action="uploadURL"
                        listType="picture-card"
                        :fileList="fileList"
                        @preview="handlePreview"
                        @change="handleChange"
                        style="float: left;"
                        @click.native="clickNewAvatar"
                    >
                        <div v-if="fileList.length < 1">
                            <a-icon type="plus" />
                            <div class="ant-upload-text">上传头像</div>
                        </div>
                    </a-upload>
                </div>
                <a-button v-if="refreshBtnVisible" @click="refresh" style="display: block; clear: both;">刷新</a-button>
                <a-modal :visible="previewVisible" :footer="null" @cancel="handleCancel">
                    <img alt="预览头像" style="width: 100%" :src="previewImage" />
                </a-modal>
            </a-card>
        </a-col>

        <a-modal v-model="rename.visible" :title="rename.title" @ok="updateUsername" okText="修改" cancelText="取消">
            <a-input v-model="rename.value" ref="renameInput" placeholder="请输入新名字" @keyup.enter="updateUsername">
                <a-icon slot="prefix" type="user" />
                <a-icon v-if="rename.value" slot="suffix" type="close-circle" @click="rename.value = ''" />
            </a-input>
        </a-modal>
    </a-row>
</a-card>
</div>
</template>

<script>
import { setTimeout } from 'timers';
export default {
    data () {
        return {
            previewVisible: false,
            previewImage: '',
            fileList: [],
            uploadURL: `${this.$baseURL}/user/uploadAvatar/${this.$store.state.user.id}`,
            user: this.$store.state.user,
            noteNum: 0,
            avatarURL: this.$baseURL+this.$store.state.user.avatar,
            refreshBtnVisible: false,
            rename: {
                visible: false,
                title: '修改用户名',
                value: ''
            }
        }
    },
    methods: {
        handleCancel () {
            this.previewVisible = false;
        },
        handlePreview (file) {
            this.previewImage = file.url || file.thumbUrl;
            this.previewVisible = true;
        },
        handleChange ({ fileList }) {
            this.fileList = fileList;
        },
        clickNewAvatar() {
            this.refreshBtnVisible = true;
        },
        refresh() {
            this.axios.get('/user/findUserById?id='+this.user.id)
            .then((resp) => {
                if (resp.data.status == '10000') {
                    this.$store.commit('setUser', resp.data.data);
                }
            });
            history.go(0);
        },
        toUpdateUsername() {
            this.rename.visible = true;
            this.$nextTick(()=>this.$refs.renameInput.focus());
        },
        updateUsername() {
            if (this.rename.value.trim() == '') {
                this.$message.error('新名称不能为空');
                return;
            }
            this.axios.post('/user/udpateUser', {id: this.user.id, username: this.rename.value})
            .then((resp) => {
                if (resp.data.status == '10000') {
                    this.$message.success('修改成功！');
                    this.$store.commit('setUser', resp.data.data);
                    this.rename.visible = false;
                    this.$nextTick(() => {
                        history.go(0);
                    });
                } else {
                    this.$message.error(resp.data.msg);
                }
            })
        }
    },
    mounted() {
        // 获取笔记数
        this.axios.get('/note/countNotesOfUser?uid='+this.user.id)
        .then((resp) => {
            this.noteNum=resp.data;
        })
    }
}
</script>

<style scope>
.setting {
    height: 100%;
    width: 100%;
    margin: 10px 0 0 10px;
}
.setting-card {

}
.ant-upload-select-picture-card i {
    font-size: 32px;
    color: #999;
}
.ant-upload-select-picture-card .ant-upload-text {
    margin-top: 8px;
    color: #666;
}
.attribute-name {
    font-weight: bold;
    font-size: 16px;
}
</style>