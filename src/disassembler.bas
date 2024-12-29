#include "disassembler.bi"
#include "utils.bi"

Function DisassembleSingleInstruction(ByVal Opcode As UShort) As String
	Dim As UShort NNN
	Dim As UByte NN, N, X, Y
	Dim As String DasmOpcode
	
	NNN = Opcode And &hFFF
	NN = Opcode And &hFF
	N = Opcode And &hF
	X = (Opcode And &hF00) Shr 8
	Y = (Opcode And &hF0) Shr 4
	
	Select Case (Opcode And &hF000)
	Case &h0000
		Select Case (Opcode And &hFF)
		Case &hE0 : DasmOpcode = "CLS"
		Case &hEE : DasmOpcode = "RET"
		Case Else : DasmOpcode = "SYS " & Hex(NNN)
		End Select
	Case &h1000 : DasmOpcode = "JP " & Hex(NNN)
	Case &h2000 : DasmOpcode = "CALL " & Hex(NNN)
	Case &h3000 : DasmOpcode = "SE V" & Hex(X) & ", " & Hex(NN) 
	Case &h4000 : DasmOpcode = "SNE V" & Hex(X) & ", " & Hex(NN) 
	Case &h5000 : DasmOpcode = "SE V" & Hex(X) & ", V" & Hex(Y)
	Case &h6000 : DasmOpcode = "LD V" & Hex(X) & ", " & Hex(NN)
	Case &h7000 : DasmOpcode = "ADD V" & Hex(X) & ", " & Hex(NN)
	Case &h8000
		Select Case (Opcode And &hF)
		Case &h0 : DasmOpcode = "LD V" & Hex(X) & ", V" & Hex(Y)
		Case &h1 : DasmOpcode = "OR V" & Hex(X) & ", V" & Hex(Y)
		Case &h2 : DasmOpcode = "AND V" & Hex(X) & ", V" & Hex(Y)
		Case &h3 : DasmOpcode = "XOR V" & Hex(X) & ", V" & Hex(Y)
		Case &h4 : DasmOpcode = "ADD V" & Hex(X) & ", V" & Hex(Y)
		Case &h5 : DasmOpcode = "SUB V" & Hex(X) & ", V" & Hex(Y)
		Case &h6 : DasmOpcode = "SHR V" & Hex(X)
		Case &h7 : DasmOpcode = "SUBN V" & Hex(X) & ", V" & Hex(Y)
		Case &hE : DasmOpcode = "SHL V" & Hex(X)
		End Select
	Case &h9000 : DasmOpcode = "SNE V" & Hex(X) & ", V" & Hex(Y)
	Case &hA000 : DasmOpcode = "LD I, " & Hex(NNN)
	Case &hB000 : DasmOpcode = "JP V0, " & Hex(NNN)
	Case &hC000 : DasmOpcode = "RND V" & Hex(X) & ", " & Hex(NN)
	Case &hD000 : DasmOpcode = "DRW V" & Hex(X) & ", V" & Hex(Y) & ", " & Hex(N)
	Case &hE000
		Select Case (Opcode And &hFF)
		Case &h9E : DasmOpcode = "SKP V" & Hex(X)
		Case &hA1 : DasmOpcode = "SKNP V" & Hex(X)
		End Select
	Case &hF000
		Select Case (Opcode And &hFF)
		Case &h07 : DasmOpcode = "LD V" & Hex(X) & ", DT"
		Case &h0A : DasmOpcode = "LD V" & Hex(X) & ", K"
		Case &h15 : DasmOpcode = "LD DT, V" & Hex(X)
		Case &h18 : DasmOpcode = "LD ST, V" & Hex(X)
		Case &h1E : DasmOpcode = "ADD I, V" & Hex(X)
		Case &h29 : DasmOpcode = "LD F, V" & Hex(X)
		Case &h33 : DasmOpcode = "LD B, V" & Hex(X)
		Case &h55 : DasmOpcode = "LD [I], V" & Hex(X)
		Case &h65 : DasmOpcode = "LD V" & Hex(X) & ", [I]"
		End Select
	Case Else : DasmOpcode = "Unknown Opcode"
	End Select
	
	Return DasmOpcode
End Function

Sub DisassembleROM(ByRef Rom As UByte Ptr, ByVal RomSize As Integer)
	Dim As UShort Opcode
	Dim As String DisassembledInstruction
	
	Open "disassembled.dasm" For Output As #1
	
	For Index As Integer = 0 To RomSize - 1 Step 2
		Opcode = (*(Rom + Index) Shl 8) Or *(Rom + Index + 1)
		DisassembledInstruction = DisassembleSingleInstruction(Opcode)
		
		Print DisassembledInstruction
		Print #1, DisassembledInstruction
	Next
	
	Close #1
End Sub
