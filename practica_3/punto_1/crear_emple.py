import os
import random


def primo(num):
    for x in range(2, num):
        if num % x == 0:
            return False
    return True


nombre_arch = "empleados.txt"
ruta_completa = os.path.join(os.getcwd(), nombre_arch)

archivo = open(ruta_completa, 'w', encoding='utf-8')

numeros = [x for x in range(50)]
nombres_r = ["Juan", "Hernan", "Maria", "Jose", "German", "Ricardo"]
apellidos_r = ["Garmendia", "Acosta", "Morales", "Barroso", "Núñez", "García"]

for num in range(50):
    indice = random.randrange(len(numeros))
    numero_emple = numeros.pop(indice)

    edad = random.randint(18, 80)
    if primo(numero_emple):
        dni = 00
    else:
        dni = numero_emple + 3000
    nombre = nombres_r[random.randrange(len(nombres_r))]
    ape = apellidos_r[random.randrange(len(apellidos_r))]

    archivo.write(str(numero_emple) + ' ' + str(edad) + ' ' + str(dni)
                  + '\n' + nombre + '\n' + ape + '\n')

archivo.close()
