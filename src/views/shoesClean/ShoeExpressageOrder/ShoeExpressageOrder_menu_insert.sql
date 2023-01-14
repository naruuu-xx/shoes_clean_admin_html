-- 注意：该页面对应的前台目录为views/shoeExpressageOrder文件夹下
-- 如果你想更改到其他目录，请修改sql中component字段对应的值


INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external) 
VALUES ('2023011210245150030', NULL, 'shoe_expressage_order', '/shoeExpressageOrder/shoeExpressageOrderList', 'shoeExpressageOrder/ShoeExpressageOrderList', NULL, NULL, 0, NULL, '1', 1.00, 0, NULL, 1, 1, 0, 0, 0, NULL, '1', 0, 0, 'admin', '2023-01-12 10:24:03', NULL, NULL, 0);

-- 权限控制sql
-- 新增
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023011210245160031', '2023011210245150030', '添加shoe_expressage_order', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_expressage_order:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-12 10:24:03', NULL, NULL, 0, 0, '1', 0);
-- 编辑
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023011210245160032', '2023011210245150030', '编辑shoe_expressage_order', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_expressage_order:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-12 10:24:03', NULL, NULL, 0, 0, '1', 0);
-- 删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023011210245160033', '2023011210245150030', '删除shoe_expressage_order', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_expressage_order:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-12 10:24:03', NULL, NULL, 0, 0, '1', 0);
-- 批量删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023011210245160034', '2023011210245150030', '批量删除shoe_expressage_order', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_expressage_order:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-12 10:24:03', NULL, NULL, 0, 0, '1', 0);
-- 导出excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023011210245160035', '2023011210245150030', '导出excel_shoe_expressage_order', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_expressage_order:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-12 10:24:03', NULL, NULL, 0, 0, '1', 0);
-- 导入excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023011210245160036', '2023011210245150030', '导入excel_shoe_expressage_order', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_expressage_order:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-12 10:24:03', NULL, NULL, 0, 0, '1', 0);