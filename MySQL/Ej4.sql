-- 4) Hallar los pacientes (únicamente es necesario su id) que se
-- atendieron con todos los doctores de la ciudad en la que viven
-- a- Realice la consulta sin utilizar la vista creada anteriormente

--Con not exists (porque soy un rebelde):
SELECT p.patient_id
FROM patient p
WHERE NOT EXISTS (
    SELECT d.doctor_id
    FROM doctor d
    WHERE d.doctor_city = p.patient_city AND NOT EXISTS (
        SELECT *
        FROM medical_review mr
        WHERE mr.patient_id = p.patient_id AND mr.doctor_id = d.doctor_id ) );

-- Sin not exists:
SELECT p.patient_id 
FROM patient p 
INNER JOIN medical_review mr ON p.patient_id = mr.patient_id 
INNER JOIN doctor d ON mr.doctor_id = d.doctor_id 
WHERE d.doctor_city = p.patient_city 
GROUP BY p.patient_id, p.patient_city
HAVING COUNT(DISTINCT d.doctor_id) = (
    SELECT COUNT(*)
    FROM doctor d2
    WHERE d2.doctor_city = p.patient_city
    );

-- b- Realice la consulta utilizando la vista creada anteriormente
-- Restricción: resolver este ejercicio sin usar la cláusula “NOT EXIST”.
SELECT p.patient_id 
FROM patient p 
INNER JOIN medical_review mr ON p.patient_id = mr.patient_id 
INNER JOIN doctor d ON mr.doctor_id = d.doctor_id 
WHERE d.doctor_city = p.patient_city 
GROUP BY p.patient_id 
HAVING COUNT(DISTINCT d.doctor_id) = (
    SELECT COUNT(*)
    FROM doctors_per_patients dpp
    WHERE dpp.patient_id = p.patient_id
    );
