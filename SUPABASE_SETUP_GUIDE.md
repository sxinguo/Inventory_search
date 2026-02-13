# 库存管理系统 - Supabase 集成设置指南

## 📋 目录
1. [在 Supabase 中创建数据库表](#步骤1-在-supabase-中创建数据库表)
2. [验证 API 密钥](#步骤2-验证-api-密钥)
3. [配置 RLS 安全策略](#步骤3-配置-rls-安全策略)
4. [测试系统](#步骤4-测试系统)
5. [常见问题](#常见问题)

---

## 步骤1: 在 Supabase 中创建数据库表

### 1.1 登录 Supabase
1. 访问 [https://supabase.com](https://supabase.com)
2. 登录你的账号
3. 选择你的项目（URL: https://qucasetifjhdfalpxjpy.supabase.co）

### 1.2 打开 SQL 编辑器
1. 在左侧菜单中，点击 **SQL Editor** 图标（通常是 `</>` 或数据库图标）
2. 点击右上角的 **New Query** 按钮

### 1.3 执行 SQL 脚本
1. 打开文件 `supabase_setup.sql`（在本目录中）
2. 复制整个文件的内容
3. 粘贴到 Supabase 的 SQL 编辑器中
4. 点击右下角的 **RUN** 或 **执行** 按钮
5. 等待执行完成，应该看到 "Success. No rows returned" 的提示

### 1.4 验证表已创建
1. 在左侧菜单中，点击 **Table Editor**
2. 你应该能看到两个新表：
   - `inventory` - 库存表
   - `inventory_logs` - 操作日志表

---

## 步骤2: 验证 API 密钥

你提供的密钥格式是 `sb_publishable_...`，这可能不是正确的 Supabase API Key。

### 2.1 获取正确的 API Key
1. 在 Supabase 项目中，点击左下角的 **⚙️ Settings** 图标
2. 在左侧菜单选择 **API**
3. 找到以下信息：

   **Project URL:**
   ```
   https://qucasetifjhdfalpxjpy.supabase.co
   ```

   **Project API keys 部分有两个 key:**
   - `anon` `public` - 这是你需要的！（通常以 `eyJ` 开头）
   - `service_role` `secret` - **不要使用这个**（这是服务端密钥）

### 2.2 更新配置文件
1. 打开 `supabase-config.js` 文件
2. 将 `anonKey` 的值替换为正确的 `anon public` key（以 `eyJ` 开头的长字符串）

**当前配置:**
```javascript
const SUPABASE_CONFIG = {
    url: 'https://qucasetifjhdfalpxjpy.supabase.co',
    anonKey: 'sb_publishable_qeH-q3osPW2FQeyEuKW_qw_qPBNMGUx'  // ← 需要替换
};
```

**正确格式示例:**
```javascript
const SUPABASE_CONFIG = {
    url: 'https://qucasetifjhdfalpxjpy.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'  // 应该是这样的长字符串
};
```

---

## 步骤3: 配置 RLS 安全策略

Supabase 默认启用了行级安全策略（RLS），需要配置访问权限。

### 3.1 临时禁用 RLS（开发环境）

**如果这是测试/开发环境，可以暂时禁用 RLS：**

1. 在 Supabase 的 SQL 编辑器中执行：

```sql
-- 禁用 RLS（仅用于开发测试）
ALTER TABLE inventory DISABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_logs DISABLE ROW LEVEL SECURITY;
```

### 3.2 启用 RLS 并配置策略（生产环境推荐）

**如果这是正式环境，建议启用 RLS 并配置策略：**

```sql
-- 启用 RLS
ALTER TABLE inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_logs ENABLE ROW LEVEL SECURITY;

-- 允许所有人读写（根据需要调整）
CREATE POLICY "允许所有用户读取库存" ON inventory FOR SELECT USING (true);
CREATE POLICY "允许所有用户插入库存" ON inventory FOR INSERT WITH CHECK (true);
CREATE POLICY "允许所有用户更新库存" ON inventory FOR UPDATE USING (true);
CREATE POLICY "允许所有用户删除库存" ON inventory FOR DELETE USING (true);

CREATE POLICY "允许所有用户读取日志" ON inventory_logs FOR SELECT USING (true);
CREATE POLICY "允许所有用户插入日志" ON inventory_logs FOR INSERT WITH CHECK (true);
```

---

## 步骤4: 测试系统

### 4.1 打开新系统
1. 在浏览器中打开 `index_supabase.html`
2. 应该看到标题为 "库存管理系统 (Supabase)"

### 4.2 测试流程

**测试1: 上传库存数据**
1. 点击 **管理后台** 按钮
2. 选择一个 CSV 或文本文件（使用你的库存数据）
3. 点击 **保存库存** 按钮
4. 应该看到成功提示

**测试2: 验证数据已保存**
1. 在 Supabase 的 **Table Editor** 中查看 `inventory` 表
2. 应该能看到刚才上传的数据

**测试3: 搜索功能**
1. 点击 **查询库存** 按钮
2. 在搜索框输入货号（如：9K3360450）
3. 应该显示该货号的所有尺码库存

**测试4: 更新库存**
1. 在搜索结果中点击 **减库存** 或 **加库存**
2. 输入操作人名称和数量
3. 应该看到库存更新成功

**测试5: 查看日志**
1. 点击 **查看日志** 按钮
2. 应该显示刚才的操作记录

---

## 常见问题

### ❌ 问题1: 打开页面后没有反应
**原因:** API Key 不正确

**解决方法:**
1. 按照 [步骤2](#步骤2-验证-api-密钥) 获取正确的 `anon public` key
2. 更新 `supabase-config.js` 文件
3. 刷新页面

---

### ❌ 问题2: 上传数据后显示 "数据库操作失败"
**原因:** RLS 策略阻止了操作

**解决方法:**
1. 按照 [步骤3](#步骤3-配置-rls-安全策略) 配置 RLS 策略
2. 或者在开发环境中暂时禁用 RLS

---

### ❌ 问题3: 搜索功能无法工作
**原因:** 数据库表结构不正确

**解决方法:**
1. 在 Supabase SQL 编辑器中检查表结构：
```sql
-- 查看 inventory 表结构
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'inventory';
```
2. 如果表结构不对，重新执行 `supabase_setup.sql`

---

### ❌ 问题4: 控制台显示 CORS 错误
**原因:** Supabase 项目配置问题

**解决方法:**
1. 在 Supabase 项目设置中检查 **Authentication** → **URL Configuration**
2. 确保允许来自本地的请求（http://localhost, http://127.0.0.1）

---

## 🎉 完成！

完成以上步骤后，你的库存管理系统就成功连接到 Supabase 了！

现在数据将保存在云端，可以：
- ✅ 跨设备访问
- ✅ 多人协同使用
- ✅ 数据永久保存
- ✅ 自动备份

---

## 📞 需要帮助？

如果遇到问题，请检查：
1. 浏览器控制台（F12）的错误信息
2. Supabase 项目的日志（Settings → Logs）
3. 确保 API Key 和 URL 都正确配置

如有其他问题，随时联系我！
