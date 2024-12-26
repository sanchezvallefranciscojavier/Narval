#include "instructions.bi"

Sub _00E0(ByRef CPU As CPU_T) ' CLS
    For I As Integer = LBound(CPU.Display, 1) To UBound(CPU.Display, 1)
    	For J As Integer = LBound(CPU.Display, 2) To UBound(CPU.Display, 2)
    		CPU.Display(I, J) = False 
    	Next
    Next
End Sub

Sub _00EE(ByRef CPU As CPU_T)
	CPU.PC = CPU.Stack(CPU.SP)
	CPU.SP -= 1
End Sub

Sub _1NNN(ByRef CPU As CPU_T, NNN As UShort) ' JP
	CPU.PC = NNN
End Sub

Sub _2NNN(ByRef CPU As CPU_T, NNN As UShort)
	CPU.SP += 1
	CPU.Stack(CPU.SP) = CPU.PC
	CPU.PC = NNN
End Sub

Sub _3XNN(ByRef CPU As CPU_T, X As UByte, NN As UByte)
	If CPU.V(X) = NN Then
		CPU.PC += 2
	End If
End Sub

Sub _4XNN(ByRef CPU As CPU_T, X As UByte, NN As UByte)
	If CPU.V(X) <> NN Then
		CPU.PC += 2
	End If
End Sub

Sub _5XY0(ByRef CPU As CPU_T, X As UByte, Y As UByte)
	If CPU.V(X) = CPU.V(Y) Then
		CPU.PC += 2
	End If
End Sub

Sub _6XNN(ByRef CPU As CPU_T, X As UByte, NN As UByte)
	CPU.V(X) = NN
End Sub

Sub _7XNN(ByRef CPU As CPU_T, X As UByte, NN As UByte)
	CPU.V(X) += NN
End Sub

Sub _8XY0(ByRef CPU As CPU_T, X As UByte, Y As UByte)
	CPU.V(X) = CPU.V(Y)
End Sub

Sub _8XY1(ByRef CPU As CPU_T, X As UByte, Y As UByte)
	CPU.V(X) = CPU.V(X) Or CPU.V(Y)
End Sub

Sub _8XY2(ByRef CPU As CPU_T, X As UByte, Y As UByte)
	CPU.V(X) = CPU.V(X) And CPU.V(Y)
End Sub

Sub _8XY3(ByRef CPU As CPU_T, X As UByte, Y As UByte)
	CPU.V(X) = CPU.V(X) Xor CPU.V(Y)
End Sub

Sub _8XY4(ByRef CPU As CPU_T, X As UByte, Y As UByte)
	Dim As UShort Result = CPU.V(X) + CPU.V(Y)
	If Result > &hFF Then
		CPU.V(&hF) = 1
	Else
		CPU.V(&hF) = 0
	End If
	CPU.V(X) = Result And &hFF
End Sub

Sub _8XY5(ByRef CPU As CPU_T, X As UByte, Y As UByte)
	If CPU.V(X) > CPU.V(Y) Then
		CPU.V(&hF) = 1
	Else
		CPU.V(&hF) = 0
	End If
	CPU.V(X) -= CPU.V(Y)
End Sub

Sub _8XY6(ByRef CPU As CPU_T, X As UByte, Y As UByte)
	Dim As UByte LSBit = CPU.V(X) And &h1
	If LSBit = &h1 Then
		CPU.V(&hF) = 1
	Else
		CPU.V(&hF) = 0
	End If
	CPU.V(X) = CPU.V(X) Shr 1
End Sub

Sub _8XY7(ByRef CPU As CPU_T, X As UByte, Y As UByte)
	If CPU.V(X) < CPU.V(Y) Then
		CPU.V(&hF) = 1
	Else
		CPU.V(&hF) = 0
	End If
	CPU.V(X) = CPU.V(Y) - CPU.V(X)
End Sub

Sub _8XYE(ByRef CPU As CPU_T, X As UByte, Y As UByte)
	Dim As UByte LSBit = CPU.V(X) And &h1
	If LSBit = &h1 Then
		CPU.V(&hF) = 1
	Else
		CPU.V(&hF) = 0
	End If
	CPU.V(X) = CPU.V(X) Shl 1
End Sub

Sub _9XY0(ByRef CPU As CPU_T, X As UByte, Y As UByte)
	If CPU.V(X) <> CPU.V(Y) Then
		CPU.PC += 2
	End If
End Sub

Sub _ANNN(ByRef CPU As CPU_T, NNN As UShort) ' LD
	CPU.I = NNN
End Sub

Sub _BNNN(ByRef CPU As CPU_T, NNN As UShort)
	CPU.PC = NNN + CPU.V(0)
End Sub

Sub _CXNN(ByRef CPU As CPU_T, X As UByte, NN As UByte)
	Randomize Timer
	Dim RandomNum As Integer
	RandomNum = Int(Rnd * 256) + 1
	
	CPU.V(X) = RandomNum And NN
End Sub

Sub _DXYN(ByRef CPU As CPU_T, X As UByte, Y As UByte, N As UByte)
    Dim As UByte XPosition = CPU.V(X) Mod 64
    Dim As UByte YPosition = CPU.V(Y) Mod 32
    
    CPU.V(&HF) = 0
    
    For Row As Integer = 0 To N - 1
        Dim As UByte SpriteData = CPU.Memory(CPU.I + Row)
        For Col As Integer = 0 To 7
            If (SpriteData And (&H80 Shr Col)) <> 0 Then
                If CPU.Display(XPosition + Col, YPosition + Row) Then
                    CPU.V(&HF) = 1
                End If
                
                CPU.Display(XPosition + Col, YPosition + Row) = Not CPU.Display(XPosition + Col, YPosition + Row)
            End If
        Next
    Next
End Sub

Sub _EX9E(ByRef CPU As CPU_T, X As UByte)
	' TODO
End Sub

Sub _EXA1(ByRef CPU As CPU_T, X As UByte)
	' TODO
End Sub

Sub _FX07(ByRef CPU As CPU_T, X As UByte)
	CPU.V(X) = CPU.DT
End Sub

Sub _FX0A(ByRef CPU As CPU_T, X As UByte)
	' TODO
End Sub

Sub _FX15(ByRef CPU As CPU_T, X As UByte)
	CPU.DT = CPU.V(X)
End Sub

Sub _FX18(ByRef CPU As CPU_T, X As UByte)
	CPU.ST = CPU.V(X)
End Sub

Sub _FX1E(ByRef CPU As CPU_T, X As UByte)
	CPU.I += CPU.V(X)
End Sub

Sub _FX29(ByRef CPU As CPU_T, FONTS() As UByte, X As UByte)
	CPU.I = FONTS(CPU.V(X) * 5)
End Sub

Sub _FX33(ByRef CPU As CPU_T, X As UByte)
	' TODO
End Sub

Sub _FX55(ByRef CPU As CPU_T, X As UByte)
	For Index As Integer = 0 To X - 1
		CPU.Memory(CPU.I + Index) = CPU.V(Index)
	Next
End Sub

Sub _FX65(ByRef CPU As CPU_T, X As UByte)
	For Index As Integer = 0 To X - 1
		CPU.V(Index) = CPU.Memory(CPU.I + Index)
	Next
End Sub

