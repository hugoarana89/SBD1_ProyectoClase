use proyecto;

--Consulta 1
select partido.partido,  partido.nombre_partido as nombre, zona.nombre_pais as pais, votantes.año_eleccion as año, 
(sum(analfabetos + alfabetos) /
(select sum(votantes.analfabetos + votantes.alfabetos) as votos 
from votantes
INNER JOIN municipio on municipio.id_municipio=votantes.id_municipio
INNER JOIN departamento on departamento.id_departamento = municipio.id_departamento
INNER JOIN zona on zona.id_zona = departamento.id_zona
where zona.nombre_pais = pais and votantes.año_eleccion =  año
))*100 as votos 
from votantes
INNER JOIN municipio on municipio.id_municipio=votantes.id_municipio
INNER JOIN departamento on departamento.id_departamento = municipio.id_departamento
INNER JOIN zona on zona.id_zona = departamento.id_zona
INNER JOIN partido on partido.partido = votantes.partido
group by partido.partido,  partido.nombre_partido, zona.nombre_pais, votantes.año_eleccion;

--Consulta 2

select departamento.nombre_departamento as departamento, zona.nombre_pais as pais, votantes.sexo,
(sum(analfabetos + alfabetos) /
(select sum(votantes.analfabetos + votantes.alfabetos) as votos_mujeres
from votantes
INNER JOIN municipio on municipio.id_municipio=votantes.id_municipio
INNER JOIN departamento on departamento.id_departamento = municipio.id_departamento
INNER JOIN zona on zona.id_zona = departamento.id_zona
where votantes.sexo = 'mujeres' and zona.nombre_pais = pais
))*100 as votos 
from votantes
INNER JOIN municipio on municipio.id_municipio=votantes.id_municipio
INNER JOIN departamento on departamento.id_departamento = municipio.id_departamento
INNER JOIN zona on zona.id_zona = departamento.id_zona
INNER JOIN partido on partido.partido = votantes.partido
where votantes.sexo = 'mujeres'
group by departamento.nombre_departamento, zona.nombre_pais, votantes.sexo;

--Consulta 3 (esta mala)
SELECT p.nombre_pais, 
       pa.partido, 
       COUNT(v.id_municipio) AS numero_alcaldias
FROM votantes v
JOIN municipio m ON v.id_municipio = m.id_municipio
JOIN departamento d ON m.id_departamento = d.id_departamento
JOIN zona z ON d.id_zona = z.id_zona
JOIN region r ON z.nombre_region = r.nombre_region
JOIN pais p ON z.nombre_pais = p.nombre_pais
JOIN participacion pa ON v.partido = pa.partido AND v.año_eleccion = pa.año_eleccion
WHERE pa.partido IN (
    SELECT partido
    FROM participacion p1
    WHERE EXISTS (
        SELECT 1
        FROM participacion p2
        WHERE p1.partido = p2.partido
        AND p1.año_eleccion = p2.año_eleccion
        GROUP BY p2.partido, p2.año_eleccion
        HAVING COUNT(*) = (
            SELECT MAX(cnt)
            FROM (
                SELECT COUNT(*) AS cnt
                FROM participacion p3
                WHERE p1.partido = p3.partido
                AND p1.año_eleccion = p3.año_eleccion
                GROUP BY p3.partido, p3.año_eleccion
            ) AS counts
        )
    )
)
GROUP BY p.nombre_pais, pa.partido;



--Consulta 4

select zona.nombre_pais as pais, zona.nombre_region as region, SUM(ANALFABETOS + ALFABETOS) as indigenas from votantes
INNER JOIN municipio on municipio.id_municipio=votantes.id_municipio
INNER JOIN departamento on departamento.id_departamento = municipio.id_departamento
INNER JOIN zona on zona.id_zona = departamento.id_zona
INNER JOIN partido on partido.partido = votantes.partido
where votantes.raza = 'indigenas'
group by zona.nombre_pais, zona.nombre_region
HAVING SUM(ANALFABETOS + ALFABETOS) > (
select SUM(ANALFABETOS + ALFABETOS) 
from votantes
INNER JOIN municipio on municipio.id_municipio=votantes.id_municipio
INNER JOIN departamento on departamento.id_departamento = municipio.id_departamento
INNER JOIN zona on zona.id_zona = departamento.id_zona
INNER JOIN partido on partido.partido = votantes.partido
where votantes.raza != 'indigenas' and zona.nombre_pais=pais and zona.nombre_region = region
group by zona.nombre_pais, zona.nombre_region
ORDER BY 1 DESC LIMIT 1
);

--Consulta 5

SELECT d.nombre_departamento,
       ROUND(SUM(CASE WHEN v.sexo = 'mujeres' THEN v.universitarios ELSE 0 END) / 
             SUM(CASE WHEN v.sexo = 'mujeres' THEN v.analfabetos + v.alfabetos ELSE 0 END) * 100, 2) AS porcentaje_mujeres_universitarias,
       ROUND(SUM(CASE WHEN v.sexo = 'hombres' THEN v.universitarios ELSE 0 END) / 
             SUM(CASE WHEN v.sexo = 'hombres' THEN v.analfabetos + v.alfabetos ELSE 0 END) * 100, 2) AS porcentaje_hombres_universitarios
FROM votantes v
JOIN municipio m ON v.id_municipio = m.id_municipio
JOIN departamento d ON m.id_departamento = d.id_departamento
WHERE v.universitarios > 0
GROUP BY d.nombre_departamento
HAVING porcentaje_mujeres_universitarias > porcentaje_hombres_universitarios;

--Consulta 6 (esta esta mala)

SELECT p.nombre_pais,
       z.nombre_region,
       ROUND(SUM(v.analfabetos + v.alfabetos) / COUNT(DISTINCT d.id_departamento), 2) AS promedio_votos
FROM votantes v
JOIN municipio m ON m.id_municipio = v.id_municipio
JOIN departamento d ON d.id_departamento = m.id_departamento
JOIN zona z ON z.id_zona = d.id_zona
JOIN pais p ON p.nombre_pais = z.nombre_pais
GROUP BY p.nombre_pais, z.nombre_region;

--Consulta 7

SELECT z.nombre_pais,
       v.raza,
       ROUND(SUM(v.analfabetos + v.alfabetos) / total_votos * 100, 2) AS porcentaje_votos
FROM votantes v
JOIN municipio m ON v.id_municipio = m.id_municipio
JOIN departamento d ON m.id_departamento = d.id_departamento
JOIN zona z on z.id_zona = d.id_zona
JOIN (
    SELECT zona.nombre_pais, SUM(analfabetos + alfabetos) AS total_votos
    FROM votantes
    JOIN municipio ON municipio.id_municipio = votantes.id_municipio
	JOIN departamento ON departamento.id_departamento = municipio.id_departamento
    JOIN zona on zona.id_zona = departamento.id_zona
    GROUP BY zona.nombre_pais
) AS totales ON z.nombre_pais = totales.nombre_pais
GROUP BY z.nombre_pais, v.raza;

--Consulta 8

SELECT porcentajes_por_partido.nombre_pais,
       MAX(porcentaje_votos) AS porcentaje_maximo,
       MIN(porcentaje_votos) AS porcentaje_minimo,
       MAX(porcentaje_votos) - MIN(porcentaje_votos) AS diferencia_porcentajes
FROM (
    SELECT z.nombre_pais,
           p.nombre_partido,
           ROUND(SUM(v.analfabetos + v.alfabetos) / SUM(t.total_votos) * 100, 2) AS porcentaje_votos
    FROM votantes v
    JOIN partido p ON v.partido = p.partido
    JOIN municipio m ON m.id_municipio = v.id_municipio
    JOIN departamento d ON d.id_departamento = m.id_departamento
    JOIN zona z ON z.id_zona = d.id_zona
    JOIN (
        SELECT id_municipio, SUM(analfabetos + alfabetos) AS total_votos
        FROM votantes
        GROUP BY id_municipio
    ) AS t ON v.id_municipio = t.id_municipio
    GROUP BY z.nombre_pais, p.nombre_partido, t.total_votos
) AS porcentajes_por_partido
GROUP BY porcentajes_por_partido.nombre_pais;

--Consulta 9
SELECT p.nombre_pais, 
       ROUND(SUM(v.analfabetos) / SUM(v.analfabetos + v.alfabetos) * 100, 2) AS porcentaje_analfabetas
FROM votantes v
JOIN municipio m ON m.id_municipio = v.id_municipio
JOIN departamento d ON d.id_departamento = m.id_departamento
JOIN zona z ON z.id_zona = d.id_zona
JOIN pais p ON p.nombre_pais = z.nombre_pais
GROUP BY p.nombre_pais
ORDER BY porcentaje_analfabetas DESC
LIMIT 1;

--Consulta 10

SELECT d.nombre_departamento, SUM(v.analfabetos + v.alfabetos) AS votos_obtenidos
FROM votantes v
JOIN municipio m ON m.id_municipio = v.id_municipio
JOIN departamento d ON d.id_departamento = m.id_departamento
JOIN zona z ON z.id_zona = d.id_zona
JOIN pais p ON p.nombre_pais = z.nombre_pais
WHERE p.nombre_pais = 'Guatemala'
GROUP BY d.nombre_departamento
HAVING votos_obtenidos > (
    SELECT SUM(v.analfabetos + v.alfabetos)
    FROM votantes v
    JOIN municipio m ON m.id_municipio = v.id_municipio
    JOIN departamento d ON d.id_departamento = m.id_departamento
    JOIN zona z ON z.id_zona = d.id_zona
    JOIN pais p ON p.nombre_pais = z.nombre_pais
    WHERE p.nombre_pais = 'Guatemala' AND d.nombre_departamento = 'Guatemala'
)
ORDER BY votos_obtenidos DESC;





