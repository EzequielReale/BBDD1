-- Crea un usuario para las bases de datos usando el nombre ‘appointments_user’.
-- Asigne a estos todos los permisos sobre sus respectivas tablas. Habiendo creado
-- este usuario evitaremos el uso de ‘root’ para el resto del trabajo práctico.
CREATE USER 'appointments_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON appointments.* TO 'appointments_user'@'localhost';
FLUSH PRIVILEGES;

-- Adicionalmente, con respecto a esta base de datos:
    -- Cree un usuario sólo con permisos para realizar consultas de selección, es decir
    -- que no puedan realizar cambios en la base. Use el nombre ‘appointments_select’.
    CREATE USER 'appointments_select'@'localhost' IDENTIFIED BY 'password';
    GRANT SELECT ON appointments.* TO 'appointments_select'@'localhost';
    FLUSH PRIVILEGES;
    
    --Cree un usuario que pueda realizar consultas de selección, inserción, actualización
    -- y eliminación a nivel de filas, pero que no puedan modificar el esquema. Use el
    -- nombre ‘appointments_update’.
    CREATE USER 'appointments_update'@'localhost' IDENTIFIED BY 'password';
    GRANT SELECT, INSERT, UPDATE, DELETE ON appointments.* TO 'appointments_update'@'localhost';
    FLUSH PRIVILEGES;
    
    -- Cree un usuario que tenga los permisos de los anteriores, pero que además pueda
    -- modificar el esquema de la base de datos. Use el nombre 'appointments_schema’.
    CREATE USER 'appointments_schema'@'localhost' IDENTIFIED BY 'password';
    GRANT SELECT, INSERT, UPDATE, DELETE, ALTER, CREATE, DROP ON appointments.* TO 'appointments_schema'@'localhost';
    FLUSH PRIVILEGES;
