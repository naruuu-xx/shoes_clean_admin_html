-- 注意：该页面对应的前台目录为views/ShoeFactoryWasher文件夹下
-- 如果你想更改到其他目录，请修改sql中component字段对应的值


INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external) 
VALUES ('2023033005213920280', NULL, 'shoe_factory_washer', '/ShoeFactoryWasher/shoeFactoryWasherList', 'ShoeFactoryWasher/ShoeFactoryWasherList', NULL, NULL, 0, NULL, '1', 1.00, 0, NULL, 1, 1, 0, 0, 0, NULL, '1', 0, 0, 'admin', '2023-03-30 17:21:28', NULL, NULL, 0);

-- 权限控制sql
-- 新增
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023033005213930281', '2023033005213920280', '添加shoe_factory_washer', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_factory_washer:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-30 17:21:28', NULL, NULL, 0, 0, '1', 0);
-- 编辑
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023033005213930282', '2023033005213920280', '编辑shoe_factory_washer', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_factory_washer:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-30 17:21:28', NULL, NULL, 0, 0, '1', 0);
-- 删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023033005213930283', '2023033005213920280', '删除shoe_factory_washer', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_factory_washer:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-30 17:21:28', NULL, NULL, 0, 0, '1', 0);
-- 批量删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023033005213930284', '2023033005213920280', '批量删除shoe_factory_washer', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_factory_washer:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-30 17:21:28', NULL, NULL, 0, 0, '1', 0);
-- 导出excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023033005213930285', '2023033005213920280', '导出excel_shoe_factory_washer', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_factory_washer:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-30 17:21:28', NULL, NULL, 0, 0, '1', 0);
-- 导入excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023033005213930286', '2023033005213920280', '导入excel_shoe_factory_washer', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_factory_washer:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-30 17:21:28', NULL, NULL, 0, 0, '1', 0);