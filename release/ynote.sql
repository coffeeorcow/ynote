/*
 Navicat Premium Data Transfer

 Source Server         : mysql57-root-conn
 Source Server Type    : MySQL
 Source Server Version : 50724
 Source Host           : localhost:3306
 Source Schema         : ynote

 Target Server Type    : MySQL
 Target Server Version : 50724
 File Encoding         : 65001

 Date: 16/05/2019 20:57:57
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cate_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '目录名',
  `uid` bigint(20) NOT NULL COMMENT '用户标识',
  `cid` bigint(20) NOT NULL DEFAULT -1 COMMENT '父目录标识，-1为根目录',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (17, 'Java', 15, -1);
INSERT INTO `category` VALUES (18, 'Python', 15, -1);
INSERT INTO `category` VALUES (19, 'Golang', 15, -1);
INSERT INTO `category` VALUES (20, '各种配置', 15, -1);
INSERT INTO `category` VALUES (21, 'maven', 15, 17);

-- ----------------------------
-- Table structure for image
-- ----------------------------
DROP TABLE IF EXISTS `image`;
CREATE TABLE `image`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `pos` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '图片文件位置',
  `nid` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of image
-- ----------------------------
INSERT INTO `image` VALUES (35, '/image/1558011251141.png', 74);
INSERT INTO `image` VALUES (36, '/image/1558011319254.jpg', 74);

-- ----------------------------
-- Table structure for note
-- ----------------------------
DROP TABLE IF EXISTS `note`;
CREATE TABLE `note`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '笔记标题',
  `content` mediumtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '笔记内容',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '上次修改时间',
  `uid` bigint(20) NOT NULL COMMENT '所属用户标识',
  `cid` bigint(20) NOT NULL COMMENT '所属目录标识',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 75 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of note
-- ----------------------------
INSERT INTO `note` VALUES (71, '运行 ynote 项目', '# Ynote\n\n> 提示：需提前安装 Java 8，Node 10 和 MYSQL 数据库。\n\n### 1.配置数据库\n创建名为 ynote 的数据库\n执行 `ynote.sql` 脚本文件\n\n### 2.运行服务器端\n在 `ynote.jar` 的同级目录执行以下命令:\n```shell\njava -jar ynote.jar\n```\n\n### 3.运行前端项目\n\n进入 ynote 前端项目目录下，执行以下命令：\n```shell\nnpm install -g yarn\nyarn install\nyarn serve\n```\n\n最后，浏览器访问 `http://localhost:8080/` 地址即可。\n', '2019-05-16 16:38:54', '2019-05-16 16:38:55', 15, 20);
INSERT INTO `note` VALUES (72, 'Java 语法学习', '# Java 基础语法\n\n一个 Java 程序可以认为是一系列对象的集合，而这些对象通过调用彼此的方法来协同工作。下面简要介绍下类、对象、方法和实例变量的概念。\n\n- 对象：对象是类的一个实例，有状态和行为。例如，一条狗是一个对象，它的状态有：颜色、名字、品种；行为有：摇尾巴、叫、吃等。\n- 类：类是一个模板，它描述一类对象的行为和状态。\n- 方法：方法就是行为，一个类可以有很多方法。逻辑运算、数据修改以及所有动作都是在方法中完成的。\n- 实例变量：每个对象都有独特的实例变量，对象的状态由这些实例变量的值决定。\n\n', '2019-05-16 16:44:10', '2019-05-16 16:44:11', 15, 17);
INSERT INTO `note` VALUES (73, 'Maven 介绍', '# Apache Maven\n\nApache Maven is a software project management and comprehension tool. Based on the concept of a project object model (POM), Maven can manage a project\'s build, reporting and documentation from a central piece of information.\n\n### Introduction\n\nMaven, a Yiddish word meaning accumulator of knowledge, began as an attempt to simplify the build processes in the Jakarta Turbine project. There were several projects, each with their own Ant build files, that were all slightly different. JARs were checked into CVS. We wanted a standard way to build the projects, a clear definition of what the project consisted of, an easy way to publish project information and a way to share JARs across several projects.\n\n### Maven’s Objectives\n\nMaven’s primary goal is to allow a developer to comprehend the complete state of a development effort in the shortest period of time. In order to attain this goal, there are several areas of concern that Maven attempts to deal with:\n\n- Making the build process easy\n- Providing a uniform build system\n- Providing quality project information\n- Providing guidelines for best practices development\n- Allowing transparent migration to new features\n\n### Making the build process easy\n\nWhile using Maven doesn’t eliminate the need to know about the underlying mechanisms, Maven does provide a lot of shielding from the details.\n', '2019-05-16 17:15:00', '2019-05-16 17:15:26', 15, 21);
INSERT INTO `note` VALUES (74, 'Golang Introduction', '# The Go Programming Language\n\nGo is an open source programming language that makes it easy to build simple, reliable, and efficient software.\n\n![golang.png](1)\n\n## Introduction\n\nGo is expressive, concise, clean, and efficient. Its concurrency mechanisms make it easy to write programs that get the most out of multicore and networked machines, while its novel type system enables flexible and modular program construction. Go compiles quickly to machine code yet has the convenience of garbage collection and the power of run-time reflection. It\'s a fast, statically typed, compiled language that feels like a dynamically typed, interpreted language.\n\n![loginbg.jpg](2)', '2019-05-16 20:54:11', '2019-05-16 20:55:19', 15, 19);

-- ----------------------------
-- Table structure for note_tag
-- ----------------------------
DROP TABLE IF EXISTS `note_tag`;
CREATE TABLE `note_tag`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nid` bigint(20) NOT NULL,
  `tid` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of note_tag
-- ----------------------------
INSERT INTO `note_tag` VALUES (41, 71, 32);
INSERT INTO `note_tag` VALUES (42, 72, 33);
INSERT INTO `note_tag` VALUES (43, 74, 34);

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标签名称',
  `uid` bigint(20) NOT NULL COMMENT '用户标识',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tag
-- ----------------------------
INSERT INTO `tag` VALUES (32, 'ynote', 15);
INSERT INTO `tag` VALUES (33, 'java', 15);
INSERT INTO `tag` VALUES (34, 'golang', 15);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码',
  `avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '/avatar/avatar.png' COMMENT '头像地址',
  `register_time` datetime(0) NULL DEFAULT NULL COMMENT '注册时间',
  `login_time` datetime(0) NULL DEFAULT NULL COMMENT '上次登录时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username_unique`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (15, 'wjy', '123456', '/avatar/avatar.jpg', '2019-05-16 16:25:57', '2019-05-16 20:53:15');

SET FOREIGN_KEY_CHECKS = 1;
