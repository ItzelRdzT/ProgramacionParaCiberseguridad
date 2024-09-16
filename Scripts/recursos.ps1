<#
synopsis.
Este script es para que el usuario pueda conocer la informacion acerca de los siguientes componentes:
-Uso del procesador de la computadora
-Uso de la memoria de la computadora
-Uso del disco duro de la computadora 
-Las estadisticas de la red en la que está conectada la computadora


Description.
El comando set-strictmode -Version 3.0 genera un error si se intenta usar una variable no inicializada, si se intenta acceder a una propiedad
que no existe en un objeto y si se intenta usar alguna variable que no ha sido declarada en el script.
El script es un menú donde el usuario podrá acceder a través de los números del 1-5
Del 1-4 tiene una funcion y el número 5 es el que cierra el programa al momento de ejecutarse"

La función uso-procesador es la encargada de conocer que tanto espacio hemos usado de nuestro procesador
La función uso-memoria es la encargada de dar a conocer el uso de la memoria total y la memoria fisica libre
La función uso-disco es la encargada de dar a conocer la información de los discos lógicos del sistema, el id, el tamaño total y el espacio libre
La función uso-red nos muestra las estadisticas de red y el uso de este.

Notes.
Autores: Equipo 8 
PIA 1E
Revisión de uso de recursos del sistema


Example. 
Las funciones read-proccesor, read-disk, read-memory y read-network contienen un manejo de errores donde en la parte de "try" se crea una variable en el cual se guardará
toda la información del uso del recurso que deseamos revisar. Si llega a haber una excepción, imprimirá un mensaje de error.

Example. 
El switch es el encargado de poder crear el menú, antes de poder compartir alguna información primero le pide al usuario que escoga un número que esté
dentro de 1-4 y desplegará la información de dicho número. 
El número 5 es el encargado de que se salga del menú.
La opción default se encarga de mandarle un mensaje al usuario que dice que no existe esa opción

Example.
El ciclo while se encarga de que se seguirá ejecutando el menú hasta que el usuario le de a la opción 5, el "-ne" significa "not equal" o "no igual"
y basicamente le dice al código que mientras no sea 5, seguirá ciclandose
#>
Set-strictmode -Version 3.0
function Get-Proccesor{
    try{
        $processor= Get-WmiObject -Class Win32_Processor | Select-Object -Property Name, NumberOfCores, MaxClockSpeed
        Write-Host "El uso del procesador es:"
            $processor| format-table -autosize
            
    }Catch{
        write-Host "Error:" $_.Exception.Message
        }
}


function Get-Memory{
    try{
        $memory= Get-WmiObject -Class Win32_OperatingSystem | Select-Object -Property TotalVisibleMemorySize, FreePhysicalMemory
        Write-Host "El uso del memoria es:"
            $memory | format-table -autosize
    }Catch{
        write-Host "Error:" $_.Exception.Message
    }
}

function Get-Disk{
    try{
        $disk= Get-WmiObject -Class Win32_LogicalDisk | Select-Object -Property DeviceID, Size, FreeSpace
        Write-Host "El uso del disco es:"
            $disk | format-table -autosize
         }Catch{
            write-Host "Error:" $_.Exception.Message
        }
}


function Get-Network{
    try{
        $network= Get-NetAdapterStatistics
        Write-Host "El uso del red es:"
            $network  | format-table -autosize
         }Catch{
            write-Host "Error:" $_.Exception.Message
        }
}

function Get-Resources{
    $opc=" "
     while($opc -ne "5"){
        $opc= Read-Host -Prompt '¿Qué desea hacer? [1] Ver el uso del procesador [2] Ver el uso de la memoria [3] Ver el uso del disco [4] Ver el uso de la red [5] Salir' 
        switch ($opc){
            1{
                Get-Proccesor
            }
            2{
                Get-Memory
            }
            3{
                Get-Disk
            }
            4{
                Get-Network
            }5{
                Write-Host "Saliendo del menú..."; break
                }
            default { Write-Host "No existe está opción, intentelo de nuevo"
             }
        }
    }  
}   