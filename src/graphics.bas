#include "graphics.bi"

Dim Win As SDL_Window Ptr
Dim Renderer As SDL_Renderer Ptr

Sub GraphicsInit()
	SDL_Init(SDL_INIT_EVERYTHING)
	
	Win = SDL_CreateWindow("Chip8 Emu", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 640, 320, SDL_WINDOW_SHOWN)
	Renderer = SDL_CreateRenderer(Win, -1, SDL_RENDERER_ACCELERATED)
	
	SDL_SetRenderDrawColor(Renderer, 0, 0, 0, 0)
	SDL_RenderClear(Renderer)
	
End Sub

Sub DrawRect(X As Integer, Y As Integer, Colour As Integer)
	Dim Rec As SDL_Rect
	Rec.h = 10
	Rec.w = 10
	Rec.x = X * 10
	Rec.y = Y * 10
	
	SDL_SetRenderDrawColor(Renderer, Colour, Colour, Colour, 255)
	SDL_RenderFillRect(Renderer, @Rec)
End Sub

Sub UpdateScreen(ByRef CPU As CPU_T)
	For X As Integer = 0 To SCREEN_WIDTH
		For Y As Integer = 0 To SCREEN_HEIGHT
			If CPU.Display(X, Y) Then
				DrawRect(X, Y, &hFF)
			Else
				DrawRect(X, Y, 0)
			End If
		Next
	Next
	SDL_RenderPresent(Renderer)
End Sub

Sub GraphicsQuit()
	SDL_DestroyWindow(Win)
	SDL_DestroyRenderer(Renderer)
	SDL_Quit()
End Sub
