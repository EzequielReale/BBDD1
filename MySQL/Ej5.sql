-- 5) Agregar la siguiente tabla:
-- APPOINTMENTS_PER_PATIENT
-- idApP: int(11) PK AI
-- id_patient: int(11)
-- count_appointments: int(11)
-- last_update: datetime
-- user: varchar(16)
CREATE TABLE `appointments_per_patient` (
  `idApp` int(11) NOT NULL AUTO_INCREMENT,
  `id_patient` int(11) NOT NULL,
  `count_appointments` int(11) NOT NULL,
  `last_update` datetime NOT NULL,
  `user` varchar(16) NOT NULL,
  PRIMARY KEY (`idApp`),
  FOREIGN KEY (`id_patient`) REFERENCES `patient`(`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
