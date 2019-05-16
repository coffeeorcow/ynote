import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import Antd from 'ant-design-vue';
import axios from 'axios';
import VueAxios from 'vue-axios'
import mavonEditor from 'mavon-editor'

import "ant-design-vue/dist/antd.css";
import 'mavon-editor/dist/css/index.css'

Vue.config.productionTip = false
Vue.use(Antd);
Vue.use(mavonEditor);
Vue.prototype.$markdownIt = mavonEditor.markdownIt;

// axios 配置
const baseURL = 'http://localhost:8888';
Vue.prototype.$baseURL = baseURL;
axios.defaults.baseURL = baseURL;
// axios.defaults.headers['Content-Type']= 'application/x-www-form-urlencoded;charset=UTF-8';
Vue.use(VueAxios, axios);

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
