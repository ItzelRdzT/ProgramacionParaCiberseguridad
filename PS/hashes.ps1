<#.Synopsis
Script para mostrar los hashes de archivos, mandarlos a un api y ver si tiene contenido malicioso

.Descripcion
Este script pregunta al ususario una ruta del directorio que contenga archivos para despues mandarlos al api de VirusTotal y verificar si hay algun archivo malicioso

.FUNCION funcion llamada get-maliciousfiles

.Variable RutaArch
Variable para guardar el directorio del usuario

.Lista archivosconvirus
Creo una lista vacia para despues agregar los archivos que salgan maliciosos

.1 CONDICIONAL IF con test-path evaluo que la variable $RutaArch sea un directorio con el comando Container, al final si no es directorio mostrar un mensaje en pantalla

.CICLO FOR get-childitem obtiene todos los archivos del directorio y -file para poder trabajar solo con archivos

.Variable hash Get-filehash nos permite calcular el hash del archivo que se encuentra en la variable $file

.HEADERS encabezados http para la solicitud de VirusTotal donde se encuentra el apikey y el tranformado a json

.VARIABLE URL variable para la consulta de VirusTotal

.TRY Lo utilizo para cualquier error de conexion que haya en la respuesta del api, donde en el catch muestro el mensaje y ErrorAction stop para parar la ejecucion

.VARIABLE RESPONSE  Variable con el comando Invoke-restmethod con la ruta para la consulta del api

.2 CONDICIONAL IF condicional con la variable $response com arumento que trae la respuesta de la consulta del api

.VARIABLE DETECCION Y HASHVIRUS variable deteccion utilizada para analizar la respuesta de la api con propiedades para hacer el analisis mas detallado sobre los archivos maliciosos
variable hash con el valor false de tipo booleano para poder usarlo en condicional mas adelante

.2 CICLO FOR ciclo con las variable $file2 en deteccion.keys(keys es una propiedad para obtener una coleccion de diccionario donde representa cada nombre del antivirus)

.3 CONDICIONAL IF  con el comando $deteccion iterando sobre el comando de $file2 que obtiene cada deteccion del archivo, buscamos coincidir con la categoria malicious. Esto con el fin 
de cambiar la variable hashvirus a true para poder saber si hay un archivo malicioso

.4 CONDICIONAL IF como argumento hashvirus en  caso de ser true, entrara a la condicion y agregara los elementos con "PSCustomObject" para almacenarlos en la lista que declaramos
vacia al inicio 

.VARIABLE HASH  en caso de ser falso este if se mostrara una trabla del hash del archivo

.IMPRESION DE LOS ARCHIVOS MALICIOSOS con un if como argumento la lista donde se encuentran los archivos maliciosos, contamos los archivos que hay en la lista con la propiedad y el parametro gt sea mayor de 0


.3 CICLO FOR como parametro Archivo en la lista archivosConVIrus iteramos sobre cada archivo malicioso para poder mostrarlo en pantalla 

.ELSE DEL CONDICIONAL 4 en caso de que la lista traiga 0 archivos maliciosos, se mostrara un mensaje que diga que no se encontro ningun archivo malicioso.
#>

function Get-maliciousfiles{
    $RutaArch = Read-Host "Introduzca la ruta del archivo"

    # Lista para almacenar archivos con virus
    $archivosConVirus = @()


    if (test-path -Path $RutaArch -PathType Container){
    
            foreach ($file in Get-ChildItem $RutaArch -file) {
                    # Calcula el hash del archivo
                    $hash = Get-FileHash -Path $file.PSPath -Algorithm SHA256

                    # Configura los encabezados de la solicitud
                    $headers = @{
                        "x-apikey" = "be42e13ff723e85b2d74f2f98ed37eaf94edd15e65b7e527c4075329c5d1ec10"
                        "Accept"   = "application/json"
                    }

                    # URL para la consulta en VirusTotal
                    $url = "https://www.virustotal.com/api/v3/files/$hash"

                    # Envía la solicitud a la API de VirusTotal
                    try {
                        $response = Invoke-RestMethod -Uri 'https://www.virustotal.com/api/v3/search?query=%24hash' -Method GET -Headers $headers

                        if ($response) {
                            # Verifica si hay detecciones de virus
                            $deteccion = $response.data.attributes.last_analysis_results
                            $hashVirus = $false

                            foreach ($file2 in $deteccion.Keys) {
                                if ($deteccion[$file2].category -eq "malicious") {
                                    $hashVirus = $true
                                    break
                                }
                            }

                            if ($hashVirus) {
                                # Añade el archivo a la lista si se detectó un virus
                                $archivosConVirus += [PSCustomObject]@{
                                    FilePath = $file.fullname
                                    Hash     = $hash.hash
                                }
                            } else {
                                $hash | Format-Table
                   
                            }
                        } else {
                            Write-Host "No se encontró información para el archivo con hash $hash."
                        }
                    } catch {
                        Write-Error "$($_.Exception.Message)" -ErrorAction Stop
                    }

            }
    }else {
        Write-Host "El directorio no es valido"
    }
     # Imprime un resumen de los archivos con virus
    if ($archivosConVirus.Count -gt 0) {
        Write-Host "Archivos detectados como maliciosos:"
        foreach ($archivo in $archivosConVirus) {
            Write-Host "Ruta: $($archivo.filepath)"
            Write-Host "Hash: $($archivo.hash)"
        }
    } else {
        Write-Host "No se detectaron archivos maliciosos." -ForegroundColor Green
    }
}

Get-maliciousfiles