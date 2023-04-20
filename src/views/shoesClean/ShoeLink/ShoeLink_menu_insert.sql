-- 注意：该页面对应的前台目录为views/shoeLink文件夹下
-- 如果你想更改到其他目录，请修改sql中component字段对应的值


INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external) 
VALUES ('2023042011402160250', NULL, 'shoe_link', '/shoeLink/shoeLinkList', 'shoeLink/ShoeLinkList', NULL, NULL, 0, NULL, '1', 1.00, 0, NULL, 1, 1, 0, 0, 0, NULL, '1', 0, 0, 'admin', '2023-04-20 11:40:25', NULL, NULL, 0);

-- 权限控制sql
-- 新增
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023042011402160251', '2023042011402160250', '添加shoe_link', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_link:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-04-20 11:40:25', NULL, NULL, 0, 0, '1', 0);
-- 编辑
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023042011402160252', '2023042011402160250', '编辑shoe_link', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_link:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-04-20 11:40:25', NULL, NULL, 0, 0, '1', 0);
-- 删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023042011402160253', '2023042011402160250', '删除shoe_link', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_link:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-04-20 11:40:25', NULL, NULL, 0, 0, '1', 0);
-- 批量删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023042011402160254', '2023042011402160250', '批量删除shoe_link', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_link:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-04-20 11:40:25', NULL, NULL, 0, 0, '1', 0);
-- 导出excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023042011402160255', '2023042011402160250', '导出excel_shoe_link', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_link:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-04-20 11:40:25', NULL, NULL, 0, 0, '1', 0);
-- 导入excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023042011402160256', '2023042011402160250', '导入excel_shoe_link', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_link:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-04-20 11:40:25', NULL, NULL, 0, 0, '1', 0);