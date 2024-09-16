<#
SYNOPSIS
    ESTE SCRIPT FUNCIONA COMO UN MENU PARA PODER ELEGIR 1 DE LOS 4 MODULOS HECHOS
DESCRIPCIÓN
    function hashes: esta función importa el modulo que analiza los hashes
    function oculto: esta función importa el modulo que muestra las funciones ocultas de los componentes de la computadora
    function sistemas: esta función importa el modulo que manda los hashes a un api
    function op: esta función importa el modulo que muestra los permisos otorgados a un archivo
    Ciclo While: Se ciclará hasta que el usuario le de a la opción de salir.
    $ELECCIÓN = Read-Host "INTRODUCE UNA OPCIÓN": con esto el usuario puede ingresar de forma numerica una de las opciones del menú
    SWITCH ($ELECCION){
    "1" {hashes}
    "2" {oculto}
    "3" {sistemas}
    "4" {op}
    "5" {Write-Host "Saliendo del menú principal...}
    default {Write-Output "OPCIÓN NO VALIDA"}
    }: este switch funciona como un if que permite elegir que opción sera seleccionada para que se pueda ejecutar
#>
function hashes{
    try{
        Import-Module -name C:\Users\Noel\Documents\PS\hashes.psm1
        Write-Output "Modulo importado"
        Get-maliciousfiles
    }catch{
        Write-Host "Error:" $_.Exception.Message
    }
}

function oculto{
    try{
        Import-Module -name C:\Users\Noel\Documents\PS\listadoarchivos.psm1
        Write-Output "Modulo importado"
        Get-HiddenFolder -folder $folder
    }catch{
    Write-Host "Error:" $_.Exception.Message
    }
}

function sistemas{
    try{
    Import-Module -name C:\Users\Noel\Documents\PS\recursos.psm1
    Write-Output "Modulo importado"
    Get-Resources
    }catch{
    Write-Host "Error:" $_.Exception.Message
    }
}


function op{
    try{
        Import-Module -name C:\Users\Noel\Documents\PS\permisos.psm1
        Write-Output "Modulo importado"
        PERMISOS
    }catch{
    Write-Host "Error:" $_.Exception.Message
    }
}

$ELECCION = " "
While($ELECCION -ne "5"){
    $ELECCION = Read-Host "Seleccioné la opción: 1.FUNCIÓN HASHES   2.FUNCIÓN ARCHIVOS OCULTOS   3. FUNCIÓN SISTEMAS   4.FUNCIÓN PERMISOS DE LOS ARCHIVOS  5. SALIR DEL MENÚ"
    SWITCH ($ELECCION){
        "1" {hashes}
        "2" {oculto}
        "3" {sistemas}
        "4" {op}
        "5" {write-host "Saliendo del menú principal..."}
        default {Write-Output "OPCIÓN NO VALIDA"}
    }
}