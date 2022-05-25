import os
import random


nombre_archivo = "empleados.txt"
ruta_empleados = os.path.join(os.getcwd(), nombre_archivo)

archivo_aumentos = "aumentos.txt"
ruta_aumentos = os.path.join(os.getcwd(), archivo_aumentos)

with open(ruta_empleados, 'w', encoding='utf-8') as emple:
    for i in range(1, 21):
        for j in range(1, 4):
            emple.write(str(i) + ' ')                       # departamento
            emple.write(str(j) + ' ')                       # division
            emple.write(str(random.randrange(100)) + ' ')   # numero de empleado
            emple.write(str(random.randrange(15) + 1) + ' ')  # categoria
            emple.write(str(random.randrange(30)) + '\n')    # horas extras

with open(ruta_aumentos, 'w', encoding='utf-8') as aume:
    for i in range(15):
        aume.write(str(random.randrange(1000)) + '\n')
