#pragma once
#include "SDL2/SDL.bi"
#include "cpu_t.bi"

Extern Win As SDL_Window Ptr
Extern Renderer As SDL_Renderer Ptr

Declare Sub GraphicsInit()
Declare Sub DrawRect(X As Integer, Y As Integer, Colour As Integer)
Declare Sub UpdateScreen(ByRef CPU As CPU_T)
Declare Sub GraphicsQuit()
