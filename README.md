Normalización de los datos.

1. Se eliminaron los grupos repetidos, en este caso sexo y raza estaban duplicados por lo cual se eliminó.
2. Se identificaron las entidades las cuales se repetían. Estas entidades fueron: País, Región, Departamento, Municipio, Partidos, sexo, raza, Elección.
3. Se identificaron las claves primarias para las nuevas entidades creadas.
   Región: Llave primaria "nombre_region"  
   país: Llave primaria "nombre_pais"
   Departamento: Llave primaria "id_departamento" concatenación de nombre de país + nombre de departamento
   municipio: Llave primaria "Id_municipio" concatenación de nombre de departamento + nombre de país + nombre de municipio
   Elección: Llave primaria "Año_elección"
   Partido: Llave primaria "Partido" siglas del partido
   Sexo: Llave primaria "Tipo_sexo" si es hombre o mujer
   Raza: Llave primaria "Tipo_raza" si es ladino, indiena o garífuna
   votante: Llave primaria "Id_votante" concatenación del nombre del municipio + nombre de departamento + cantidad de votos(analfabetos+alfabetos)
4. Para evitar campos duplicados se crearon las siguientes tablas intermedias: Zona, votación, Participación.
5. Se identificaron las llaves primarias de las nuevas entidades:
   Zona: Llave primaria "Id_zona" concatenación de nombre de la región + nombre de país
   Votación: Llave primaria "Id_votacion" concatenación nombre del país y año
   Participación: Llave primaria "Id_participacion" concatenación de año de la elección + siglas del partido.
6. Se identificaron las relaciones entre las tablas:
   Región - Zona (1:N)
   País - Zona (1:N)
   Zona - Departamento (1:N)
   Departamento - Municipio (1:N)
   País - Votación (1:N)
   Votación - Elección (1:N)
   Elección - Votantes (1:N)
   Elección - Participación (1:N)
   Partido - Participación (1:N)
   Partido - Votantes (1:N)
   Municipio - Votantes (1:N)
   Sexo - Votantes (1:N)
   Raza - Votantes (1:N)
