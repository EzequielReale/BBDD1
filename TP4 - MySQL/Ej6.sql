-- 6) Crear un Stored Procedure que realice los siguientes pasos
-- dentro de una transacción:
-- a- Realizar una consulta que para cada pacient (identificado por id_patient),
-- calcule la cantidad de appointments que tiene registradas. Registrar la
-- fecha en la que se realiza esta carga y además del usuario con el se realiza.
-- b- Guardar el resultado de la consulta en un cursor.
-- c- Iterar el cursor e insertar los valores correspondientes en
-- la tabla APPOINTMENTS PER PATIENT.

DELIMITER //
CREATE PROCEDURE update_appointments_per_patient()
BEGIN
  DECLARE cant INT;
  DECLARE id_patient INT;
  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT p.patient_id, COUNT(a.patient_id)
    FROM patient p INNER JOIN appointment a ON p.patient_id = a.patient_id
    GROUP BY p.patient_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  START TRANSACTION;
  OPEN cur;
  
  poll: LOOP
    FETCH cur INTO id_patient, cant;
    IF done THEN
      LEAVE poll;
    END IF;
    INSERT INTO appointments_per_patient (id_patient, count_appointments, last_update, user)
    VALUES (id_patient, cant, NOW(), CURRENT_USER());
  END LOOP;

  COMMIT;

  CLOSE cur;
END
// DELIMITER ;

-- Llamar al stored procedure
CALL update_appointments_per_patient();
