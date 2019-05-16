import Vue from 'vue'
import Router from 'vue-router'
import store from './store';

Vue.use(Router);

const router = new Router({
    mode: 'history',
    base: process.env.BASE_URL,
    routes: [
        {
            path: '/',
            redirect: '/home/main',
            meta: {requireAuth: true}
        },
        {
            path: '/home',
            name: 'home',
            component: () => import('@/views/Home.vue'),
            meta: {requireAuth: true},
            children: [
                {
                    path: 'main',
                    component: () => import('@/components/Main.vue'),
                    meta: {requireAuth: true}
                },
                {
                    path: 'editor',
                    component: () => import('@/components/Editor.vue'),
                    meta: {requireAuth: true}
                },
                {
                    path: 'notebook',
                    component: () => import('@/components/Notebook.vue'),
                    meta: {requireAuth: true}
                },
                {
                    path: 'setting',
                    component: () => import('@/components/Setting.vue'),
                    meta: {requireAuth: true}
                },
                {
                    path: 'help',
                    component: () => import('@/components/Help.vue'),
                    meta: {requireAuth: true}
                },
                {
                    path: 'searchDetail',
                    component: () => import('@/components/SearchDetail.vue'),
                    meta: {requireAuth: true}
                }
            ]
        },
        {
            path: '/about',
            name: 'about',
            component: () => import('@/views/About.vue'),
            meta: {requireAuth: true}
        },
        {
            path: '/toLogin',
            name: 'login',
            component: () => import('@/views/Login.vue')
        },
        {
            path: '/toRegister',
            name: 'register',
            component: () => import('@/views/Register.vue')
        },
        {
            path: '*',
            component: () => import('@/views/404.vue')
        }
    ]
});

router.beforeEach((to, from, next) => {
    if (to.meta.requireAuth) {
        if (store.state.user) {
            next();
        } else {
            next('/toLogin');
        }
    } else {
        next();
    }
});

export default router;
