#include "utils.bi"

' Duerme la ejecución por la cantidad de microsegundos indicada en @microseconds
Sub MicroSleep(microseconds As ULong)
	Dim t1 As Double = Timer
	Dim t2 As Double = t1
	Dim target As Double = microseconds / 1000000.0 ' Convertir a segundos

	Do
		t2 = Timer
	Loop While (t2 - t1) < target
End Sub

' Lee los bytes del fichero cuyo nombre es indicado por @FilePath al búfer @Buffer
Function ReadFileBytes(ByRef FilePath As String, ByRef Buffer As UByte Ptr) As Long
	Dim FileHandle As Integer
	Dim FileSize As Long
	
	' Abrir el archivo en modo binario
	FileHandle = FreeFile
	Open FilePath For Binary As #FileHandle
	
	' Obtener el tamaño del archivo
	FileSize = LOF(FileHandle)
	
	' Reservar memoria para el buffer
	Buffer = Allocate(FileSize)
	
	' Leer el archivo completo en el buffer
	Get #FileHandle, , *Buffer, FileSize
	
	' Cerrar el archivo
	Close #FileHandle
	
	Return FileSize
End Function

' Obtiene la dirección del fichero / primer argumento de la aplicación
Function GetFilePath() As String
	Dim FilePath As String

    If Command(2) = "" Then
        Print "Uso: Narval.exe <--Mode> <Ruta a ROM> <Frecuencia de emulacion>"
        Stop
    End If
    
    FilePath = Command(2)
    Print "Archivo cargado: "; FilePath
    
    Return FilePath
End Function

' Obtiene la frecuencia de ejecución del intérprete / segundo argumento de la aplicación
Function GetFrequency() As Long
	Dim Frequency As Long
	
	If Command(3) = "" Then
		Print "Uso: Narval.exe <--Mode> <Ruta a ROM> <Frecuencia de emulacion>"
		Stop
	End If
	
	Frequency = CInt(Command(3))
	Print "Frecuencia: "; Frequency ; "Hz"
	
	Return Frequency
End Function
