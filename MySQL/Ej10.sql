-- 10)Considerando la siguiente consulta:
select count(a.patient_id)
from appointment a, patient p, doctor d, medical_review mr
where a.patient_id= p.patient_id
  and a.patient_id= mr.patient_id
  and a.appointment_date=mr.appointment_date and mr.doctor_id = d.doctor_id
  and d.doctor_speciality = ‘Cardiology’ and p.patient_city = Rosario

-- Analice su plan de ejecución mediante el uso de la sentencia EXPLAIN.
-- a- ¿Qué atributos del plan de ejecución encuentra relevantes
-- para evaluar la performance de la consulta?
EXPLAIN select count(a.patient_id)
from appointment a, patient p, doctor d, medical_review mr
where a.patient_id= p.patient_id
  and a.patient_id= mr.patient_id
  and a.appointment_date=mr.appointment_date and mr.doctor_id = d.doctor_id
  and d.doctor_specialty = 'Cardiology' and p.patient_city = 'Rosario';

-- Output:
# id, select_type, table, partitions, type,    possible_keys,         key,        key_len,       ref,                                                     rows,  filtered,     Extra
'1',    'SIMPLE',   'd',      NULL,   'ALL',    'PRIMARY',            NULL,         NULL,        NULL,                                                    '100',  '10.00',  'Using where'
'1',    'SIMPLE',   'mr',     NULL,   'ref',    'PRIMARY,doctor_id',  'doctor_id',   '4',   'appointments.d.doctor_id',                                   '297',  '100.00', 'Using index'
'1',    'SIMPLE',   'p',      NULL,   'eq_ref', 'PRIMARY', 'PRIMARY',                '4',   'appointments.mr.patient_id',                                  '1',   '10.00',  'Using where'
'1',    'SIMPLE',   'a',      NULL,   'eq_ref', 'PRIMARY', 'PRIMARY',                '9',   'appointments.mr.patient_id,appointments.mr.appointment_date', '1',   '100.00', 'Using index'

-- Respuesta:
-- Atributos relevantes del plan de ejecución para evaluar la performance de la consulta:
-- 1. Tipo de unión (type): Indica cómo se unen las tablas. Ejemplos incluyen 'ALL', 'ref', 'eq_ref', etc.
-- 2. Posibles claves (possible_keys): Muestra los índices que podrían ser utilizados para encontrar filas en la tabla.
-- 3. Clave (key): Indica el índice que realmente se utiliza.
-- 4. Referencias clave (key_len): Muestra la longitud de la clave utilizada.
-- 5. Filas (rows): Estima el número de filas que MySQL necesita examinar para ejecutar la consulta.
-- 6. Filtrado (filtered): Indica el porcentaje de filas que se filtran en cada paso del plan de ejecución.
-- 7. Extra: Proporciona información adicional sobre cómo se ejecuta la consulta, como 'Using where', 'Using index', etc.

-- b- Observe en particular el atributo type ¿cómo se están aplicando
-- los JOIN entre las tablas involucradas?
-- Respuesta:
-- En el plan de ejecución, los JOIN se aplican utilizando diferentes tipos:
  -- 1. La tabla `d` utiliza un "ALL", lo que significa un full scan, es decir,
  -- se evalúan todas las filas de la tabla. Esto es menos eficiente.
  -- 2. La tabla `mr` utiliza un "ref", lo que indica que está utilizando un
  -- índice basado en la referencia de `doctor_id`, lo cual es más eficiente.
  -- 3. Las tablas `p` y `a` utilizan "eq_ref", lo cual es óptimo, ya que implica que para
  -- cada fila de la tabla de la izquierda, hay como máximo una fila coincidente en la tabla de la derecha.

-- c- Según lo que observó en los puntos anteriores, ¿qué mejoras
-- se pueden realizar para optimizar la consulta?
-- Respuesta:
  -- 1. Crear un índice en la columna `doctor_specialty` de la tabla `doctor` para evitar el full scan en esa tabla.
  -- 2. Evaluar la creación de un índice compuesto en las columnas `patient_city` y `patient_id`
  -- de la tabla `patient`, lo que podría ayudar a reducir el número de filas escaneadas.
  -- 3. Optimizar el filtro por `appointment_date` añadiendo un índice en esa
  -- columna si la consulta la utiliza con frecuencia.
  -- 4. Verificar si se pueden reducir los JOINs o reestructurar la consulta para
  -- evitar operaciones costosas como los full scans.

-- d- Aplique las mejoras propuestas y vuelva a analizar el plan de
-- ejecución. ¿Qué cambios observa?
-- Respuesta:
-- Después de aplicar los índices sugeridos, se debería observar una mejora en el atributo
-- `type` para la tabla `d`, cambiando de 'ALL' a 'ref' o 'eq_ref', lo que implica una búsqueda
-- más eficiente en lugar de un escaneo completo. Además, el número estimado de filas escaneadas
-- (`rows`) debería disminuir, lo cual se reflejaría también en un menor tiempo de ejecución.
