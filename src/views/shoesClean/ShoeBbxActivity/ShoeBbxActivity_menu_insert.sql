-- 注意：该页面对应的前台目录为views/shoeBbxActivity文件夹下
-- 如果你想更改到其他目录，请修改sql中component字段对应的值


INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external) 
VALUES ('2023032704158750160', NULL, 'shoe_bbx_activity', '/shoeBbxActivity/shoeBbxActivityList', 'shoeBbxActivity/ShoeBbxActivityList', NULL, NULL, 0, NULL, '1', 1.00, 0, NULL, 1, 1, 0, 0, 0, NULL, '1', 0, 0, 'admin', '2023-03-27 16:15:16', NULL, NULL, 0);

-- 权限控制sql
-- 新增
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023032704158760161', '2023032704158750160', '添加shoe_bbx_activity', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_bbx_activity:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-27 16:15:16', NULL, NULL, 0, 0, '1', 0);
-- 编辑
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023032704158760162', '2023032704158750160', '编辑shoe_bbx_activity', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_bbx_activity:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-27 16:15:16', NULL, NULL, 0, 0, '1', 0);
-- 删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023032704158770163', '2023032704158750160', '删除shoe_bbx_activity', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_bbx_activity:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-27 16:15:16', NULL, NULL, 0, 0, '1', 0);
-- 批量删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023032704158770164', '2023032704158750160', '批量删除shoe_bbx_activity', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_bbx_activity:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-27 16:15:16', NULL, NULL, 0, 0, '1', 0);
-- 导出excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023032704158770165', '2023032704158750160', '导出excel_shoe_bbx_activity', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_bbx_activity:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-27 16:15:16', NULL, NULL, 0, 0, '1', 0);
-- 导入excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023032704158770166', '2023032704158750160', '导入excel_shoe_bbx_activity', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_bbx_activity:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-27 16:15:16', NULL, NULL, 0, 0, '1', 0);