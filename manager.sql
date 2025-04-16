drop database if exists rescue;
create database rescue;
use rescue;
CREATE TABLE `admin` (
    `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户名',
    `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '密码',
    `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '姓名',
    `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像',
    `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色标识',
    `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '电话',
    `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='管理员';

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'XunhengKuang', '123456', '管理员', 'http://localhost:9090/files/headshot.jpg','ADMIN', '13677889922', 'admin@xm.com');




CREATE TABLE `comment` (
                           `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
                           `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '内容',
                           `user_id` int DEFAULT NULL COMMENT '留言人',
                           `pid` int DEFAULT NULL COMMENT '父级ID',
                           `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '留言时间',
                           `fid` int DEFAULT NULL COMMENT '关联ID',
                           `module` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '模块',
                           `root_id` int DEFAULT NULL COMMENT '根节点ID',
                           PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='留言表';

INSERT INTO `comment` (`id`, `content`, `user_id`, `pid`, `time`, `fid`, `module`, `root_id`) VALUES
    (1, '求助信息很重要，大家快来帮忙！', 1, NULL, '2025-03-10 12:00:00', 1, 'help', NULL),
    (2, '希望大家注意安全！', 2, NULL, '2025-03-10 12:10:00', 2, 'help', NULL),
    (3, '隐患已经送达，请查收', 3, NULL, '2025-03-10 12:15:00', 3, 'donate', NULL),
    (4, '感谢大家的帮助', 4, NULL, '2025-03-10 12:20:00', 4, 'help', NULL),
    (5, '请大家踊跃捐款！', 5, NULL, '2025-03-10 12:25:00', 5, 'donate', NULL),
    (6, '我们一起加油！', 6, NULL, '2025-03-10 12:30:00', 6, 'help', NULL),
    (7, '知识科普很重要，大家都来学习', 7, NULL, '2025-03-10 12:35:00', 7, 'knowledge', NULL),
    (8, '这篇文章写得很好！', 8, NULL, '2025-03-10 12:40:00', 8, 'knowledge', NULL),
    (9, '安保人员辛苦了！', 9, NULL, '2025-03-10 12:45:00', 9, 'vol_apply', NULL),
    (10, '帮助别人也是在帮助自己！', 10, NULL, '2025-03-10 12:50:00', 10, 'help', NULL);


CREATE TABLE `donate` (
                          `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
                          `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '隐患名称',
                          `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '隐患描述',
                          `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '隐患类型',
                          `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片',
                          `user_id` int DEFAULT NULL COMMENT '上报用户ID',
                          `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '上报时间',
                          `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '审核状态',
                          `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '审核理由',
                          PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='安全隐患';

INSERT INTO `donate` (`id`, `name`, `descr`, `type`, `img`, `user_id`, `time`, `status`, `reason`) VALUES
    (1, '消防通道堵塞', '堆放杂物，占用疏散通道，存在火灾隐患', '逃生通道占用', 'http://localhost:9090/files/blocked_exit.png', 1, '2025-03-10 12:30:00', '审核通过', NULL),
    (2, '电线老化', '裸露电线老化，可能引发短路和火灾', '电器设备老旧', 'http://localhost:9090/files/old_wires.png', 2, '2025-03-10 13:00:00', '审核中', NULL),
    (3, '灭火器过期', '存放灭火器检查发现已过期，无法正常使用', '消防设备故障', 'http://localhost:9090/files/expired_extinguisher.png', 3, '2025-03-10 14:00:00', '审核通过', NULL),
    (4, '楼梯扶手松动', '楼梯扶手不稳固，存在跌倒风险', '设施损坏', 'http://localhost:9090/files/loose_handrail.png', 4, '2025-03-10 15:00:00', '审核拒绝', '尚未维修'),
    (5, '照明灯损坏', '紧急疏散指示灯损坏，夜间疏散困难', '照明设备故障', 'http://localhost:9090/files/broken_light.png', 5, '2025-03-10 16:00:00', '审核通过', NULL),
    (6, '消防栓水压不足', '消防检查时发现水压过低，无法有效灭火', '消防设备故障', 'http://localhost:9090/files/low_pressure_hydrant.png', 6, '2025-03-10 17:00:00', '审核通过', NULL),
    (7, '门锁故障', '应急出口门锁损坏，无法正常开启', '逃生通道受阻', 'http://localhost:9090/files/broken_door_lock.png', 7, '2025-03-10 18:00:00', '审核通过', NULL),
    (8, '燃气泄漏', '检测到燃气泄漏，存在爆炸风险', '易燃易爆隐患', 'http://localhost:9090/files/gas_leak.png', 8, '2025-03-10 19:00:00', '审核通过', NULL),
    (9, '墙体裂缝', '建筑墙体出现明显裂缝，可能影响结构安全', '建筑安全隐患', 'http://localhost:9090/files/cracked_wall.png', 9, '2025-03-10 20:00:00', '审核通过', NULL),
    (10, '电梯故障', '电梯运行异常，存在困人风险', '设备故障', 'http://localhost:9090/files/elevator_malfunction.png', 10, '2025-03-10 21:00:00', '审核通过', NULL);


CREATE TABLE `help` (
                        `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
                        `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '疏散事项',
                        `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '疏散内容',
                        `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '疏散类型',
                        `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '现场图片',
                        `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '事故地点',
                        `longitude` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '经度',
                        `latitude` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '纬度',
                        `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '疏散时间',
                        `user_id` int DEFAULT NULL COMMENT '安保员名称',
                        `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系方式',
                        `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '处理状态',
                        `record_id` int DEFAULT NULL COMMENT '疏散演习记录',
                        PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='疏散场所信息';


CREATE TABLE `knowledge` (
                             `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
                             `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标题',
                             `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '内容',
                             `read_count` int DEFAULT '0' COMMENT '阅读量',
                             `date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '发布日期',
                             PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='应急科普信息';




CREATE TABLE `notice` (
                          `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
                          `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标题',
                          `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '内容',
                          `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '创建时间',
                          `user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '创建人',
                          PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='公告信息表';




CREATE TABLE `records` (
                           `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
                           `vol_id` int DEFAULT NULL COMMENT '安保ID',
                           `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '状态',
                           `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '疏散时间',
                           `help_id` int DEFAULT NULL COMMENT '事件ID',
                           `comment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
                           PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='出警信息';





CREATE TABLE `user` (
                        `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
                        `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户名',
                        `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '密码',
                        `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '姓名',
                        `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像',
                        `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色标识',
                        `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '电话',
                        `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
                        PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='普通用户';


INSERT INTO `user` (`id`, `username`, `password`, `name`, `avatar`, `role`, `phone`, `email`) VALUES
    (1, 'user1', 'pass123', '张三', 'http://localhost:9090/files/user1.png', 'USER', '13911112222', 'user1@example.com'),
    (2, 'user2', 'pass456', '李四', 'http://localhost:9090/files/user2.png', 'USER', '13933334444', 'user2@example.com'),
    (3, 'user3', 'pass789', '王五', 'http://localhost:9090/files/user3.png', 'USER', '13955556666', 'user3@example.com'),
    (4, 'user4', 'pass000', '赵六', 'http://localhost:9090/files/user4.png', 'USER', '13977778888', 'user4@example.com'),
    (5, 'user5', 'pass111', '孙七', 'http://localhost:9090/files/user5.png', 'USER', '13999990000', 'user5@example.com'),
    (6, 'user6', 'pass222', '周八', 'http://localhost:9090/files/user6.png', 'USER', '13910101010', 'user6@example.com'),
    (7, 'user7', 'pass333', '郑九', 'http://localhost:9090/files/user7.png', 'USER', '13920202020', 'user7@example.com'),
    (8, 'user8', 'pass444', '钱十', 'http://localhost:9090/files/user8.png', 'USER', '13930303030', 'user8@example.com'),
    (9, 'user9', 'pass555', '吴十一', 'http://localhost:9090/files/user9.png', 'USER', '13940404040', 'user9@example.com'),
    (10, 'user10', 'pass666', '冯十二', 'http://localhost:9090/files/user10.png', 'USER', '13950505050', 'user10@example.com');



CREATE TABLE `vol_apply` (
                             `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
                             `user_id` int DEFAULT NULL COMMENT '用户ID',
                             `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '审核状态',
                             `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '电话',
                             `sex` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '性别',
                             `birth` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生日',
                             `card_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '身份证照片',
                             `info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '个人介绍',
                             `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '创建时间',
                             `card_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '身份证号码',
                             PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='安保申请';

INSERT INTO `vol_apply` (`user_id`, `status`, `phone`, `sex`, `birth`, `card_img`, `info`, `time`, `card_no`)
VALUES
    (1, '审核中', '13800138000', '男', '1995-06-15', 'id_card_1.jpg', '热衷志愿活动', '2025-03-10 14:00:00', '123456789012345678'),
    (2, '通过', '13900239000', '女', '1998-09-21', 'id_card_2.jpg', '有丰富的应急救援经验', '2025-03-11 09:30:00', '987654321098765432');




CREATE TABLE `volunteer` (
                             `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
                             `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户名',
                             `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '密码',
                             `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '名称',
                             `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '个人照片',
                             `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '电话',
                             `birth` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生日',
                             `sex` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '性别',
                             `info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '介绍',
                             `card_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '身份证照片',
                             `card_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '身份证号码',
                             `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色',
                             `free` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否空闲',
                             PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='安保信息';

INSERT INTO volunteer (username, password, name, avatar, phone, birth, sex, info, card_img, card_no, role, free) VALUES
    ('jaychou', 'password123', '周杰伦', 'jay.jpg', '13800000001', '1979-01-18', '男', '音乐才子，热心公益', 'card1.jpg', '110101197901180011', 'VOLUNTEER', '是'),
    ('liyifeng', 'password456', '李易峰', 'liyifeng.jpg', '13900000002', '1987-05-04', '男', '影视歌三栖艺人，积极参与志愿活动', 'card2.jpg', '110101198705041234', 'VOLUNTEER', '否'),
    ('yangmi', 'password789', '杨幂', 'yangmi.jpg', '13600000003', '1986-09-12', '女', '知名女演员，热衷公益事业', 'card3.jpg', '110101198609123456', 'VOLUNTEER', '是'),
    ('denglun', 'password321', '邓伦', 'denglun.jpg', '13700000004', '1992-10-21', '男', '影视演员，致力于公益慈善', 'card4.jpg', '110101199210216789', 'VOLUNTEER', '否'),
    ('angelababy', 'password654', '杨颖', 'angelababy.jpg', '13800000005', '1989-02-28', '女', '模特、演员、公益活动积极参与者', 'card5.jpg', '110101198902289999', 'VOLUNTEER', '是'),
    ('wangyibo', 'password987', '王一博', 'wangyibo.jpg', '13900000006', '1997-08-05', '男', '歌手、舞者、演员，公益大使', 'card6.jpg', '110101199708058888', 'VOLUNTEER', '是'),
    ('zhouxun', 'password111', '周迅', 'zhouxun.jpg', '13600000007', '1974-10-18', '女', '国际影星，环保公益代言人', 'card7.jpg', '110101197410187777', 'VOLUNTEER', '否'),
    ('wangjunkai', 'password222', '王俊凯', 'wangjunkai.jpg', '13700000008', '1999-09-21', '男', 'TFBOYS队长，热心公益', 'card8.jpg', '110101199909216666', 'VOLUNTEER', '是');


-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (1, '今天系统正式上线，开始内测', '今天系统正式上线，开始内测', '2023-09-05', 'admin');
INSERT INTO `notice` VALUES (2, '所有功能都已完成，可以正常使用', '所有功能都已完成，可以正常使用', '2023-09-05', 'admin');
INSERT INTO `notice` VALUES (3, '今天天气很不错，可以出去一起玩了', '今天天气很不错，可以出去一起玩了', '2023-09-05', 'admin');


-- 插入疏散场所信息
INSERT INTO `help` (`name`, `content`, `type`, `img`, `location`, `longitude`, `latitude`, `time`, `user_id`, `phone`, `status`, `record_id`)
VALUES
    ('车辆故障疏散', '高速公路上车辆故障，无法启动', '图书馆', 'img1.jpg', '京沪高速某路段', '116.4074', '39.9042', '2025-03-10 14:30:00', 1, '13800138000', '待处理', NULL),
    ('地铁站', '居民楼起火，火势较大', '地铁站', 'img2.jpg', '北京市朝阳区某小区', '116.5123', '39.9234', '2025-03-10 15:00:00', 2, '13900139000', '处理中', 1),
    ('火灾疏散', '湖边发现火灾者', '商场', 'img3.jpg', '某公园湖区', '116.4235', '39.9156', '2025-03-10 16:10:00', 3, '13700137000', '已完成', 2);

-- 插入应急科普信息
INSERT INTO `knowledge` (`title`, `content`, `read_count`, `date`)
VALUES
    ('火灾逃生指南', '火灾发生时，如何迅速安全逃生...', 120, '2025-03-09'),
    ('心肺复苏急救方法', '在心脏骤停时，如何进行心肺复苏（CPR）...', 85, '2025-03-08'),
    ('洪水避险指南', '洪水来临时应采取哪些措施...', 60, '2025-03-07');

-- 插入公告信息
INSERT INTO `notice` (`title`, `content`, `time`, `user`)
VALUES
    ('关于近期疏散演练的通知', '本周五将在市区举行疏散演练，请大家做好准备。', '2025-03-09 10:00:00', '管理员'),
    ('疏散引导招募', '现急需安保人员加入疏散队伍，有意者请报名。', '2025-03-08 12:00:00', '管理员');

-- 插入出警信息
INSERT INTO `records` (`vol_id`, `status`, `time`, `help_id`, `comment`)
VALUES
    (1, '已出警', '2025-03-10 14:45:00', 1, '疏散演习开始，消防员已就位'),
    (2, '已完成', '2025-03-10 15:30:00', 2, '疏散演习顺利完成，所有人员安全撤离'),
    (3, '进行中', '2025-03-10 16:20:00', 3, '演习进行中，人员有序撤离至安全区域');
