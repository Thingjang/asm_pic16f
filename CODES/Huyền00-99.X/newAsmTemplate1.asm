PROCESSOR PIC16F877A
#INCLUDE <P16F877A.INC>
__CONFIG _HS_OSC&_WDT_OFF&_BODEN_OFF&_PWRTE_OFF&_WRT_OFF&_CPD_OFF&_LVP_OFF
CBLOCK 0X20 ; Khai bao nhung o nho se dung trong bai
CHUC
DONVI
BIEN1
BIEN2
DEM
COUNT
ENDC
ORG 0X00
BSF STATUS,5 ; BANK 1
CLRF TRISA
CLRF TRISB
MOVLW 0X07
MOVWF ADCON1
BCF STATUS,5 ; BANK0

MAIN
CLRF CHUC   ;Dua hang chuc ve gia tri 0
LOOP
CLRF DONVI  ;Dua hang don vi ve gia tri 0
LOOP1
CALL MA_LED_7SEG  ;Goi chuong trinh ma led 7seg
CALL HIEN_THI_7SEG  ;Goi chuong trinh hien thi 7Seg
INCF DONVI  ;tang gia tri hang don vi
MOVF DONVI,0 ; luu gia tri thanh ghi donvi vao thanh ghi w
XORLW D'10' ;kiem tra gia tri hang donvi
BTFSS STATUS,Z
GOTO LOOP1 ;nêu gia tri hang don vi sai thi quay lai Loop1
INCF CHUC ;Tang gia tri hang chuc
MOVF CHUC,0  ;luu gia tri hang don vi vao thanh ghi w
XORLW D'10' ;kiem tra gia tri hang chuc
BTFSS STATUS,Z
GOTO LOOP  ;neu gia tri thnah ghi chuc sai thi quay lai Loop
GOTO MAIN

HIEN_THI_7SEG
MOVLW 0XFF ;
MOVWF DEM
CALL HIEN_THI
DECFSZ DEM,1
GOTO $-2
RETURN

HIEN_THI
MOVLW 0X01
MOVWF PORTA
MOVF BIEN1,0
MOVWF PORTB ;hien thi hang don vi
CALL DELAY
MOVLW 0X02
MOVWF PORTA
MOVF BIEN2,0
MOVWF PORTB ;hien thi hnag chuc
CALL DELAY
RETURN

MA_LED_7SEG
MOVF DONVI,0  ;dua gia tri thanh ghi don vi vao thanh ghi w
CALL MANG_MA
MOVWF BIEN1   ;dua gia tri don vi trong thanh ghi w vao thanh ghi Bien1
MOVF CHUC,0  ;dua gia tri thanh ghi chuc vao thanh ghi w
CALL MANG_MA
MOVWF BIEN2   ;dua gia tri chuc trong thanh ghi w vao thanh ghi Bien2
RETURN

MANG_MA
ADDWF PCL,1
DT 0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90 ;ma 7led anode

DELAY
MOVLW 0XFF
MOVWF COUNT
DECFSZ COUNT,1
GOTO $-1
RETURN
END 