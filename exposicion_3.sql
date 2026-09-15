-- 1 y 2. Tablas relacionadas
CREATE TABLE Producto (
  id INT PRIMARY KEY,
  nombre VARCHAR(100),
  precio DECIMAL(10,2),
  categoria VARCHAR(50)
);

CREATE TABLE Venta (
  id INT PRIMARY KEY,
  id_producto INT,
  cantidad INT,
  fecha DATE,
  FOREIGN KEY (id_producto)
    REFERENCES Producto(id)
);



-- 3

CREATE TABLE productos_caros AS
SELECT nombre, precio
FROM Producto
WHERE precio > 100000;

-- 4 Revisar estructura

DESCRIBE productos_caros;

--5 y 6

SELECT p.nombre,
  UPPER(p.categoria) AS categoria,
  ROUND(p.precio,0) AS precio_red,
  CONCAT(p.nombre,' - ',p.categoria)
  AS detalle
FROM Producto p;

--6 y 7
CASE 
  WHEN v.cantidad > 50 THEN p.precio * 0.9 
  ELSE p.precio 
END AS precio_final

-- 8
SELECT p.nombre AS producto,
  UPPER(p.categoria) AS categoria,
  v.cantidad,
  IF(v.cantidad > 50,
    p.precio * 0.9, p.precio)
  AS precio_final
FROM Producto p
JOIN Venta v
  ON p.id = v.id_producto;
