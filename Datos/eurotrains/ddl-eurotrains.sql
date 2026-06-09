CREATE TABLE Stations (
  `StopCode` VARCHAR(6) NOT NULL,
  `StopName` VARCHAR(25) NOT NULL,
  `Country` VARCHAR(2) NOT NULL,
  `StopLat` double DEFAULT NULL,
  `StopLng` double DEFAULT NULL,
  PRIMARY KEY(StopCode),
  KEY `StopName` (`StopName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci
;

CREATE TABLE EuroTrain (
  `ServiceType` VARCHAR(20) NOT NULL,
  `ns` INT UNSIGNED NOT NULL,
  `StopCode` VARCHAR(6) NOT NULL,
  `tts` datetime NOT NULL,
  `ServiceID` VARCHAR(10) NOT NULL,
  `ServiceDate` VARCHAR(10) NOT NULL,
  `ServiceTrain` INT unsigned NOT NULL,
  `StopDepartureTime` TIME DEFAULT NULL,
  `StopDepartureDelay` INT,
  `StopArrivalTime` TIME DEFAULT NULL,
  `StopArrivalDelay` INT,
  PRIMARY KEY(ServiceID, StopCode),
  KEY `ServiceID` (`ServiceID`),
  KEY `fk_StopCode` (`StopCode`),
  KEY `ServiceType` (`ServiceType`),
  CONSTRAINT `fk_StopCode` FOREIGN KEY (StopCode) REFERENCES Stations(StopCode)
                           ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci
;
