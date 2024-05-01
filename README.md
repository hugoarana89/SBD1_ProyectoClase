Normalización de los datos.

1. Se eliminaron los grupos repetidos, en este caso sexo y raza estaban duplicados por lo cual se eliminó.
2. Se identificaron las entidades las cuales se repetían. Estas entidades fueron: País, Región, Departamento, Municipio, Partidos, sexo, raza, Elección.
3. Se identificaron las claves primarias para las nuevas entidades creadas.
   Región: Llave primaria "nombre_region"
   país: Llave primaria "nombre_pais"
   Departamento: Llave primaria "id_departamento" concatenación de nombre de país + nomre de departamento
   municipio: Llave primaria "Id_municipio" concatenación de nombre de departamento + nombre de país + nombre de municipio
   Elección: Llave primaria "Año_elección"
   Partido: Llave primaria "Partido" siglas del partido
   Sexo: Llave primaria "Tipo_sexo" si es hombre o mujer
   Raza: Llave primaria "Tipo_raza" si es ladino, indiena o garifuna
   votante: Llave primaria "Id_votante" concatenación del nombre del municipio + nombre de departamento + cantidad de votos(analfabetos+alfabetos)
