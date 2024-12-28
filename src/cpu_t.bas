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
    LoadFonts()
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
		Case &hE0 : _00E0(This)
		Case &hEE : _00EE(This)
		End Select
	Case &h1000 : _1NNN(This, NNN)
	Case &h2000 : _2NNN(This, NNN)
	Case &h3000 : _3XNN(This, X, NN)
	Case &h4000 : _4XNN(This, X, NN)
	Case &h5000 : _5XY0(This, X, Y)
	Case &h6000 : _6XNN(This, X, NN)
	Case &h7000 : _7XNN(This, X, NN)
	Case &h8000
		Select Case (Opcode And &hF)
		Case &h0 : _8XY0(This, X, Y)
		Case &h1 : _8XY1(This, X, Y)
		Case &h2 : _8XY2(This, X, Y)
		Case &h3 : _8XY3(This, X, Y)
		Case &h4 : _8XY4(This, X, Y)
		Case &h5 : _8XY5(This, X, Y)
		Case &h6 : _8XY6(This, X, Y)
		Case &h7 : _8XY7(This, X, Y)
		Case &hE : _8XYE(This, X, Y)
		End Select
	Case &hA000 : _ANNN(This, NNN)
	Case &hB000 : _BNNN(This, NNN)
	Case &hC000 : _CXNN(This, X, NN)
	Case &hD000
		_DXYN(This, X, Y, N)
		DF = True
	Case &hE000
		Select Case (Opcode And &hFF)
		Case &h9E : _EX9E(This, X)
		Case &hA1 : _EXA1(This, X)
		End Select
	Case &hF000
		Select Case (Opcode And &hFF)
		Case &h07 : _FX07(This, X)
		Case &h0A : _FX0A(This, X)
		Case &h15 : _FX15(This, X)
		Case &h18 : _FX18(This, X)
		Case &h1E : _FX1E(This, X)
		Case &h29 : _FX29(This, Fonts(), X)
		Case &h33 : _FX33(This, X)
		Case &h55 : _FX55(This, X)
		Case &h65 : _FX65(This, X)
		End Select
	Case Else : UnknownFlag = True
	End Select
	
	If UnknownFlag Then
		Print "Unknown Opcode: 0x"  & Hex(Opcode)
	Else
		Print "Readed Opcode: 0x"  & Hex(Opcode)
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
