@echo off

REM Archivo por lotes para la construcción del ejecutable del programa

CLS

WHERE /Q fbc

IF ERRORLEVEL 1 (
    ECHO "Error! El compilador de FreeBASIC no existe en el PATH. Pulse una tecla para salir"
    PAUSE
    EXIT
)

IF NOT EXIST ".\Target" (
    MD Target
)

ECHO "Construyendo ejecutable"
fbc -m main appicon.rc src/cpu_t.bas src/instructions.bas src/graphics.bas src/utils.bas src/disassembler.bas src/main.bas -x Target/Narval.exe
ECHO "Ejecutable construido correctamente. Pulse una tecla para salir"
PAUSE
EXIT
