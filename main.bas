#include "cpu_t.bi"
#include "graphics.bi"

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

Sub Main()
	Cls
	
	Dim As String FilePath = Command(1)
	
	If FilePath = "" Then
		Print "Uso: Narval.exe <Ruta a ROM>"
		Stop
	End If
	
	Dim Buffer As UByte Ptr
	Dim FileLength As Long = ReadFileBytes(FilePath, Buffer)
	
	Dim CPU As CPU_T = CPU_T(Buffer, FileLength)
	
	GraphicsInit()
	
	Dim As Boolean QuitFlag = False
	Dim As SDL_Event Evt
	
	While Not QuitFlag
		While SDL_PollEvent(@Evt) <> 0
			If Evt.type = SDL_QUIT_ Then
				QuitFlag = True 
			End If
		Wend
		
		CPU.Cycle()
		Sleep(16)
	Wend
	
	GraphicsQuit()
End Sub

Main
