<template>
<div class="login-wrapper">
    <a-form :form="form" @submit="login" class="login-form">
        <a-form-item>
            <h1 class="login-title">欢迎使用 YNOTE</h1>
        </a-form-item>
        <a-form-item>
            <a-input
                ref="usernameInput"
                v-decorator="['username',{ rules: [{ required: true, message: '请输入用户名！' }] }]"
                placeholder="用户名">
            <a-icon slot="prefix" type="user" style="color: rgba(0,0,0,.25)"></a-icon>
            </a-input>
        </a-form-item>
        <a-form-item>
            <a-input
                ref="passwordInput"
                v-decorator="['password',{ rules: [{ required: true, message: '请输入密码！' }] }]"
                type="password"
                placeholder="密码"
                @keyup.enter="login">
            <a-icon slot="prefix" type="lock" style="color: rgba(0,0,0,.25)"></a-icon>
            </a-input>
        </a-form-item>
        <a-form-item>
            <!-- <a-checkbox 
                v-decorator="['remember', { valuePropName: 'checked', initialValue: true}]"
                class="login-form-remember">
            记住我
            </a-checkbox>
            <router-link to="/about" class="login-from-about">了解更多</router-link> -->
            <a-button type="primary" html-type="submit" class="login-form-button">登录</a-button>
            或 <router-link to="/toRegister">现在注册</router-link>
        </a-form-item>
    </a-form>
</div>
</template>

<script>
export default {
    data() {
        return {
        }
    },

    beforeCreate() {
        this.form = this.$form.createForm(this);
    },

    methods: {
        login(e) {
            e.preventDefault();
            this.form.validateFields((err, values) => {
                if (!err) {
                    // 登录
                    this.axios.post('/login',values)
                    .then((resp) => {
                        if (resp.data.status == 10000) {
                            let user = resp.data.data;
                            if (user != null) {
                                this.$store.commit('clearFlag');
                                this.$store.commit('setUser', user);
                            }
                            this.$router.push('/home/main');
                            this.$message.success('登录成功！');
                        } else {
                            this.$message.error('用户名或密码错误！');
                            this.form.setFieldsValue({
                                password: '',
                            });
                            this.$refs.passwordInput.focus();
                        }
                    })
                    .catch((error) => {
                        this.$message.error('网络错误！');
                    });
                }
            });
        }
    },

}
</script>

<style scoped>
.login-wrapper {
    background-image: url('../assets/login_bg.svg');
    height: 100%;
    position: relative;
}
.login-wrapper .login-form {
    max-width: 260px;
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    margin: auto;
    max-height: 450px;
}
.login-wrapper .login-form-remember {
    /* float: left; */
}
.login-wrapper .login-from-about {
    float: right;
}
.login-wrapper .login-form-button {
    width: 100%;
}
</style>
