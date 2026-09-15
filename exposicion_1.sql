

CREATE DATABASE IF NOT EXISTS techstore;
USE techstore;

-- id_producto es la clave primaria: identifica de forma unica cada fila
CREATE TABLE productos (
  id_producto  INT PRIMARY KEY AUTO_INCREMENT,
  nombre       VARCHAR(100) NOT NULL,
  categoria    VARCHAR(50) NOT NULL,
  precio       DECIMAL(10,2) NOT NULL,
  stock        INT NOT NULL DEFAULT 0
);

-- id_cliente es la clave primaria de clientes
CREATE TABLE clientes (
  id_cliente  INT PRIMARY KEY AUTO_INCREMENT,
  nombre      VARCHAR(100) NOT NULL,
  email       VARCHAR(150),
  ciudad      VARCHAR(60),
  telefono    VARCHAR(20)
);

-- ventas necesita saber a quien (id_cliente) y que se vendio (id_producto)
-- por eso lleva una FOREIGN KEY hacia cada una de esas tablas
CREATE TABLE ventas (
  id_venta     INT PRIMARY KEY AUTO_INCREMENT,
  id_cliente   INT NOT NULL,
  id_producto  INT NOT NULL,
  cantidad     INT NOT NULL,
  fecha_venta  DATE NOT NULL,
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);


-- =====================================================================
-- EJ. 02 - Modificar una estructura
-- Consigna: registrar telefono en clientes y ampliar el tamano
-- permitido para nombres de producto.
-- =====================================================================

-- Agregar una columna nueva no borra los datos existentes
-- (telefono ya se incluyo arriba en el EJ.01; se deja este ALTER
-- por si la tabla se hubiera creado sin esa columna)
ALTER TABLE clientes
  ADD COLUMN IF NOT EXISTS telefono VARCHAR(20);

-- Cambiar la definicion de una columna existente: se usa MODIFY,
-- no se recrea la tabla
ALTER TABLE productos
  MODIFY COLUMN nombre VARCHAR(150) NOT NULL;


-- =====================================================================
-- EJ. 03 - Cargar productos y clientes
-- Consigna: insertar al menos 8 productos y 6 clientes, repitiendo
-- categorias, ciudades y rangos de precio.
-- =====================================================================

-- id_producto es AUTO_INCREMENT: no se indica, se genera solo
INSERT INTO productos (nombre, categoria, precio, stock) VALUES
('Mouse Inalámbrico X200', 'Perifericos', 25.90, 50),
('Teclado Mecánico RGB', 'Perifericos', 89.90, 30),
('Monitor 24" Full HD', 'Monitores', 159.00, 15),
('Monitor 27" 4K', 'Monitores', 349.00, 8),
('Laptop UltraBook 14"', 'Computadores', 2499.00, 5),
('PC Escritorio Gamer', 'Computadores', 1899.00, 4),
('Disco SSD 1TB', 'Almacenamiento', 89.00, 40),
('Memoria RAM 16GB', 'Componentes', 65.00, 60),
('Parlante Bluetooth', 'Audio', 45.90, 25),
('Audífonos Inalámbricos', 'Audio', 79.90, 20);

-- id_cliente es AUTO_INCREMENT: se repite la ciudad Bogota a proposito
INSERT INTO clientes (nombre, email, ciudad, telefono) VALUES
('Julián Vargas', 'julian.v@mail.com', 'Bogota', '3001112222'),
('Sofía Ramírez', 'sofia.r@mail.com', 'Bogota', '3002223333'),
('Pedro León', 'pedro.l@mail.com', 'Cucuta', '3003334444'),
('Camila Ortiz', 'camila.o@mail.com', 'Medellin', '3004445555'),
('Diego Salas', 'diego.s@mail.com', 'Cali', '3005556666'),
('Valentina Cruz', 'valentina.c@mail.com', 'Bucaramanga', '3006667777');


-- =====================================================================
-- EJ. 04 - Registrar ventas con sentido
-- Consigna: insertar al menos 12 ventas usando productos y clientes
-- ya existentes; algunos clientes/productos deben repetirse.
-- =====================================================================

-- Se reutilizan ids del 1 al 6 (clientes) y del 1 al 10 (productos),
-- que ya existen por los INSERT del EJ.03
INSERT INTO ventas (id_cliente, id_producto, cantidad, fecha_venta) VALUES
(1, 1, 2, '2026-01-05'),
(1, 3, 1, '2026-01-20'),
(2, 2, 1, '2026-01-08'),
(2, 5, 1, '2026-01-25'),
(3, 4, 1, '2025-12-15'),
(3, 1, 3, '2026-01-10'),
(4, 6, 1, '2026-01-12'),
(4, 7, 2, '2026-01-18'),
(5, 8, 1, '2026-01-02'),
(5, 9, 2, '2026-01-22'),
(6, 10, 1, '2026-01-14'),
(6, 3, 1, '2026-01-28');


-- =====================================================================
-- EJ. 05 - Corregir y eliminar con seguridad
-- Consigna: corregir el precio de un producto, ajustar el stock de
-- otro tras una venta, y eliminar un registro creado por error.
-- =====================================================================

-- Antes de modificar: se revisa exactamente que fila se va a afectar
SELECT * FROM productos WHERE id_producto = 2;

-- Corregir el precio del Teclado Mecanico RGB (id 2)
UPDATE productos
SET precio = 99.90
WHERE id_producto = 2;

-- Ajustar el stock del producto 1 despues de una venta de 2 unidades
SELECT * FROM productos WHERE id_producto = 1;

UPDATE productos
SET stock = stock - 2
WHERE id_producto = 1;

-- Simular un registro creado por error, para despues eliminarlo
INSERT INTO productos (nombre, categoria, precio, stock)
VALUES ('Producto de prueba', 'Accesorios', 1.00, 1);

-- Se verifica cual fila exacta se va a borrar antes del DELETE
SELECT * FROM productos WHERE nombre = 'Producto de prueba';

DELETE FROM productos
WHERE nombre = 'Producto de prueba';


-- =====================================================================
-- EJ. 06 - Primera exploracion
-- Consigna: ver todos los productos; mostrar solo nombre y precio;
-- presentar el precio con un nombre de columna mas comprensible.
-- =====================================================================

-- 1) Ver todos los productos, con todas sus columnas
SELECT * FROM productos;

-- 2) Mostrar solo lo que el usuario final necesita
SELECT nombre, precio FROM productos;

-- 3) Alias (AS) para que la columna se entienda sin ambiguedad
SELECT nombre, precio AS precio_actual FROM productos;


-- =====================================================================
-- EJ. 07 - Filtrar por una condicion
-- Consigna: productos con precio superior a un umbral, clientes de
-- una ciudad concreta, y productos de una categoria determinada.
-- =====================================================================

-- Productos con precio superior a 100 (condicion numerica)
SELECT nombre, precio
FROM productos
WHERE precio > 100;

-- Clientes de una ciudad concreta (condicion de texto)
SELECT nombre, ciudad
FROM clientes
WHERE ciudad = 'Bogota';

-- Productos de una categoria determinada
SELECT nombre, categoria
FROM productos
WHERE categoria = 'Perifericos';


-- =====================================================================
-- EJ. 08 - Combinar condiciones
-- Consigna: productos de una categoria Y por debajo de cierto precio;
-- luego clientes de dos ciudades posibles.
-- =====================================================================

-- Ambas condiciones deben cumplirse a la vez -> AND
SELECT nombre, categoria, precio
FROM productos
WHERE categoria = 'Perifericos'
  AND precio < 50;

-- Basta con que se cumpla una de dos -> OR (o el equivalente con IN)
SELECT nombre, ciudad
FROM clientes
WHERE ciudad = 'Bogota' OR ciudad = 'Medellin';


-- =====================================================================
-- EJ. 09 - Buscar por rangos y texto
-- Consigna: productos dentro de un rango de precios; productos de un
-- conjunto de categorias; productos cuyo nombre contenga una palabra.
-- =====================================================================

-- Rango de precios -> BETWEEN incluye ambos extremos
SELECT nombre, precio
FROM productos
WHERE precio BETWEEN 50 AND 200;

-- Pertenencia a un conjunto cerrado de categorias -> IN
SELECT nombre, categoria
FROM productos
WHERE categoria IN ('Audio', 'Componentes');

-- Texto parcial -> LIKE con comodin % antes y despues de la palabra
SELECT nombre
FROM productos
WHERE nombre LIKE '%Inalámbric%';


-- =====================================================================
-- EJ. 10 - Ordenar resultados
-- Consigna: productos del mas barato al mas caro y luego del mayor
-- stock al menor; combinar un filtro con un ordenamiento.
-- =====================================================================

-- ASC: del mas barato al mas caro (criterio de presentacion)
SELECT nombre, precio
FROM productos
ORDER BY precio ASC;

-- DESC: del mayor stock al menor
SELECT nombre, stock
FROM productos
ORDER BY stock DESC;

-- Se combina un filtro (criterio de seleccion) con un orden (presentacion)
SELECT nombre, categoria, precio
FROM productos
WHERE categoria = 'Monitores'
ORDER BY precio ASC;
