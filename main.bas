#include "cpu_t.bi"
#include "graphics.bi"

Dim Shared As UByte KeyMap(15)

Sub MicroSleep(microsegundos As ULong)
	Dim t1 As Double = Timer
	Dim t2 As Double = t1
	Dim target As Double = microsegundos / 1000000.0 ' Convertir a segundos

	Do
		t2 = Timer
	Loop While (t2 - t1) < target
End Sub

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

    If Command(1) = "" Then
        Print "Uso: Narval.exe <Ruta a ROM> <Frecuencia de emulación>"
        Stop
    End If
    
    FilePath = Command(1)
    Print "Archivo cargado: "; FilePath
    
    Return FilePath
End Function

Function GetFrequency() As Long
	Dim Frequency As Long
	
	If Command(2) = "" Then
		Print "Uso: Narval.exe <Ruta a ROM> <Frecuencia de emulación>"
		Stop
	End If
	
	Frequency = CInt(Command(2))
	Print "Frecuencia: "; Frequency ; "Hz"
	
	Return Frequency
End Function

Sub LoadKeymap()
	KeyMap(0) = SDLK_x
	KeyMap(1) = SDLK_1
	KeyMap(2) = SDLK_2
	KeyMap(3) = SDLK_3
	KeyMap(4) = SDLK_q
	KeyMap(5) = SDLK_w
	KeyMap(6) = SDLK_e
	KeyMap(7) = SDLK_a
	KeyMap(8) = SDLK_s
	KeyMap(9) = SDLK_d
	KeyMap(&hA) = SDLK_z
	KeyMap(&hB) = SDLK_c
	KeyMap(&hC) = SDLK_4
	KeyMap(&hD) = SDLK_r
	KeyMap(&hE) = SDLK_f
	KeyMap(&hF) = SDLK_v
End Sub
	
Sub Main()
	Cls
	
	Dim FilePath As String = GetFilePath
	Dim Frequency As Long = GetFrequency
	
	Sleep(1000)

	Cls
	
	Dim Buffer As UByte Ptr
	Dim FileLength As Long = ReadFileBytes(FilePath, Buffer)
	
	Dim CPU As CPU_T = CPU_T(Buffer, FileLength)
	
	GraphicsInit
		
	Dim As Boolean QuitFlag = False
	Dim As SDL_Event Evt
	
	LoadKeymap
	
	While Not QuitFlag
		While SDL_PollEvent(@Evt) <> 0
			Select Case Evt.type
			Case SDL_QUIT_
				QuitFlag = True
			Case SDL_KEYDOWN
				If Evt.key.keysym.sym = SDLK_ESCAPE Then
					QuitFlag = True 
				End If
				
				For Index As Integer = 0 To KEYPAD_SIZE
					If Evt.key.keysym.sym = KeyMap(Index) Then
			            CPU.Keypad(Index) = True
			        End If
				Next
			Case SDL_KEYUP
				For Index As Integer = 0 To KEYPAD_SIZE
					If Evt.key.keysym.sym = KeyMap(Index) Then
			            CPU.Keypad(Index) = False
			        End If
				Next
			Case Else
				
			End Select
		Wend
		
		CPU.Cycle()
		MicroSleep(1000000 / Frequency)
	Wend
	
	GraphicsQuit()
End Sub

Main
