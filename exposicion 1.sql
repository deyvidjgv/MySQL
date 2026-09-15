-- =====================================================================
-- SQL PARA PRINCIPIANTES - ELECTROHOGAR S.A.
-- Archivo unico con la estructura de base de datos y los 7 retos
-- de la presentacion (Tipos de datos, Modificadores, DDL, DML, DQL,
-- Operadores, Agrupacion y agregacion)
-- =====================================================================

CREATE DATABASE IF NOT EXISTS electrohogar;
USE electrohogar;

-- =====================================================================
-- 0. TABLAS BASE (necesarias para que las llaves foraneas funcionen)
-- =====================================================================

-- Tabla base: cada producto pertenece a una categoria
CREATE TABLE categorias (
  id_categoria   INT PRIMARY KEY AUTO_INCREMENT,
  nombre         VARCHAR(60) NOT NULL,
  descripcion    VARCHAR(200)
);

-- Tabla base: cada venta necesita productos existentes
CREATE TABLE productos (
  id_producto    INT PRIMARY KEY AUTO_INCREMENT,
  nombre         VARCHAR(100) NOT NULL UNIQUE,
  precio         DECIMAL(10,2) NOT NULL,
  stock          INT NOT NULL CHECK (stock >= 0),
  id_categoria   INT,
  fecha_registro DATE DEFAULT (CURRENT_DATE),
  FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- Tabla base: cada empleado pertenece a un departamento (Reto 3 - DDL)
CREATE TABLE departamentos (
  id_departamento INT PRIMARY KEY AUTO_INCREMENT,
  nombre          VARCHAR(80) NOT NULL
);


-- =====================================================================
-- RETO 1 - TIPOS DE DATOS
-- Situacion: RR.HH. y Marketing necesitan la tabla clientes para el
-- programa de fidelizacion, con el tipo de dato adecuado en cada columna
-- =====================================================================

-- id_cliente: numero entero, identifica cada cliente
-- nombre y ciudad: texto de longitud variable
-- email: se deja mas margen porque algunos correos son largos
-- fecha_registro: solo interesa el dia, no la hora -> DATE
-- acepta_promociones: respuesta si/no -> BOOLEAN
CREATE TABLE clientes (
  id_cliente          INT,
  nombre              VARCHAR(100),
  email               VARCHAR(150),
  ciudad              VARCHAR(60),
  fecha_registro      DATE,
  acepta_promociones  BOOLEAN
);


-- =====================================================================
-- RETO 2 - MODIFICADORES Y RESTRICCIONES
-- Situacion: RR.HH. pide que la tabla empleados garantice datos
-- correctos: id autogenerado, nombre obligatorio, correo unico,
-- salario no negativo, y que el departamento exista
-- =====================================================================

-- PRIMARY KEY + AUTO_INCREMENT genera el id automaticamente
-- NOT NULL obliga a que el nombre siempre tenga valor
-- UNIQUE evita correos repetidos
-- CHECK bloquea salarios negativos
-- FOREIGN KEY exige que el departamento ya exista
CREATE TABLE empleados (
  id_empleado         INT PRIMARY KEY AUTO_INCREMENT,
  nombre              VARCHAR(100) NOT NULL,
  email               VARCHAR(150) UNIQUE,
  salario             DECIMAL(10,2) CHECK (salario >= 0),
  id_departamento     INT,
  fecha_contratacion  DATE DEFAULT (CURRENT_DATE),
  FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
);


-- =====================================================================
-- Tablas de ventas (necesarias para los retos de DQL, Operadores
-- y Agrupacion mas adelante; no son un reto en si mismas)
-- =====================================================================

CREATE TABLE ventas (
  id_venta     INT PRIMARY KEY AUTO_INCREMENT,
  id_cliente   INT,
  id_empleado  INT,
  fecha        DATE,
  total        DECIMAL(12,2),
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
  FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

CREATE TABLE detalle_ventas (
  id_detalle      INT PRIMARY KEY AUTO_INCREMENT,
  id_venta        INT,
  id_producto     INT,
  cantidad        INT,
  precio_unitario DECIMAL(10,2),
  FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);


-- =====================================================================
-- RETO 3 - DDL (Definicion de datos)
-- Situacion: se creo por error la tabla productos_prueba, y hay que
-- registrar el telefono de cada cliente
-- =====================================================================

-- Tabla de prueba que se va a eliminar en este mismo reto
CREATE TABLE productos_prueba (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100)
);

-- 1) Eliminar por completo la tabla que ya no se necesita
DROP TABLE productos_prueba;

-- 2) Agregar la columna telefono a clientes, sin perder los datos existentes
ALTER TABLE clientes
  ADD COLUMN telefono VARCHAR(20);


-- =====================================================================
-- Datos de ejemplo (para que los retos de DML, DQL, Operadores y
-- Agrupacion tengan filas reales sobre las cuales trabajar)
-- =====================================================================

INSERT INTO categorias (nombre, descripcion) VALUES
('Electrodomésticos', 'Línea blanca y equipos de cocina'),
('Tecnología', 'Computadores, celulares y accesorios'),
('Audio y Video', 'Televisores, parlantes, equipos de sonido');

INSERT INTO productos (id_producto, nombre, precio, stock, id_categoria, fecha_registro) VALUES
(118, 'Ventilador de Techo', 45.90, 6, 1, '2025-06-01'),
(245, 'Refrigerador Inverter 400L', 1899.90, 15, 1, '2025-11-02'),
(310, 'Smart TV 55" 4K', 45.90, 8, 3, '2025-09-20'),
(400, 'Smartphone Galaxy Smart X', 899.00, 25, 2, '2026-01-05'),
(401, 'Laptop UltraBook 14"', 2499.00, 5, 2, '2025-12-01'),
(402, 'Microondas Smart Grill', 349.90, 2, 1, '2026-01-10'),
(403, 'Parlante Bluetooth Smart Bass', 129.90, 40, 3, '2025-08-18');

INSERT INTO departamentos (nombre) VALUES
('Ventas'), ('Compras'), ('Recursos Humanos'), ('Contabilidad'), ('Sistemas');

INSERT INTO empleados (nombre, email, salario, id_departamento, fecha_contratacion) VALUES
('Laura Gómez', 'laura.gomez@electrohogar.com', 1800000, 1, '2023-03-01'),
('Carlos Pérez', 'carlos.perez@electrohogar.com', 2100000, 1, '2022-06-15'),
('Marta Ruiz', 'marta.ruiz@electrohogar.com', 2600000, 2, '2021-01-10');

INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro, acepta_promociones, telefono) VALUES
(1, 'Julián Vargas', 'julian.v@mail.com', 'Bogotá', '2026-01-20', 1, '3001112222'),
(2, 'Sofía Ramírez', 'sofia.r@mail.com', 'Bogotá', '2026-01-25', 1, '3002223333'),
(3, 'Pedro León', 'pedro.l@mail.com', 'Cúcuta', '2025-12-05', 0, '3003334444'),
(4, 'Camila Ortiz', 'camila.o@mail.com', 'Bogotá', '2026-01-28', 1, '3004445555'),
(5, 'Diego Salas', 'diego.s@mail.com', 'Medellín', '2025-11-11', 0, NULL),
(6, 'Valentina Cruz', 'valentina.c@mail.com', 'Bogotá', '2026-01-22', 1, '3005556666'),
(7, 'Andrés Mora', 'andres.m@mail.com', 'Bogotá', '2026-01-30', 1, '3006667777');

INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES
(1, 1, '2026-01-05', 620000),
(2, 2, '2026-01-15', 899000),
(3, 1, '2025-12-20', 349900),
(4, 2, '2026-01-10', 1899900),
(5, 1, '2026-01-28', 2499000),
(6, 2, '2026-01-12', 129900);


-- =====================================================================
-- RETO 4 - DML (Manipulacion de datos)
-- Situacion: el producto 310 deberia costar 549.00 y no 45.90.
-- Ademas hay que dar de baja el producto descontinuado 118
-- =====================================================================

-- Todo UPDATE y DELETE debe llevar WHERE, filtrando por id_producto
UPDATE productos
SET precio = 549.00
WHERE id_producto = 310;

DELETE FROM productos
WHERE id_producto = 118;


-- =====================================================================
-- RETO 5 - DQL (Consulta de datos)
-- Situacion: el gerente de Bogota quiere los 5 clientes mas recientes
-- registrados en esa ciudad, mostrando solo nombre y fecha de registro
-- =====================================================================

-- ORDER BY ... DESC muestra primero los mas recientes
-- LIMIT 5 deja solo los primeros 5 resultados
SELECT nombre, fecha_registro
FROM clientes
WHERE ciudad = 'Bogotá'
ORDER BY fecha_registro DESC
LIMIT 5;


-- =====================================================================
-- RETO 6 - OPERADORES
-- Situacion: Marketing quiere productos de categoria Electrodomesticos
-- o Tecnologia cuyo nombre contenga la palabra 'Smart'
-- =====================================================================

-- IN reemplaza varios OR seguidos sobre la misma columna
-- LIKE '%Smart%' encuentra la palabra en cualquier parte del nombre
SELECT p.nombre, p.precio, c.nombre AS categoria
FROM productos p
JOIN categorias c ON c.id_categoria = p.id_categoria
WHERE c.nombre IN ('Electrodomésticos', 'Tecnología')
  AND p.nombre LIKE '%Smart%';


-- =====================================================================
-- RETO 7 - AGRUPACION Y AGREGACION
-- Situacion: Compras quiere las categorias cuyo precio promedio
-- de producto supera los 300000, para revisar la estrategia de precios
-- =====================================================================

-- GROUP BY agrupa los productos por categoria
-- HAVING filtra los grupos ya resumidos (no filas individuales)
SELECT
  id_categoria,
  AVG(precio) AS precio_promedio
FROM productos
GROUP BY id_categoria
HAVING AVG(precio) > 300000;
