-- 注意：该页面对应的前台目录为views/ShoeLockerLog文件夹下
-- 如果你想更改到其他目录，请修改sql中component字段对应的值


INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external) 
VALUES ('2022101210042570460', NULL, 'shoe_locker_log', '/ShoeLockerLog/shoeLockerLogList', 'ShoeLockerLog/ShoeLockerLogList', NULL, NULL, 0, NULL, '1', 1.00, 0, NULL, 1, 1, 0, 0, 0, NULL, '1', 0, 0, 'admin', '2022-10-12 10:04:46', NULL, NULL, 0);

-- 权限控制sql
-- 新增
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2022101210042570461', '2022101210042570460', '添加shoe_locker_log', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_locker_log:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-10-12 10:04:46', NULL, NULL, 0, 0, '1', 0);
-- 编辑
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2022101210042570462', '2022101210042570460', '编辑shoe_locker_log', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_locker_log:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-10-12 10:04:46', NULL, NULL, 0, 0, '1', 0);
-- 删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2022101210042570463', '2022101210042570460', '删除shoe_locker_log', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_locker_log:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-10-12 10:04:46', NULL, NULL, 0, 0, '1', 0);
-- 批量删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2022101210042570464', '2022101210042570460', '批量删除shoe_locker_log', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_locker_log:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-10-12 10:04:46', NULL, NULL, 0, 0, '1', 0);
-- 导出excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2022101210042570465', '2022101210042570460', '导出excel_shoe_locker_log', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_locker_log:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-10-12 10:04:46', NULL, NULL, 0, 0, '1', 0);
-- 导入excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2022101210042570466', '2022101210042570460', '导入excel_shoe_locker_log', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_locker_log:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-10-12 10:04:46', NULL, NULL, 0, 0, '1', 0);