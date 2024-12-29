#pragma once

Declare Function DisassembleSingleInstruction(ByVal Opcode As UShort) As String
Declare Sub DisassembleROM(ByRef Rom As UByte Ptr, ByVal RomSize As Integer)
