<#
Synopsis.
Esté script muestra los archivos ocultos de cualquier carpeta que esté en nuestro dispositivo, basta con solo insertar el nombre de la carpeta

Description.
El comando set-strictmode -Version 2.0 genera un error si se intenta usar una variable no inicializada y si se intenta acceder a una propiedad
que no existe en un objeto
Se crea una variable llamada $folder donde se guardará el nombre de la carpeta que queremos revisar, con el comando Get-ChildItem obtenemos los 
elementos de nuestra carpeta y con el parámetro Hidden se buscará todos los archivos ocultos de nuestra carpeta y los mandará a llamar en formato
lista, si ocurre una excepción entonces mandará un mensaje de error.
El condicional if nos dice que si existe algun archivo oculto entonces nos desplegará los archivos ocultos, si no existe ninguno entonces nos manda
un mensaje diciendonos que no se encontraron archivos ocultos en la carpeta.

Notes.
Autores: Equipo 8
PIA 1E
Listado de archivos ocultos en una carpeta predeterminada

#>
Set-StrictMode -Version 2.0


function Get-HiddenFolder {
    param (
        [string]$folder
    )

    try {
        $folder = Read-Host "Ingrese la carpeta que quiere revisar"
        $hidden = Get-ChildItem $folder -Hidden -ErrorAction "Stop"
        if ($hidden) {
            Write-Host "Archivos ocultos encontrados:"
            $hidden | Format-List
            } else {
            Write-Host "No se encontraron archivos ocultos en la carpeta."
        }
    } catch {
        Write-Host "Error:" $_.Exception.Message
    }
}

Get-HiddenFolder -folder $folder