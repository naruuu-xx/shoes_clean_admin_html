-- 注意：该页面对应的前台目录为views/ShoeBrand文件夹下
-- 如果你想更改到其他目录，请修改sql中component字段对应的值


INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external) 
VALUES ('2023033005212540400', NULL, 'shoe_brand', '/ShoeBrand/shoeBrandList', 'ShoeBrand/ShoeBrandList', NULL, NULL, 0, NULL, '1', 1.00, 0, NULL, 1, 1, 0, 0, 0, NULL, '1', 0, 0, 'admin', '2023-03-30 17:21:40', NULL, NULL, 0);

-- 权限控制sql
-- 新增
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023033005212540401', '2023033005212540400', '添加shoe_brand', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_brand:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-30 17:21:40', NULL, NULL, 0, 0, '1', 0);
-- 编辑
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023033005212540402', '2023033005212540400', '编辑shoe_brand', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_brand:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-30 17:21:40', NULL, NULL, 0, 0, '1', 0);
-- 删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023033005212540403', '2023033005212540400', '删除shoe_brand', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_brand:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-30 17:21:40', NULL, NULL, 0, 0, '1', 0);
-- 批量删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023033005212540404', '2023033005212540400', '批量删除shoe_brand', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_brand:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-30 17:21:40', NULL, NULL, 0, 0, '1', 0);
-- 导出excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023033005212540405', '2023033005212540400', '导出excel_shoe_brand', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_brand:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-30 17:21:40', NULL, NULL, 0, 0, '1', 0);
-- 导入excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023033005212560406', '2023033005212540400', '导入excel_shoe_brand', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_brand:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-30 17:21:40', NULL, NULL, 0, 0, '1', 0);