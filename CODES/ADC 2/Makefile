# MPLAB IDE generated this makefile for use with GNU make.
# Project: adc.mcp
# Date: Tue May 14 14:23:50 2024

AS = MPASMWIN.exe
CC = 
LD = mplink.exe
AR = mplib.exe
RM = rm

adc.cof : adc.o
	$(CC) /p16F877A "adc.o" /u_DEBUG /z__MPLAB_BUILD=1 /z__MPLAB_DEBUG=1 /o"adc.cof" /M"adc.map" /W /x

adc.o : adc.asm ../../../../../Program\ Files\ (x86)/Microchip/MPASM\ Suite/P16F877A.INC
	$(AS) /q /p16F877A "adc.asm" /l"adc.lst" /e"adc.err" /d__DEBUG=1

clean : 
	$(CC) "adc.o" "adc.hex" "adc.err" "adc.lst" "adc.cof"

