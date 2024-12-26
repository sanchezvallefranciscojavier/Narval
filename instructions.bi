#pragma once
#include "cpu_t.bi"

Declare Sub _00E0(ByRef CPU As CPU_T) ' CLS
Declare Sub _1NNN(ByRef CPU As CPU_T, NNN As UShort) ' JP
Declare Sub _6XNN(ByRef CPU As CPU_T, X As UByte, NN As UByte)
Declare Sub _7XNN(ByRef CPU As CPU_T, X As UByte, NN As UByte)
Declare Sub _ANNN(ByRef CPU As CPU_T, NNN As UShort) ' LD
Declare Sub _DXYN(ByRef CPU As CPU_T, X As UByte, Y As UByte, N As UByte)
