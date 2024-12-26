#pragma once
#include "cpu_t.bi"

Declare Sub _00E0(ByRef CPU As CPU_T) ' CLS
Declare Sub _00EE(ByRef CPU As CPU_T) ' RET
Declare Sub _1NNN(ByRef CPU As CPU_T, NNN As UShort) ' JP
Declare Sub _2NNN(ByRef CPU As CPU_T, NNN As UShort) ' CALL
Declare Sub _3XNN(ByRef CPU As CPU_T, X As UByte, NN As UByte)
Declare Sub _4XNN(ByRef CPU As CPU_T, X As UByte, NN As UByte)
Declare Sub _5XY0(ByRef CPU As CPU_T, X As UByte, Y As UByte)
Declare Sub _6XNN(ByRef CPU As CPU_T, X As UByte, NN As UByte)
Declare Sub _7XNN(ByRef CPU As CPU_T, X As UByte, NN As UByte)
Declare Sub _8XY0(ByRef CPU As CPU_T, X As UByte, Y As UByte)
Declare Sub _8XY1(ByRef CPU As CPU_T, X As UByte, Y As UByte)
Declare Sub _8XY2(ByRef CPU As CPU_T, X As UByte, Y As UByte)
Declare Sub _8XY3(ByRef CPU As CPU_T, X As UByte, Y As UByte)
Declare Sub _8XY4(ByRef CPU As CPU_T, X As UByte, Y As UByte)
Declare Sub _8XY5(ByRef CPU As CPU_T, X As UByte, Y As UByte)
Declare Sub _8XY6(ByRef CPU As CPU_T, X As UByte, Y As UByte)
Declare Sub _8XY7(ByRef CPU As CPU_T, X As UByte, Y As UByte)
Declare Sub _8XYE(ByRef CPU As CPU_T, X As UByte, Y As UByte)
Declare Sub _9XY0(ByRef CPU As CPU_T, X As UByte, Y As UByte)
Declare Sub _ANNN(ByRef CPU As CPU_T, NNN As UShort) ' LD
Declare Sub _BNNN(ByRef CPU As CPU_T, NNN As UShort)
Declare Sub _CXNN(ByRef CPU As CPU_T, X As UByte, NN As UByte)
Declare Sub _DXYN(ByRef CPU As CPU_T, X As UByte, Y As UByte, N As UByte)
Declare Sub _EX9E(ByRef CPU As CPU_T, X As UByte)
Declare Sub _EXA1(ByRef CPU As CPU_T, X As UByte)
Declare Sub _FX07(ByRef CPU As CPU_T, X As UByte)
Declare Sub _FX0A(ByRef CPU As CPU_T, X As UByte)
Declare Sub _FX15(ByRef CPU As CPU_T, X As UByte)
Declare Sub _FX18(ByRef CPU As CPU_T, X As UByte)
Declare Sub _FX1E(ByRef CPU As CPU_T, X As UByte)
Declare Sub _FX29(ByRef CPU As CPU_T, FONTS() As UByte, X As UByte)
Declare Sub _FX33(ByRef CPU As CPU_T, X As UByte)
Declare Sub _FX55(ByRef CPU As CPU_T, X As UByte)
Declare Sub _FX65(ByRef CPU As CPU_T, X As UByte)
