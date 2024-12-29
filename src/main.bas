#include "cpu_t.bi"
#include "graphics.bi"
#include "utils.bi"

Dim Shared As UByte KeyMap(15)

' Carga el layout del teclado en el array KeyMap()
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

' Sub de emulación
Sub Emulate
	Dim FilePath As String = GetFilePath
	Dim Frequency As Long = GetFrequency
	
	Sleep(1000)

	Cls
	
	' Declaración del búfer donde se almacenará el contenido del fichero (ROM)
	Dim Buffer As UByte Ptr
	Dim FileLength As Long = ReadFileBytes(FilePath, Buffer)
	
	' Inicialización del CPU
	Dim CPU As CPU_T = CPU_T(Buffer, FileLength)
	
	' Inicialización de gráficos
	GraphicsInit
		
	Dim As Boolean QuitFlag = False
	Dim As SDL_Event Evt
	
	' Carga del keymap
	LoadKeymap
	
	/' 
	Mientras que la quitFlag sea falsa, se cargan los eventos en Evt.
	Si el evento es SDL_QUIT_ (se clica en la X de la ventana) se cierra el programa.
	Tras el switch de eventos, se realiza un ciclo de emulación con la frecuencia indicada
	'/
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
	
	' Finalización de gráficos
	GraphicsQuit()
End Sub

' Subrutina principal de la aplicación
Sub Main
	Cls
	
	Dim As String Mode = Command(1)
	Select Case Mode
	Case "--emulate" : Emulate
	Case "--disassemble"
		
	Case Else
		Print "Uso: Narval.exe <--Modo> <Ruta a ROM> <Frecuencia de emulacion>"
		Stop
	End Select
End Sub

' Entrypoint
Main
