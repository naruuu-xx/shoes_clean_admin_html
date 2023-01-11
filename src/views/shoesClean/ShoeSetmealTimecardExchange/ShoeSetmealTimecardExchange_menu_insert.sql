-- 注意：该页面对应的前台目录为views/shoeSetmealTimecardExchange文件夹下
-- 如果你想更改到其他目录，请修改sql中component字段对应的值


INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external) 
VALUES ('2023011112241260000', NULL, 'shoe_setmeal_timecard_exchange', '/shoeSetmealTimecardExchange/shoeSetmealTimecardExchangeList', 'shoeSetmealTimecardExchange/ShoeSetmealTimecardExchangeList', NULL, NULL, 0, NULL, '1', 1.00, 0, NULL, 1, 1, 0, 0, 0, NULL, '1', 0, 0, 'admin', '2023-01-11 12:24:00', NULL, NULL, 0);

-- 权限控制sql
-- 新增
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023011112241260001', '2023011112241260000', '添加shoe_setmeal_timecard_exchange', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_setmeal_timecard_exchange:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 12:24:00', NULL, NULL, 0, 0, '1', 0);
-- 编辑
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023011112241260002', '2023011112241260000', '编辑shoe_setmeal_timecard_exchange', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_setmeal_timecard_exchange:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 12:24:00', NULL, NULL, 0, 0, '1', 0);
-- 删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023011112241260003', '2023011112241260000', '删除shoe_setmeal_timecard_exchange', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_setmeal_timecard_exchange:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 12:24:00', NULL, NULL, 0, 0, '1', 0);
-- 批量删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023011112241260004', '2023011112241260000', '批量删除shoe_setmeal_timecard_exchange', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_setmeal_timecard_exchange:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 12:24:00', NULL, NULL, 0, 0, '1', 0);
-- 导出excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023011112241260005', '2023011112241260000', '导出excel_shoe_setmeal_timecard_exchange', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_setmeal_timecard_exchange:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 12:24:00', NULL, NULL, 0, 0, '1', 0);
-- 导入excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023011112241260006', '2023011112241260000', '导入excel_shoe_setmeal_timecard_exchange', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_setmeal_timecard_exchange:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 12:24:00', NULL, NULL, 0, 0, '1', 0);