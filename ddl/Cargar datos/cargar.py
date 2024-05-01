import mysql.connector
import csv

mydb = mysql.connector.connect(
  host="localhost",
  user="hugoarana89",
  password="201504070",
  database="proyecto"
)

mycursor = mydb.cursor()
'''mycursor.execute("show databases")
for x in mycursor:
    print(x)'''


def insertar(NOMBRE_ELECCION,AÑO_ELECCION,PAIS,REGION,DEPTO,MUNICIPIO,PARTIDO,NOMBRE_PARTIDO, \
             SEXO,RAZA,ANALFABETOS,ALFABETOS,SEXO2,RAZA2,PRIMARIA,NIVEL_MEDIO,UNIVERSITARIOS):
    sql = "INSERT INTO temporal (NOMBRE_ELECCION,AÑO_ELECCION,PAIS,REGION,DEPTO,MUNICIPIO,PARTIDO,NOMBRE_PARTIDO, \
             SEXO,RAZA,ANALFABETOS,ALFABETOS,SEXO2,RAZA2,PRIMARIA,NIVEL_MEDIO,UNIVERSITARIOS) VALUES \
                (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
    val = NOMBRE_ELECCION,AÑO_ELECCION,PAIS,REGION,DEPTO,MUNICIPIO,PARTIDO,NOMBRE_PARTIDO, \
             SEXO,RAZA,ANALFABETOS,ALFABETOS,SEXO2,RAZA2,PRIMARIA,NIVEL_MEDIO,UNIVERSITARIOS
    
    mycursor.execute(sql, val)
    mydb.commit()
    print(mycursor.rowcount, "record inserted.")


def leer_csv(nombre_archivo):
    try:
        with open(nombre_archivo, 'r', newline='', encoding="utf-8") as archivo_csv:
            for index, linea in enumerate(archivo_csv):
                if index != 0:
                    comas = linea.split(',')
                    insertar(comas[0], comas[1], comas[2], comas[3], comas[4], comas[5], comas[6], comas[7], comas[8], comas[9], \
                             comas[10], comas[11], comas[12], comas[13], comas[14], comas[15], comas[16])

    except FileNotFoundError:
        print(f"El archivo '{nombre_archivo}' no existe.")



leer_csv('datos.csv')