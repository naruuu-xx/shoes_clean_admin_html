-- 注意：该页面对应的前台目录为views/shoeTimecard文件夹下
-- 如果你想更改到其他目录，请修改sql中component字段对应的值


INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external) 
VALUES ('202301111141640050', NULL, 'shoe_timecard', '/shoeTimecard/shoeTimecardList', 'shoeTimecard/ShoeTimecardList', NULL, NULL, 0, NULL, '1', 1.00, 0, NULL, 1, 1, 0, 0, 0, NULL, '1', 0, 0, 'admin', '2023-01-11 11:41:05', NULL, NULL, 0);

-- 权限控制sql
-- 新增
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('202301111141640051', '202301111141640050', '添加shoe_timecard', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_timecard:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 11:41:05', NULL, NULL, 0, 0, '1', 0);
-- 编辑
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('202301111141640052', '202301111141640050', '编辑shoe_timecard', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_timecard:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 11:41:05', NULL, NULL, 0, 0, '1', 0);
-- 删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('202301111141640053', '202301111141640050', '删除shoe_timecard', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_timecard:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 11:41:05', NULL, NULL, 0, 0, '1', 0);
-- 批量删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('202301111141640054', '202301111141640050', '批量删除shoe_timecard', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_timecard:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 11:41:05', NULL, NULL, 0, 0, '1', 0);
-- 导出excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('202301111141640055', '202301111141640050', '导出excel_shoe_timecard', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_timecard:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 11:41:05', NULL, NULL, 0, 0, '1', 0);
-- 导入excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('202301111141640056', '202301111141640050', '导入excel_shoe_timecard', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_timecard:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 11:41:05', NULL, NULL, 0, 0, '1', 0);