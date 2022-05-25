import os
import random

nombre_arch = "accesos.txt"
ruta_completa = os.path.join(os.getcwd(), nombre_arch)

archivo = open(ruta_completa, 'w', encoding='utf-8')

for a in range(10, 21):
    anio = 2000 + a
    for m in range(1, 13):
        mes = m
        for d in range(1, 31):
            dia = d
            for i in range(20):
                id = random.randrange(3000) + 20
                tiempo = random.randrange(400)
                archivo.write(str(anio) + ' ' + str(mes) + ' ' + str(dia)
                              + ' ' + str(id) + ' ' + str(tiempo) + '\n')

archivo.close()
