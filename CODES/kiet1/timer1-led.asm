LIST P=16F877A
#INCLUDE <P16F877A.INC>              ; Thêm file dinh nghia cho PIC16F877A
DEM EQU 0X20                         ; Ðinh nghia DEM voi giá tri ban dau là 0x20
ORG 0X00                          ; Ðat dia chi bat dau chuong trình là 0x00
GOTO MAIN                       ; Nhay den nhãn MAIN

ORG 0X04                        ; Ðat dia chi bat dau cho ngat là 0x04
GOTO NGAT                       ; di toi NGAT khi có ngat xay ra

NGAT                           ; Nhãn xu lý ngat
BCF PIR1,TMR1IF                 ; Xóa co ngat TMR1IF
BANKSEL TMR1H                   ; Chon bank chua thanh ghi TMR1H
MOVLW H'3C'                     ; Ðat giá tri 0x3C vào W
MOVWF TMR1H                     ; Ðua giá tri trong W vào TMR1H
MOVLW H'B0'                     ; Ðat giá tri 0xB0 vào W
MOVWF TMR1L                     ; Ðua giá tri trong W vào TMR1L

DECFSZ DEM,F                  ; Giam DEM di 1, neu DEM = 0 sau khi giam thì ket thúc ngat
RETFIE                           
MOVLW D'5'                     ; Ðat giá tri 5 vào W
MOVWF DEM                   ; Ðua giá tri trong W vào DEM
COMF PORTB,F                    ; Ðao tat ca các bit cua PORTB
RETFIE                          ; Ket thúc ngat
MAIN                            ; Nhãn chính cua chuong trình
BANKSEL TRISB                   ; Chon bank chua thanh ghi TRISB
CLRF TRISB                      ; Ðat tat ca các bit cua TRISB ve 0 (cau hình PORTB là output)
BANKSEL PORTB                    ; Chon bank chua thanh ghi PORTB
BSF PORTB,0                     ; Ðat bit 0 cua PORTB lên muc cao

BANKSEL TMR1H                   ; Chon bank chua thanh ghi TMR1H
MOVLW H'3C'                     ; Ðat giá tri 0x3C vào W
MOVWF TMR1H                     ; Ðua giá tri trong W vào TMR1H
MOVLW H'B0'                     ; Ðat giá tri 0xB0 vào W
MOVWF TMR1L                     ; Ðua giá tri trong W vào TMR1L


BANKSEL INTCON                   ; Chon bank chua thanh ghi INTCON
MOVLW B'11000000'               ; Ðat giá tri 0b11000000 vào W
MOVWF INTCON                    ; Ðua giá tri trong W vào INTCON

BANKSEL PIE1                    ; Chon bank chua thanh ghi PIE1
BSF PIE1,TMR1IE                ; Kích hoat ngat TMR1IE


BANKSEL T1CON                 ; Chon bank chua thanh ghi T1CON
MOVLW B'00100001'               ; Ðat giá tri 0b00100001 vào W
MOVWF T1CON                      ; Ðua giá tri trong W vào T1CON

BANKSEL DEM                   ; Chon bank chua thanh ghi DEM
MOVLW D'5'                       ; Ðat giá tri 5 vào W
MOVWF DEM                      ; Ðua giá tri trong W vào DEM

VONG_LAP                      ; Nhãn vòng lap chính cua chuong trình
GOTO VONG_LAP                       ; Lap di lap lai vòng lap VONG_LAP 

END