<template>
<div class="register-wrapper">
    <a-form :form="form" @submit="register" class="register-form">
        <a-form-item>
            <div class="register-title">
                <h1 class="register-title">注册成为新用户</h1>
            </div>
        </a-form-item>
        <a-form-item>
            <a-input
                v-decorator="['username',{ rules: [{ required: true, message: '请输入用户名！' }] }]"
                placeholder="请输入用户名">
            <a-icon slot="prefix" type="user" style="color: rgba(0,0,0,.25)"></a-icon>
            </a-input>
        </a-form-item>
        <a-form-item>
            <a-input
                v-decorator="['password',
                { rules: [{ required: true, message: '请输入密码！' }, { validator: validateToNextPassword }] }]"
                type="password"
                placeholder="请输入密码">
            <a-icon slot="prefix" type="lock" style="color: rgba(0,0,0,.25)"></a-icon>
            </a-input>
        </a-form-item>
        <a-form-item>
            <a-input
                v-decorator="['confirm',
                { rules: [{ required: true, message: '请输入密码！' }, { validator: compareToFirstPassword }] }]"
                type="password"
                placeholder="请确认密码"
                @keyup.enter="register">
            <a-icon slot="prefix" type="lock" style="color: rgba(0,0,0,.25)"></a-icon>
            </a-input>
        </a-form-item>
        <a-form-item>
            <a-button type="primary" html-type="submit" class="register-button">注册</a-button>
            <a-button class="cancel-button">取消</a-button>
            <br>
            已有账号，现在 <router-link to="/toLogin">登录</router-link>
        </a-form-item>
    </a-form>
</div>
</template>

<script>
export default {
    data() {
        return {
             confirmDirty: false,
        }
    },

    beforeCreate() {
        this.form = this.$form.createForm(this);
    },

    methods: {
        register(e) {
            e.preventDefault();
            this.form.validateFields((err, values) => {
                if (!err) {
                    // 注册
                    this.axios.post('/register', values)
                    .then((resp) => {
                        if (resp.data.status === '10000') {
                            let user = resp.data.data;
                            this.$store.commit('clearFlag');
                            this.$store.commit('setUser', user);
                            this.$router.push('/home/main');
                            this.$nextTick(()=> {
                                this.$message.success('恭喜您成为新用户！');
                            })
                        } else {
                            this.$message.error(resp.data.msg);
                        }
                    })
                    .catch((error) => {
                        this.$message.error('网络错误！');
                    });
                }
            });
        },

        compareToFirstPassword(rule, value, callback) {
            const form = this.form;
            if (value && value != form.getFieldValue('password')) {
                callback('两次密码不相同');
            } else {
                callback();
            }
        },

        validateToNextPassword(rule, value, callback) {
            const form = this.form;
            if (value && this.confirmDirty) {
                form.validateFields(['confirm'], { force: true });
            }
            callback();
        }
    }
}
</script>

<style scoped>
.register-wrapper {
    background-image: url('../assets/login_bg.svg');
    height: 100%;
    position: relative;
}
.register-form-title {
    
}
.register-wrapper .register-form {
    max-width: 260px;
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    margin: auto;
    max-height:450px;
}
.register-wrapper .register-button {
    float: left;
}
.register-wrapper .cancel-button {
    float: right;
}
</style>