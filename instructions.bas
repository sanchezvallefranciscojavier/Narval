#include "instructions.bi"

Sub _00E0(ByRef CPU As CPU_T) ' CLS
    For I As Integer = LBound(CPU.Display, 1) To UBound(CPU.Display, 1)
    	For J As Integer = LBound(CPU.Display, 2) To UBound(CPU.Display, 2)
    		CPU.Display(I, J) = False 
    	Next
    Next
End Sub

Sub _1NNN(ByRef CPU As CPU_T, NNN As UShort) ' JP
	CPU.PC = NNN
End Sub

Sub _6XNN(ByRef CPU As CPU_T, X As UByte, NN As UByte)
	CPU.V(X) = NN
End Sub

Sub _7XNN(ByRef CPU As CPU_T, X As UByte, NN As UByte)
	CPU.V(X) += NN
End Sub

Sub _ANNN(ByRef CPU As CPU_T, NNN As UShort) ' LD
	CPU.I = NNN
End Sub

Sub _DXYN(ByRef CPU As CPU_T, X As UByte, Y As UByte, N As UByte)
    Dim As UByte XPosition = CPU.V(X) Mod 64
    Dim As UByte YPosition = CPU.V(Y) Mod 32
    
    CPU.V(&hF) = 0
    
    For Row As Integer = 0 To N - 1
        Dim As UByte SpriteData = CPU.Memory(CPU.I + Row)
        For Col As Integer = 0 To 7
            If (SpriteData And (&h80 Shr Col)) <> 0 Then
                If CPU.Display(XPosition + Col, YPosition + Row) Then
                    CPU.V(&hF) = 1
                End If
                
                CPU.Display(XPosition + Col, YPosition + Row) = Not CPU.Display(XPosition + Col, YPosition + Row)
            End If
        Next
    Next
End Sub

