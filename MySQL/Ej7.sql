-- 7) Crear un Trigger de modo que al insertar un dato en la tabla Appointment,
-- se actualice la cantidad de appointments del paciente, la fecha de actualización
-- y el usuario responsable de la misma (actualiza la tabla APPOINTMENTS PER PATIENT).
DELIMITER //
CREATE TRIGGER update_appointments_per_patient
AFTER INSERT ON appointment
FOR EACH ROW
BEGIN
  UPDATE appointments_per_patient
  SET count_appointments = count_appointments + 1,
    last_update = NOW(),
    user = CURRENT_USER()
  WHERE id_patient = NEW.patient_id;
END;
// DELIMITER ;
