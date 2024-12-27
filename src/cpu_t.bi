#pragma once
#define MEM_SIZE 4095
#define SCREEN_WIDTH 63
#define SCREEN_HEIGHT 31
#define V_REGS_SIZE 15
#define STACK_SIZE 15
#define START_ADDR &h200
#define FONT_START_ADDR &h50
#define FONTSET_SIZE 79
#define KEYPAD_SIZE 15

Type CPU_T
    Memory(0 To MEM_SIZE) As UByte ' RAM MEMORY
    Display(SCREEN_WIDTH, SCREEN_HEIGHT) As Boolean ' SCREEN REPRESENTATION
    I As UShort ' INDEX REGISTER
    PC As UShort ' PROGRAM COUNTER
    Stack(0 To STACK_SIZE) As UShort ' STACK
    SP As UByte ' STACK POINTER
    DT As UByte ' DELAY TIMER
    ST As UByte ' SOUND TIMER
    V(0 To V_REGS_SIZE) As UByte ' V REGISTERS
    Opcode As UShort ' CURRENT INSTRUCTION
    DF As Boolean ' DRAW FLAG
    Keypad(0 To KEYPAD_SIZE) As Boolean ' KEYPAD

    Declare Constructor(ByRef Rom As UByte Ptr, ByVal RomSize As Long)

    ' METHODS
    Declare Sub LoadRom(ByRef Rom As UByte Ptr, ByVal RomSize As Long)
    Declare Sub LoadFonts()
    Declare Sub FetchInstruction()
    Declare Sub ExecuteInstruction()
    Declare Sub UpdateTimers()
	Declare Sub Cycle()
End Type
