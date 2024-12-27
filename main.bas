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

Function GetFilePath() As String
	Dim FilePath As String

    If Command() = "" Then
        Print "Uso: Narval.exe <Ruta a ROM>"
        Stop
    End If
    
    FilePath = Command(1)
    Print "Archivo cargado: "; FilePath

	Sleep(1000)

	Cls
    
    Return FilePath
End Function

Sub Main()
	Cls
	
	Dim FilePath As String = GetFilePath()
	
	Dim Buffer As UByte Ptr
	Dim FileLength As Long = ReadFileBytes(FilePath, Buffer)
	
	Dim CPU As CPU_T = CPU_T(Buffer, FileLength)
	
	GraphicsInit()
	
	Dim As Boolean QuitFlag = False
	Dim As SDL_Event Evt
	
	While Not QuitFlag
		While SDL_PollEvent(@Evt) <> 0
			Select Case Evt.type
			Case SDL_QUIT_
				QuitFlag = True
			Case Else
				
			End Select
		Wend
		
		CPU.Cycle()
		Sleep(16)
	Wend
	
	GraphicsQuit()
End Sub

Main
