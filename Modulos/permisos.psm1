<#
SYNOPSIS
    Nuestro script muestra los permisos que tiene un archivo que son seleccionados especificamente
DESCRIPCIÓN
    $DIRECCION: por medio de esta variable el usuario ingresa el directorio del archivo para ver sus permisos
    function Permisos: inicia una función cuyo parametro principal es la variable $Path
    try: es un control de errores que inicia probando si la ruta dada existe por medio del if (-not(Test-DIRECCION $DIRECCION))
    si la ruta no existe entonces se mandara el mensaje "NO EXISTE LA DIRECCIÓN"
    $FILE= Busca la información a traves de la la ruta dada para mostrar una lista con todos los archivos que se encuentren
    en esa dirección
    $RESULT: se almacenan todos los resultados del comando anterior
    foreach ($FILE in $FILES): este ciclo revisa uno a uno los archivos
    $acl= Get-Acl -Path $FILE.FullName: esta variable almacena la lista de control de acceso del archivo que seleccionamos
    foreach ($access in $acl.Access): este ciclo revisa el tipo de acceso de nuestra variable $acl
    $RESULT += [PSCustomObject]@: a la variable $RESULT se le suma un objeto totalmente personalizado y nuevo
    FileName            = $FILE.FullName: Muestra la ruta del archivo
    IdentityReference   = $access.IdentityReference: muestra si el usuario tiene acceso
    FileSystemRights    = $access.FileSystemRights: muestra los derechos que tiene el archivo
    AccessControlType   = $access.AccessControlType: es el tipo de control de acceso que se tiene
    IsInherited         = $access.IsInherited: indica si el acceso es hereditario
    if ($RESULT.Count -eq 0): si el contador del resultado es igual a 0 entonces se mostrara que no se encontró ningun permiso
    si el contador es diferente a 0 entonces en el archivo de la variable $RESULT se creara una tabla con los archivos y los
    permisos
    catch: si se crea un error entonces se mostrara el mensaje que indique que hubo un error en el programa
    PERMISOS -DIRECCION $DIRECCION: este comando nos traera la los permisos en base a la dirección que nosotros otorgamos
#>
$DIRECCION = Read-Host "INGRESA EL DIRECTORIO PARA EL ARCHIVO"
function PERMISOS {
    param (
        [string]$DIRECCION
    )
    
    try {
        if (-not (Test-Path $DIRECCION)) {
            Write-Output "NO EXISTE LA DIRECCIÓN"
            return
        }
        $FILES = Get-ChildItem -Path $DIRECCION -File -Recurse
        $RESULT = @()
        foreach ($FILE in $FILES) {
            $acl = Get-Acl -Path $FILE.FullName
            foreach ($access in $acl.Access) {
                $RESULT += [PSCustomObject]@{
                    FileName            = $FILE.FullName
                    IdentityReference   = $access.IdentityReference
                    FileSystemRights    = $access.FileSystemRights
                    AccessControlType   = $access.AccessControlType
                    IsInherited         = $access.IsInherited
                }
            }
        }
        if ($RESULT.Count -eq 0) {
            Write-Output "NO SE ENCONTRARON PERMISOS"
        } else {
            $RESULT | Format-Table -AutoSize
        }
        
    } catch {
        Write-Output "ERROR: $_"
    }
}
PERMISOS -DIRECCION $DIRECCION