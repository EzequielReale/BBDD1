-- 2) Hallar aquellos pacientes que para todas sus consultas médicas siempre
-- hayan dejado su número de teléfono primario (nunca el teléfono secundario).
SELECT *
FROM patient p
WHERE p.secondary_phone NOT IN (
    SELECT a.contact_phone
    FROM appointment a
    WHERE p.patient_id = a.patient_id
    );
