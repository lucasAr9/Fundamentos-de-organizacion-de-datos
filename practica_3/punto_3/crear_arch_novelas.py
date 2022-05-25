import os
import random


nombre_arch = "novelas.txt"
ruta_completa = os.path.join(os.getcwd(), nombre_arch)

numeros_r = [x for x in range(50)]
genero_r = ["terror", "comedia", "drama", "ciencia ficción"]
pelis_r = ["Aftermath", "Prey", "The Batman", "TLOTR", "Spider-Man", "ñarña"]
director_r = ["Garmendia", "Acosta", "Morales", "Barroso", "Núñez", "García"]

archivo = open(ruta_completa, 'w', encoding='utf-8')

archivo.write(str(0) + ' ' + str(0) + ' ' + str(0)
                  + '\n' + 'n' + '\n' + 'n' + '\n' + 'n' + '\n')

for num in range(20):
    indice = random.randrange(len(numeros_r))
    codigo = numeros_r.pop(indice)

    duracion = random.randint(30, 120)
    
    precio = random.randint(100, 200)

    genero = genero_r[random.randrange(len(genero_r))]
    
    nombre = pelis_r[random.randrange(len(pelis_r))]

    director = director_r[random.randrange(len(director_r))]

    archivo.write(str(codigo) + ' ' + str(duracion) + ' ' + str(precio)
                  + '\n' + genero + '\n' + nombre + '\n' + director + '\n')

archivo.close()
