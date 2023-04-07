-- 注意：该页面对应的前台目录为views/shoeCouponRecord文件夹下
-- 如果你想更改到其他目录，请修改sql中component字段对应的值


INSERT INTO sys_permission(id, parent_id, name, url, component, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_route, is_leaf, keep_alive, hidden, hide_tab, description, status, del_flag, rule_flag, create_by, create_time, update_by, update_time, internal_or_external) 
VALUES ('2023032702564310590', NULL, 'shoe_coupon_record', '/shoeCouponRecord/shoeCouponRecordList', 'shoeCouponRecord/ShoeCouponRecordList', NULL, NULL, 0, NULL, '1', 1.00, 0, NULL, 1, 1, 0, 0, 0, NULL, '1', 0, 0, 'admin', '2023-03-27 14:56:59', NULL, NULL, 0);

-- 权限控制sql
-- 新增
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023032702564360591', '2023032702564310590', '添加shoe_coupon_record', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_coupon_record:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-27 14:56:59', NULL, NULL, 0, 0, '1', 0);
-- 编辑
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023032702564360592', '2023032702564310590', '编辑shoe_coupon_record', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_coupon_record:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-27 14:56:59', NULL, NULL, 0, 0, '1', 0);
-- 删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023032702564360593', '2023032702564310590', '删除shoe_coupon_record', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_coupon_record:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-27 14:56:59', NULL, NULL, 0, 0, '1', 0);
-- 批量删除
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023032702564360594', '2023032702564310590', '批量删除shoe_coupon_record', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_coupon_record:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-27 14:56:59', NULL, NULL, 0, 0, '1', 0);
-- 导出excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023032702564360595', '2023032702564310590', '导出excel_shoe_coupon_record', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_coupon_record:exportXls', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-27 14:56:59', NULL, NULL, 0, 0, '1', 0);
-- 导入excel
INSERT INTO sys_permission(id, parent_id, name, url, component, is_route, component_name, redirect, menu_type, perms, perms_type, sort_no, always_show, icon, is_leaf, keep_alive, hidden, hide_tab, description, create_by, create_time, update_by, update_time, del_flag, rule_flag, status, internal_or_external)
VALUES ('2023032702564360596', '2023032702564310590', '导入excel_shoe_coupon_record', NULL, NULL, 0, NULL, NULL, 2, 'org.jeecg.modules.demo:shoe_coupon_record:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-03-27 14:56:59', NULL, NULL, 0, 0, '1', 0);