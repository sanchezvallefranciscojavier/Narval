#include "cpu_t.bi"
#include "instructions.bi"
#include "graphics.bi"

Dim Shared As UByte Fonts(0 To FONTSET_SIZE) => _ 'Chip 8 font set
	{&hF0, &h90, &h90, &h90, &hF0, _ ' 0
	&h20, &h60, &h20, &h20, &h70, _ ' 1
	&hF0, &h10, &hF0, &h80, &hF0, _ ' 2
	&hF0, &h10, &hF0, &h10, &hF0, _ ' 3
	&h90, &h90, &hF0, &h10, &h10, _ ' 4
	&hF0, &h80, &hF0, &h10, &hF0, _ ' 5
	&hF0, &h80, &hF0, &h90, &hF0, _ ' 6
	&hF0, &h10, &h20, &h40, &h40, _ ' 7
	&hF0, &h90, &hF0, &h90, &hF0, _ ' 8
	&hF0, &h90, &hF0, &h10, &hF0, _ ' 9
	&hF0, &h90, &hF0, &h90, &h90, _ ' A
	&hE0, &h90, &hE0, &h90, &hE0, _ ' B
	&hF0, &h80, &h80, &h80, &hF0, _ ' C
	&hE0, &h90, &h90, &h90, &hE0, _ ' D
	&hF0, &h80, &hF0, &h80, &hF0, _ ' E
	&hF0, &h80, &hF0, &h80, &h80}   ' F

Constructor CPU_T(ByRef Rom As UByte Ptr, ByVal RomSize As Long)
    PC = START_ADDR
    DT = 60
    ST = 60
    
    LoadRom(Rom, RomSize)
    Print "INIT CPU 2"
    LoadFonts()
    Print "INIt CPU 3"
End Constructor

Sub CPU_T.LoadRom(ByRef Rom As UByte Ptr, ByVal RomSize As Long)
	Dim MemPtr As UByte Ptr = @Memory(START_ADDR)
    memcpy(MemPtr, Rom, RomSize)
End Sub

Sub CPU_T.LoadFonts()
	Dim FontsLength As UInteger = UBound(Fonts) + 1
	Dim MemPtr As UByte Ptr = @Memory(FONT_START_ADDR)
	Dim FontPtr As UByte Ptr = @Fonts(0)
	memcpy(MemPtr, FontPtr, FontsLength)
End Sub

Sub CPU_T.FetchInstruction()
	Opcode = (Memory(PC) Shl 8) Or Memory(PC + 1)
	PC += 2
End Sub

Sub CPU_T.ExecuteInstruction()
	Dim NNN As UShort
	Dim As UByte NN, N, X, Y
	Dim UnknownFlag As Boolean = False 
	
	NNN = Opcode And &hFFF
	NN = Opcode And &hFF
	N = Opcode And &hF
	X = (Opcode And &hF00) Shr 8
	Y = (Opcode And &hF0) Shr 4
	
	Select Case (Opcode And &hF000)
	Case &h0000
		Select Case (Opcode And &hFF)
		Case &hE0
			_00E0(This)
		End Select
	Case &h1000
		_1NNN(This, NNN)
	Case &h6000
		_6XNN(This, X, NN)
	Case &h7000
		_7XNN(This, X, NN)
	Case &hA000
		_ANNN(This, NNN)
	Case &hD000
		_DXYN(This, X, Y, N)
		DF = True 
	Case Else
		UnknownFlag = True 
	End Select
	
	If UnknownFlag Then
		Print "Unknown Opcode: 0x" & Hex(Opcode)
	Else
		Print "Readed Opcode: 0x" & Hex(Opcode)
	End If
End Sub

Sub CPU_T.UpdateTimers()
	If DT > 0 Then
		DT -= 1
	End If
	If ST > 0 Then
		ST -= 1
		Print "BEEP"
	End If
End Sub

Sub CPU_T.Cycle()
	DF = False
	FetchInstruction()
	ExecuteInstruction()
	UpdateTimers()
	If DF Then
		UpdateScreen(This)
	End If
End Sub
