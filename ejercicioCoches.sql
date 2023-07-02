/* 
Realizar las siguientes consultas en la BD.

	1.Mostrar todos los vehículos de la BD
	2.Mostrar una lista de los vehiculos con los kilometros de su ultima revisión (Usar inner Join)
	3.Calcular la suma de los importes de todos los vehículos vendidos.
	4.Calcular los beneficios o perdidas de la venta/compra de los vehiculos.
	5.Mostrar las transaciones realizadas entre los imprtes de 2000 y 10000
	6.Mostrar las transaciones realizadas entre los imprtes que no sean de 2000 y 10000
	7.Si el coche tiene que pasar la revision cada 2 años,  Mostrar los que superen ese tiempo.
	8.Calcular el coste total, precio compra y costes de taller de un vehículo determinado. Y de un solo Coche
	9.Cuando hizo por ultima vez la itv Juan Gonzalez.
*/

/* ### 1.Mostrar todos los vehículos de la BD ### */ 

/* Primero indico que voy a usar la base de datos coches */
USE coches;
/* Realizo la consulta para obtener todos los registros de la tabla coche */
SELECT * FROM coche;

/* ### 2.Mostrar una lista de los vehiculos con los kilometros de su ultima revisión (Usar inner Join) ### */

SELECT c.matricula, c.modelo, m.kilometros
FROM coche c
INNER JOIN mantenimiento m ON m.matricula = c.matricula; 

SELECT * FROM mantenimiento;

/* ### 3.Calcular la suma de los importes de todos los vehículos vendidos. ### */
SELECT * FROM transaccion;

SELECT SUM(importe) AS 'Cantidad total ventas'
FROM transaccion
WHERE operacion = 'VENTA';

/* ### 4.Calcular los beneficios o perdidas de la venta/compra de los vehiculos. ### */
SELECT v.total_ventas - c.total_coches AS 'BENEFICIOS DE NEGOCIO'
FROM
(SELECT SUM(importe) AS 'total_ventas'
FROM transaccion
WHERE operacion = 'VENTA') AS v,
(SELECT SUM(importe) AS 'total_coches'
FROM transaccion
WHERE operacion = 'COMPRA') AS c;
       
/* ### 5.Mostrar las transaciones realizadas entre los importes de 2000 y 10000 ### */
SELECT * FROM transaccion
WHERE importe BETWEEN 2000 AND 10000;

/* ### 6.Mostrar las transaciones realizadas entre los importes que no sean de 2000 y 10000 ### */
SELECT * FROM transaccion
WHERE importe NOT BETWEEN 2000 AND 10000;

/* ### 7.Si el coche tiene que pasar la revision cada 2 años,  Mostrar los que superen ese tiempo. ### */
SELECT * FROM mantenimiento;

SELECT c.matricula, c.marca , m.itv
FROM coche c
INNER JOIN mantenimiento m  ON m.matricula = c.matricula
WHERE YEAR(m.itv) < YEAR(curdate()) - 2;

/* ### 8.Calcular el coste total, precio compra y costes de taller de un vehículo determinado. Y de un solo Coche ### */
SELECT c.matricula, c.marca, SUM(t.importe + tr.importe) AS 'Precio total'
FROM coche c
INNER JOIN transaccion tr ON tr.matricula = c.matricula
INNER JOIN taller t ON t.matricula = tr.matricula
WHERE tr.operacion = 'COMPRA' AND c.matricula = '0001AAA'
GROUP BY c.matricula, c.marca;

/* ### 9.Cuando hizo por ultima vez la itv Juan Gonzalez. ### */
SELECT * FROM personas;


SELECT p.nombre, p.apellidos, tr.numCliente, m.matricula, c.modelo, m.itv 
FROM personas p 
INNER JOIN transaccion tr ON tr.numCliente = p.id_nCliente
INNER JOIN coche c ON c.matricula = tr.matricula
INNER JOIN mantenimiento m ON m.matricula = c.matricula
WHERE p.nombre = 'Juan' AND p.apellidos = 'Gonzalez' AND tr.operacion = 'COMPRA';

