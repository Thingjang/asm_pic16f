LIST P=16F877A
#INCLUDE <P16F877A.INC>              ; Th�m file dinh nghia cho PIC16F877A
DEM EQU 0X20                         ; �inh nghia DEM voi gi� tri ban dau l� 0x20
ORG 0X00                          ; �at dia chi bat dau chuong tr�nh l� 0x00
GOTO MAIN                       ; Nhay den nh�n MAIN

ORG 0X04                        ; �at dia chi bat dau cho ngat l� 0x04
GOTO NGAT                       ; di toi NGAT khi c� ngat xay ra

NGAT                           ; Nh�n xu l� ngat
BCF PIR1,TMR1IF                 ; X�a co ngat TMR1IF
BANKSEL TMR1H                   ; Chon bank chua thanh ghi TMR1H
MOVLW H'3C'                     ; �at gi� tri 0x3C v�o W
MOVWF TMR1H                     ; �ua gi� tri trong W v�o TMR1H
MOVLW H'B0'                     ; �at gi� tri 0xB0 v�o W
MOVWF TMR1L                     ; �ua gi� tri trong W v�o TMR1L

DECFSZ DEM,F                  ; Giam DEM di 1, neu DEM = 0 sau khi giam th� ket th�c ngat
RETFIE                           
MOVLW D'5'                     ; �at gi� tri 5 v�o W
MOVWF DEM                   ; �ua gi� tri trong W v�o DEM
COMF PORTB,F                    ; �ao tat ca c�c bit cua PORTB
RETFIE                          ; Ket th�c ngat
MAIN                            ; Nh�n ch�nh cua chuong tr�nh
BANKSEL TRISB                   ; Chon bank chua thanh ghi TRISB
CLRF TRISB                      ; �at tat ca c�c bit cua TRISB ve 0 (cau h�nh PORTB l� output)
BANKSEL PORTB                    ; Chon bank chua thanh ghi PORTB
BSF PORTB,0                     ; �at bit 0 cua PORTB l�n muc cao

BANKSEL TMR1H                   ; Chon bank chua thanh ghi TMR1H
MOVLW H'3C'                     ; �at gi� tri 0x3C v�o W
MOVWF TMR1H                     ; �ua gi� tri trong W v�o TMR1H
MOVLW H'B0'                     ; �at gi� tri 0xB0 v�o W
MOVWF TMR1L                     ; �ua gi� tri trong W v�o TMR1L


BANKSEL INTCON                   ; Chon bank chua thanh ghi INTCON
MOVLW B'11000000'               ; �at gi� tri 0b11000000 v�o W
MOVWF INTCON                    ; �ua gi� tri trong W v�o INTCON

BANKSEL PIE1                    ; Chon bank chua thanh ghi PIE1
BSF PIE1,TMR1IE                ; K�ch hoat ngat TMR1IE


BANKSEL T1CON                 ; Chon bank chua thanh ghi T1CON
MOVLW B'00100001'               ; �at gi� tri 0b00100001 v�o W
MOVWF T1CON                      ; �ua gi� tri trong W v�o T1CON

BANKSEL DEM                   ; Chon bank chua thanh ghi DEM
MOVLW D'5'                       ; �at gi� tri 5 v�o W
MOVWF DEM                      ; �ua gi� tri trong W v�o DEM

VONG_LAP                      ; Nh�n v�ng lap ch�nh cua chuong tr�nh
GOTO VONG_LAP                       ; Lap di lap lai v�ng lap VONG_LAP 

END