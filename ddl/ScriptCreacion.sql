CREATE SCHEMA `proyecto` DEFAULT CHARACTER SET utf8 COLLATE utf8_spanish_ci ;
use proyecto;

CREATE TABLE `proyecto`.`temporal` (
  `NOMBRE_ELECCION` VARCHAR(45) NULL,
  `AÑO_ELECCION` INT NULL,
  `PAIS` VARCHAR(45) NULL,
  `REGION` VARCHAR(45) NULL,
  `DEPTO` VARCHAR(45) NULL,
  `MUNICIPIO` VARCHAR(45) NULL,
  `PARTIDO` VARCHAR(45) NULL,
  `NOMBRE_PARTIDO` VARCHAR(45) NULL,
  `SEXO` VARCHAR(45) NULL,
  `RAZA` VARCHAR(45) NULL,
  `ANALFABETOS` INT NULL,
  `ALFABETOS` INT NULL,
  `SEXO2` VARCHAR(45) NULL,
  `RAZA2` VARCHAR(45) NULL,
  `PRIMARIA` INT NULL,
  `NIVEL_MEDIO` INT NULL,
  `UNIVERSITARIOS` INT NULL);



CREATE TABLE `proyecto`.`pais` (
    `nombre_pais` VARCHAR(15) NOT NULL,
    PRIMARY KEY (`nombre_pais`)
);


CREATE TABLE region (
    `nombre_region` VARCHAR(10) NOT NULL,
    PRIMARY KEY (nombre_region)
);

CREATE TABLE zona (
    `id_zona` VARCHAR(25) NOT NULL,
    `nombre_pais`   VARCHAR(15) NOT NULL,
	`nombre_region`   VARCHAR(10) NOT NULL,
    PRIMARY KEY (id_zona)
);

ALTER TABLE zona
    ADD CONSTRAINT pais_zona_fk FOREIGN KEY (nombre_pais)
        REFERENCES pais (nombre_pais);

ALTER TABLE zona
    ADD CONSTRAINT region_zona_fk FOREIGN KEY (nombre_region)
        REFERENCES region (nombre_region);		
		
CREATE TABLE departamento (
	`id_departamento` VARCHAR(50) NOT NULL,
    `nombre_departamento` VARCHAR(30) NOT NULL,
    `id_zona`       VARCHAR(25) NOT NULL,
	PRIMARY KEY (id_departamento)
);
ALTER TABLE departamento
    ADD CONSTRAINT departamento_zona_fk FOREIGN KEY (id_zona)
        REFERENCES zona (id_zona);
		
CREATE TABLE municipio (
    `id_municipio` VARCHAR(50) NOT NULL,
    `nombre_municipio`    VARCHAR(40) NOT NULL,
    `id_departamento` VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_municipio)
);
ALTER TABLE municipio
    ADD CONSTRAINT municipio_departamento_fk FOREIGN KEY (id_departamento)
        REFERENCES departamento (id_departamento);
		
		
CREATE TABLE eleccion (
    `año_eleccion`    INT NOT NULL,
    `nombre_eleccion` VARCHAR(30) NOT NULL,
    PRIMARY KEY (año_eleccion)
);

CREATE TABLE votacion (
    `id_votacion`  VARCHAR(20) NOT NULL,
    `nombre_pais`  VARCHAR(15) NOT NULL,
    `año_eleccion` INT NOT NULL,
    PRIMARY KEY (id_votacion)
);

ALTER TABLE votacion
    ADD CONSTRAINT votacion_eleccion_fk FOREIGN KEY (año_eleccion)
        REFERENCES eleccion (año_eleccion);

ALTER TABLE votacion
    ADD CONSTRAINT votacion_pais_fk FOREIGN KEY (nombre_pais)
        REFERENCES pais (nombre_pais);
		
CREATE TABLE partido (
    `partido`        VARCHAR(15) NOT NULL,
    `nombre_partido` VARCHAR(40) NOT NULL,
    PRIMARY KEY (partido)
);

CREATE TABLE participacion (
    `id_participacion` VARCHAR(20) NOT NULL,
    `año_eleccion`     INT NOT NULL,
    `partido`          VARCHAR(15) NOT NULL,
    PRIMARY KEY (id_participacion)
);

ALTER TABLE participacion
    ADD CONSTRAINT participacion_eleccion_fk FOREIGN KEY (año_eleccion)
        REFERENCES eleccion (año_eleccion);

ALTER TABLE participacion
    ADD CONSTRAINT participacion_partido_fk FOREIGN KEY (partido)
        REFERENCES partido (partido);
		
CREATE TABLE sexo (
    `tipo_sexo`             VARCHAR(7) NOT NULL,
    PRIMARY KEY (tipo_sexo)
);

CREATE TABLE raza (
    `tipo_raza`             VARCHAR(15) NOT NULL,
    PRIMARY KEY (`tipo_raza`)
);

CREATE TABLE votantes (
    `id_votantes`      int NOT NULL AUTO_INCREMENT,
    `sexo`             VARCHAR(7) NOT NULL,
    `raza`             VARCHAR(15) NOT NULL,
    `analfabetos`      INT NOT NULL,
    `alfabetos`        INT NOT NULL,
    `primaria`         INT NOT NULL,
    `nivel_medio`      INT NOT NULL,
    `universitarios`   INT NOT NULL,
    `id_municipio`     VARCHAR(50) NOT NULL,
    `partido`          VARCHAR(15) NOT NULL,
    `año_eleccion`     INT NOT NULL,
    PRIMARY KEY (id_votantes)
);

ALTER TABLE votantes
    ADD CONSTRAINT votantes_eleccion_fk FOREIGN KEY (año_eleccion)
        REFERENCES eleccion (año_eleccion);

ALTER TABLE votantes
    ADD CONSTRAINT votantes_municipio_fk FOREIGN KEY (id_municipio)
        REFERENCES municipio (id_municipio);

ALTER TABLE votantes
    ADD CONSTRAINT votantes_partido_fk FOREIGN KEY (partido)
        REFERENCES partido (partido);
		
ALTER TABLE votantes
    ADD CONSTRAINT votantes_sexo_fk FOREIGN KEY (sexo)
        REFERENCES sexo(tipo_sexo);
		
ALTER TABLE votantes
    ADD CONSTRAINT votantes_raza_fk FOREIGN KEY (raza)
        REFERENCES raza(tipo_raza);		
		