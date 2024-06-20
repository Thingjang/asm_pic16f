
    
   PROCESSOR PIC16F87
    #INCLUDE <P16F87.INC>
    
    DEM EQU 0X20   
    COUNT EQU 0X21   
    COUNT1 EQU 0X22   
    ORG 0X00		
    GOTO MAIN

MAIN 
    BANKSEL TRISB	;chon bo nho ngan hang ma thanh ghi trisb thuoc va xoa no de cau cau hinh cua port B la dau ra
    CLRF TRISB
    BANKSEL PORTB   ;xoa DEM de khoi tao dem =0
    CLRF DEM
    MOVLW 0xFF	; Khoi tao gia tri ban dau cua portB
    MOVWF PORTB
LOOP		       ;Vong lap
    MOVF DEM, W
    CALL MANG_MA	     ;lay gia tri cua dem va gui vao W
    MOVWF PORTB
    CALL DELAY
    INCF DEM, F  ; Tang giá tri dem len 1
    
    MOVF DEM, W ; Kiem tra DEM có bang 10 không, neu có thì d?t DEM = 0
    SUBLW D'10'
    BTFSS STATUS, Z
    GOTO LOOP_END
    CLRF DEM
LOOP_END
    GOTO LOOP

MANG_MA
    ADDWF PCL, F
    DT 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F,0x6F

DELAY 
    MOVLW 0xFF
    MOVWF COUNT
DELAY_LOOP
    MOVLW 0xFF
    MOVWF COUNT1
DELAY_LOOP1
    DECFSZ COUNT1, F
    GOTO DELAY_LOOP1
    DECFSZ COUNT, F
    GOTO DELAY_LOOP
    RETURN

END
