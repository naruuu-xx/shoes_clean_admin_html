-- 注意：该页面对应的前台目录为views/shoeSetmealTimecard文件夹下
-- 如果你想更改到其他目录，请修改sql中component字段对应的值


INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external) 
VALUES ('202301111225090530', NULL, 'shoe_setmeal_timecard', '/shoeSetmealTimecard/shoeSetmealTimecardList', 'shoeSetmealTimecard/ShoeSetmealTimecardList', NULL, NULL, 0, NULL, '1', 1.00, 0, NULL, 1, 1, 0, 0, 0, NULL, '1', 0, 0, 'admin', '2023-01-11 12:25:53', NULL, NULL, 0);

-- 权限控制sql
-- 新增
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('202301111225100531', '202301111225090530', '添加shoe_setmeal_timecard', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_setmeal_timecard:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 12:25:53', NULL, NULL, 0, 0, '1', 0);
-- 编辑
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('202301111225100532', '202301111225090530', '编辑shoe_setmeal_timecard', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_setmeal_timecard:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 12:25:53', NULL, NULL, 0, 0, '1', 0);
-- 删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('202301111225100533', '202301111225090530', '删除shoe_setmeal_timecard', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_setmeal_timecard:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 12:25:53', NULL, NULL, 0, 0, '1', 0);
-- 批量删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('202301111225100534', '202301111225090530', '批量删除shoe_setmeal_timecard', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_setmeal_timecard:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 12:25:53', NULL, NULL, 0, 0, '1', 0);
-- 导出excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('202301111225100535', '202301111225090530', '导出excel_shoe_setmeal_timecard', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_setmeal_timecard:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 12:25:53', NULL, NULL, 0, 0, '1', 0);
-- 导入excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('202301111225100536', '202301111225090530', '导入excel_shoe_setmeal_timecard', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_setmeal_timecard:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 12:25:53', NULL, NULL, 0, 0, '1', 0);