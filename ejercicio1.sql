/*
De cada estación meteorológica se conocen sus coordenadas: longitud, latitud y altitud, además de un código identificador para cada una.
De cada estación se recoge una serie de datos o muestras de la que se conoce: fecha, temperatura máxima, temperatura mínima, precipitaciones, 
humedad máxima, humedad mínima, velocidad del viento máxima y velocidad del viento mínima.
*/

/* Creo la base de datos */
create database ejercicio1;

/* Indico que voy a utilizar la base de datos "ejercicio1" */
use ejercicio1;

/* Creo las tabla */
create table if not exists estacion(
	id_estacion int auto_increment primary key,
    longitud varchar(20),
    latitud varchar(20),
    altitud varchar(20)
);

/* Inserto datos en las tabla */
insert into estacion(id_estacion, longitud, latitud, altitud)
				values(null, '123', '321', '234'),
					(null, '823', '361', '434'),
					(null, '023', '301', '534'),
                    (null, '4523', '43214', '1234'),
                    (null, '1253', '234421', '23544'),
                    (null, '1230', '3241', '2344');

/* Compruebo la tabla con todos los registros insertados */
select * from estacion;

/* Borro la tabla */
drop table estacion_dato;

/* Creo las tabla */
create table estacion_dato(
	id_dato int primary key auto_increment not null,
    fecha timestamp default current_timestamp,
    temp_max int,
    temp_min int,
    precipitaciones boolean,
    hum_max int,
    hum_min int,
    vel_max int,
    vel_min int,
    id_estacion int not null,
    constraint fk_id_dato_estacion foreign key(id_estacion) references estacion(id_estacion) on delete cascade
);

/* Inserto datos en las tabla */
/* En el campo fecha utilizando la funcion 'CURRENT_TIMESTAMP' obtengo la fecha y hora actual en la que se inserta el registro*/
insert into estacion_dato(id_dato, fecha, temp_max, temp_min, precipitaciones, hum_max, hum_min, vel_max, vel_min, id_estacion)
					values(null, CURRENT_TIMESTAMP, 412, 37, true, 22, 12, 132, 12, 1),
						  (null, CURRENT_TIMESTAMP, 4142, 37, false, 22, 12, 132, 12, 2),
                          (null, CURRENT_TIMESTAMP, 612, 37, true, 22, 12, 132, 12, 3),
                          (null, CURRENT_TIMESTAMP, 912, 37, false, 22, 12, 132, 12, 4),
                          (null, CURRENT_TIMESTAMP, 32, 37, false, 22, 12, 132, 12, 5),
                          (null, CURRENT_TIMESTAMP, 512, 37, true, 22, 12, 132, 12, 6),
                          (null, CURRENT_TIMESTAMP, 312, 37, false, 22, 12, 132, 12, 2),
                          (null, CURRENT_TIMESTAMP, 542, 37, true, 22, 12, 132, 12, 3);
                          
INSERT INTO estacion_dato(id_dato, fecha, temp_max, temp_min, precipitaciones, hum_max, hum_min, vel_max, vel_min, id_estacion)
VALUES (null, CURRENT_TIMESTAMP, 20, 0, false, 1, 2, 300, 11, 3);

/* Compruebo todos los registros de la tabla */
select * from estacion_dato;

/* ###CONSULTAS### */

/* Consulta ordenada de forma por defecto ASC */
SELECT id_dato, precipitaciones FROM estacion_dato
ORDER BY precipitaciones;

/* Consulta ordenada de forma DESC */
SELECT id_dato, precipitaciones FROM estacion_dato
ORDER BY id_dato DESC; 

/* Consulta eliminando datos duplicados */
SELECT DISTINCT id_estacion FROM estacion_dato;

/* Consulta dentro de un intervalo de valores utilizando BETWEEN */
SELECT * FROM estacion
WHERE longitud BETWEEN 0 AND 500;

/* Consulta utilizando un patron LIKE */
SELECT * FROM estacion
WHERE latitud LIKE '3%';

/* Consulta utilizando IN para encontrar unos valores especificos */
SELECT * FROM estacion_dato
WHERE id_estacion IN (1, 2, 6);

SELECT * FROM estacion_dato
WHERE id_estacion NOT IN (1, 2, 6);


/* ### FUNCION AVG ### */
/* Consulta para sacar la media aritmetica*/
SELECT AVG(temp_max) as 'MEDIA TEMPERATURA MAXIMA'
FROM estacion_dato 
WHERE temp_max BETWEEN 0 AND 700;

/* ### FUNCION COUNT ### */
/* Consulta para contar los registros que no tengan null */
SELECT COUNT(*) FROM estacion;

SELECT COUNT(id_dato) FROM estacion_dato;

/* ### FUNCIONES SUM() Y MIN() ### */
SELECT MAX(latitud) AS 'LATITUD MAXIMA'
FROM estacion
WHERE altitud BETWEEN 100 AND 1000;

SELECT MIN(altitud) as 'ALTITUD MINIMA'
FROM estacion
WHERE id_estacion = 3;

/* ### FUNCION SUM() ### */
/* Consulta para sumar todos los registros de temperatura maxima */
SELECT SUM(temp_max) as 'Suma temperatura maxima'
FROM estacion_dato;

/* ### FUNCION LIMIT ### */
/* Consulta limitando el numero de resultados */
SELECT * FROM estacion LIMIT 2;

/* Pasando 2 argumentos, el primer argumento indica desde que registro empieza(comenzando desde 0)
	y el segundo argumento el numero de registros obtenidos */
SELECT * FROM estacion_dato LIMIT 3, 5;    

/* ### OPERADORES LOGICOS IN y EXISTS */
SELECT DISTINCT id_estacion
FROM estacion_dato ED
WHERE EXISTS (
	SELECT * FROM estacion E
    WHERE E.id_estacion = ED.id_estacion
    AND ED.precipitaciones = true
);

SELECT DISTINCT id_estacion
FROM estacion
WHERE id_estacion IN (
	SELECT id_estacion
    FROM estacion_dato
    WHERE precipitaciones = true
);

/* ### CONSULTAS MULTITABLA ### */
SELECT E.id_estacion, D.precipitaciones
FROM estacion E, estacion_dato D
WHERE E.id_estacion = D.id_estacion
AND D.precipitaciones = false;

/* UTILIZANDO INNER JOIN */ 
SELECT e.id_estacion AS 'ESTACION NUMERO', d.fecha, d.vel_max 
FROM estacion_dato d
INNER JOIN estacion e on d.id_estacion = e.id_estacion;

/* SUBCONSULTAS */ 
SELECT id_estacion, altitud, (SELECT MIN(vel_min) FROM estacion_dato) AS 'Velocidad minima'
FROM estacion;
