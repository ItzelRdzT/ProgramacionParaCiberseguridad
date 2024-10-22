#API IP ABUSE DATABASE
import logging
import requests
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
url= "https://api.abuseipdb.com/api/v2/check"
#AQUÍ SE INGRESA LA URL EN ESTA CASO ES UNA YA PROPORCIONADA
api_key="8814413cd22d6467db4d1cdb1c1bb5e6661d6b9c9b8d1672826df996a0d95ca66a8d6ff2b1e74eaa"
#SE INGRESA EL API KEY, EN ESTA OCASIÓN SE ELIGIO UNA PREDETERMINADA
def busqueda_ip(ip):
    headers = {
    'Accept': 'application/json',
    'Key': api_key
    }
#CREAMOS EL DICCIONARIO HEADERS, 'ACCEPT' RECIBE UNA RESPUESTA EN FORMATO JSON
#Y 'KEY' AUTENTICA LA SOLICITUD
    params = {
        'ipAddress': ip,
        'maxAgeInDays': 30
        }
#CREAMOS EL DICCIONARIO PARAMS, 'IPADDRESS' SE ENCUENTRA LA DIRECCIÓN IP QUE SE QUIERE BUSCAR
#'MAXAGEINDAYS' PONE UN LIMITE DE 30 DÍAS PARA EL INGRESO DE INFORMACIÓN
    response = requests.get(url, headers=headers, params=params)
#RESPONSE ALMACENA INFORMACIÓN DE LA URL, DONDE TAMBIEN SE LLAMAN LA INFORMACIÓN DE LOS 2 DICCIONARIOS HECHOS
    if response.status_code == 200:
        logging.info("TODO SALIÓ DE FORMA EXITOSA")
        return response.json()
#SI EL STATUS DE RESPONSE ES UN 200 EL CODIGO FUNCIONA Y SE LOGRA LLAMAR A LA API REGRESANDO ESTA INFORMACIÓN EN FORMATO JSON
    else:
        logging.error("HUBO UN ERROR EN LA CONSULTA")
        return None
#SI NO SE MARCA 200 ENTONCES NO SE PUDO REALIZAR UNA CONEXIÓN CON EL API Y NO NOS REGRESARA NADA
def consulta_ip():
    ip=input("INGRESE LA IP QUE BUSCA CONSULTAR: ")
    respuesta=busqueda_ip(ip)
    print("EL RESULTADO DE LA BUSQUEDA: ", respuesta)
    input("Presiona Enter para volver al menú principal...")
#EN ESTA FUNCIÓN SE INGRESA LA IP Y SE MANDA A LLAMAR LA PRIMERA FUNCIÓN Y SE IMPRIMIRA LA RESPUESTA DE LA FUNCIÓN
