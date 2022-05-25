import os
import random

prendas = 'prendas.txt'
ruta_archivo = os.path.join(os.getcwd(), prendas)

prendas = 'prendas_obsoletas.txt'
ruta_archivo2 = os.path.join(os.getcwd(), prendas)

# crear archivo de prendas
codigos_r = [x for x in range(50)]
descripcion_r = ['buena ropa', 'mala calidad', 'no se que ropa es', 'una descripcion']
colores_r = ['rojo', 'verde', 'azul', 'violeta']
tipo_prenda_r = ['zapatillas', 'pantalon', 'remera', 'medias', 'gorra']

with open(ruta_archivo, 'w', encoding='utf-8') as pre:
    for i in range(50):
        indice = random.randrange(len(codigos_r))
        codigo = codigos_r.pop(indice)

        stock = random.randrange(50)

        precio = float(random.randrange(500))

        descripcion = descripcion_r[random.randrange(len(descripcion_r))]

        color = colores_r[random.randrange(len(colores_r))]

        tipo = tipo_prenda_r[random.randrange(len(tipo_prenda_r))]

        pre.write(str(codigo) + ' ' + str(stock) + ' ' + str(precio) + '\n'
                  + descripcion + '\n' + color + '\n' + tipo + '\n')

# codigos de las prendas obsoletas
codigos_r = [x for x in range(50)]

with open(ruta_archivo2, 'w', encoding='utf-8') as pre:
    for i in range(20):
        indice = random.randrange(len(codigos_r))
        codigo = codigos_r.pop(indice)

        pre.write(str(codigo) + '\n')
