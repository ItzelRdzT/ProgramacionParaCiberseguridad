#Modulos que necesitaremos para nuestro script
import hashlib
from virus_total_apis import PublicApi
import logging
 
###Equipo8###
 
#Configuracion del logging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(levelname)s - %(message)s'
)
#En esta unica funcion tomaremos la API de VirusTotal donde analizaremos si existe algun malware en nuestros archivos.
def api_archive():
    try:
        logging.info('En este script analizaremos los archivos de la carpeta donde nos encontramos, usando un API llamada VirusTotal')
        logging.info('Script creado por el equipo 8')
 
        #API-KEY personal 
        api_key = '191cc16e7cd5d7b19fed80bcbcd4a6b5560c6c49958b8f87d80dc857f031b8fb'
        api = PublicApi(api_key)
        #Se solicita un reporte y se registra la respuesta de la api
        logging.info('El archivo debe estar en la misma carpeta que este script.')
        archive = input("Escribe el nombre del archivo que quieras analizar:")
        logging.debug(f"Archivo ingresado: {archive}")
 
        #Validacion del nombre del archivo 
        if archive.isnumeric():
            logging.warning('El archivo debe contener letras y números')
            return
        #El programa lee el archivo y calcula su hash
        with open(archive, "rb") as file:
            file_hash = hashlib.md5(file.read()).hexdigest()
        logging.debug(f"Hash del archivo: {file_hash}")
 
        #En esta parte solicitamos la respuesta de la API
        response = api.get_file_report(file_hash)
        logging.debug(f"Respuesta de la API: {response}")
 
        #Aqui se verifica la respuesta de la API, se iguala a 200 y si llega a ser mayor a 0 lo registra como malicioso
        if response["response_code"] == 200:
            if response["results"]["positives"] > 0:
                logging.info("Detectamos un archivo malicioso.")
            else:
                logging.info("El archivo es seguro.")
        #Si no se ejecuta bien nos manda un mensaje de error. 
        else:
            logging.error("No se pudo realizar el análisis correctamente.")
    except (RuntimeError, FileNotFoundError) as e:
        logging.critical(f"El programa no ha podido ejecutarse. Error: {e}")
    input("Presiona Enter para volver al menú principal...")
api_archive()
