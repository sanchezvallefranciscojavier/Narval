@echo off

REM Archivo por lotes para la construcción del ejecutable del programa

CLS

WHERE /Q fbc

IF ERRORLEVEL 1 (
    ECHO "Error! El compilador de FreeBASIC no existe en el PATH. Pulse una tecla para salir"
    PAUSE
    EXIT
)

ECHO "Construyendo ejecutable"
fbc -m main src/cpu_t.bas src/instructions.bas src/graphics.bas src/main.bas -x Narval.exe
ECHO "Ejecutable construido correctamente. Pulse una tecla para salir"
PAUSE
EXIT