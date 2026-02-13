-- ================================
-- 库存管理系统 Supabase 数据库表
-- ================================

-- 1. 创建库存表（inventory）
CREATE TABLE IF NOT EXISTS inventory (
    id BIGSERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,        -- 品名（如：裤子）
    product_code VARCHAR(100) NOT NULL,        -- 商品编号（如：9K3360450）
    color_code VARCHAR(50) NOT NULL,           -- 色号（如：287）
    full_code VARCHAR(200) GENERATED ALWAYS AS (product_code || '_' || color_code) STORED,  -- 完整货号（商品_色号）
    size VARCHAR(20) NOT NULL,                 -- 尺码（如：S, M, L, XL）
    quantity INTEGER NOT NULL DEFAULT 0,       -- 库存数量
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    -- 确保同一个货号+尺码组合唯一
    UNIQUE(product_code, color_code, size)
);

-- 2. 创建操作日志表（inventory_logs）
CREATE TABLE IF NOT EXISTS inventory_logs (
    id BIGSERIAL PRIMARY KEY,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    operator VARCHAR(100) NOT NULL,            -- 操作人
    product_code VARCHAR(100) NOT NULL,        -- 商品编号
    color_code VARCHAR(50),                    -- 色号
    full_code VARCHAR(200),                    -- 完整货号
    size VARCHAR(20),                          -- 尺码
    old_quantity INTEGER,                      -- 原库存
    new_quantity INTEGER,                      -- 新库存
    change_amount INTEGER,                     -- 变更数量
    action_type VARCHAR(50),                   -- 操作类型（增加/减少/删除）
    action VARCHAR(100)                        -- 操作描述
);

-- 3. 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_inventory_full_code ON inventory(full_code);
CREATE INDEX IF NOT EXISTS idx_inventory_product_code ON inventory(product_code);
CREATE INDEX IF NOT EXISTS idx_inventory_color_code ON inventory(color_code);
CREATE INDEX IF NOT EXISTS idx_inventory_logs_timestamp ON inventory_logs(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_inventory_logs_full_code ON inventory_logs(full_code);

-- 4. 创建自动更新 updated_at 的触发器
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_inventory_updated_at BEFORE UPDATE ON inventory
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 5. 启用行级安全策略（RLS）- 可选，根据需要启用
-- ALTER TABLE inventory ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE inventory_logs ENABLE ROW LEVEL SECURITY;

-- 如果需要允许匿名访问，可以创建以下策略：
-- CREATE POLICY "Enable read access for all users" ON inventory FOR SELECT USING (true);
-- CREATE POLICY "Enable insert access for all users" ON inventory FOR INSERT WITH CHECK (true);
-- CREATE POLICY "Enable update access for all users" ON inventory FOR UPDATE USING (true);
-- CREATE POLICY "Enable delete access for all users" ON inventory FOR DELETE USING (true);

-- CREATE POLICY "Enable read access for all users" ON inventory_logs FOR SELECT USING (true);
-- CREATE POLICY "Enable insert access for all users" ON inventory_logs FOR INSERT WITH CHECK (true);

COMMENT ON TABLE inventory IS '库存表：存储商品库存信息';
COMMENT ON TABLE inventory_logs IS '操作日志表：记录所有库存变更操作';
