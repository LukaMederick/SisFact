-- =============================================================================
-- SisFact - Seed Data for PostgreSQL / PostgREST
-- Initial demo branch, user, cash register, categories, and settings
-- =============================================================================

-- 1. Insert Default Branch
INSERT INTO branches (id, name, business_name, business_type, address, phone, ruc, plan_name, is_active)
VALUES (
    'a0000000-0000-0000-0000-000000000001',
    'Prueba - Principal',
    'Prueba',
    'Minimarket · Perú',
    'Av. Principal 123, Lima',
    '+51 987654321',
    '20123456789',
    'Gratis',
    true
) ON CONFLICT DO NOTHING;

-- 2. Insert Default User
INSERT INTO users (id, branch_id, email, full_name, role, password_hash, is_active)
VALUES (
    'b0000000-0000-0000-0000-000000000001',
    'a0000000-0000-0000-0000-000000000001',
    'correo.para.pruebas.2005@gmail.com',
    'Administrador',
    'Administrador',
    '$2a$10$samplehashforadminuserpassword1234567890',
    true
) ON CONFLICT DO NOTHING;

-- 3. Insert Default Cash Register (Caja Principal)
INSERT INTO cash_registers (id, branch_id, name, status, is_active)
VALUES (
    'c0000000-0000-0000-0000-000000000001',
    'a0000000-0000-0000-0000-000000000001',
    'Caja Principal',
    'Cerrada',
    true
) ON CONFLICT DO NOTHING;

-- 4. Insert Default Categories
INSERT INTO categories (id, branch_id, name, description, color_hex, is_active)
VALUES 
    ('d0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', 'Bebidas', 'Gaseosas, aguas, jugos', '#2563EB', true),
    ('d0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001', 'Snacks & Golosinas', 'Galletas, papas, chocolates', '#10B981', true),
    ('d0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000001', 'Lácteos & Embutidos', 'Leche, queso, jamón', '#F59E0B', true),
    ('d0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000001', 'Abarrotes', 'Arroz, azúcar, fideos, aceite', '#8B5CF6', true)
ON CONFLICT DO NOTHING;

-- 5. Insert Sample Customers
INSERT INTO customers (id, branch_id, document_type, document_number, name, phone, email)
VALUES 
    ('e0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', 'Sin Documento', '00000000', 'Cliente Varios', '', ''),
    ('e0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001', 'DNI', '72345678', 'Juan Pérez', '+51 912345678', 'juan.perez@gmail.com')
ON CONFLICT DO NOTHING;
