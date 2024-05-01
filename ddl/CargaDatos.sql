use proyecto;
insert into pais
select DISTINCT pais from temporal;

insert into region
select DISTINCT region from temporal;

insert into partido
select DISTINCT partido, nombre_partido from temporal;

insert into eleccion
select DISTINCT año_eleccion, nombre_eleccion from temporal;

insert into zona
select DISTINCT CONCAT(region, ':', pais) as id_zona, pais, region from temporal;

insert into departamento
select DISTINCT CONCAT (depto,':',pais) as id_departamento, depto as nombre_departamento, CONCAT(region, ':', pais) as id_zona from temporal;


insert into municipio
select DISTINCT CONCAT (municipio,':',depto) as id_municipio, municipio, CONCAT (depto,':',pais) as id_departamento from temporal;


insert into votacion
select DISTINCT CONCAT(pais,':', año_eleccion) as id_votacion, pais, año_eleccion from temporal;

insert into participacion
select DISTINCT CONCAT(partido,':', año_eleccion) as id_participacion, año_eleccion, partido from temporal;

insert into sexo
select DISTINCT sexo from temporal;

insert into raza
select DISTINCT raza from temporal;

insert into votantes (sexo,raza,analfabetos,alfabetos,primaria,nivel_medio,universitarios,id_municipio,partido,año_eleccion)
select  sexo, raza, analfabetos, alfabetos, primaria, 
nivel_medio, universitarios, concat (municipio,':',depto) as id_municipio, partido, año_eleccion from temporal;

