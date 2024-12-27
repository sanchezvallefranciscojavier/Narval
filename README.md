# NARVAL
<div style="text-align: center;">
    <img src="Assets/IMG/Narval.jpg" alt="Descripción" style="width: 200px; height: 200px; border-radius: 25%;"/>
</div>

## Emulador / Intérprete de Chip8
**Narval** es un intérprete de código máquina para Chip8 programado en BASIC.  

Uso:
```cmd
Narval.exe <Ruta a la ROM> <Frecuencia>
```

Compilación:
```cmd
BUILD.bat
```

En este momento no está contemplada la compilación en Linux, aunque el programa debería ser completamente compatible.

Una vez compilado el programa, se guardará en la carpeta "Target" el binario generado.  
Es necesario tener la librería SDL2.dll tanto en la raíz del programa (donde se encuentra BUILD.bat) como en la carpeta "Target".