#INCLUDE <P16F877.INC>


ADDRESS_COUNTER   EQU     0X21   
COUNTER_DELAY1    EQU     0X22   
COUNTER_DELAY2    EQU     0X23    
INCOMING_DATA     EQU     0X24    
LCD_DATA          EQU     0X25    


ORG     0X00
GOTO    MAIN_PROGRAM    

EEPROM_ADDRESS
    BANKSEL EEADR       
    MOVWF EEADR          
    BANKSEL 0x00         
    RETURN               


EEPROM_READ
    BANKSEL EECON1          
    BSF     EECON1,RD   
    BANKSEL EEDATA         
    MOVF    EEDATA,W     
    BANKSEL 0X00         
    RETURN               


EEPROM_WRITE 
    BANKSEL EEADR        
    MOVWF   EEDATA       

    BANKSEL EECON1       
    BSF     EECON1,WREN  

    BCF     INTCON,GIE   ; Tat ngat toan cuc
    MOVLW   0X55         ; Nap gia tri 0x55 vao W    
    MOVWF   EECON2       ; Chuyen gia tri W vao EECON2    
    MOVLW   0XAA            
    MOVWF   EECON2          

    BSF     EECON1,WR    
    BSF     INTCON,GIE   

    BTFSC   EECON1,WR    ; Kiem tra xem qua trinh ghi da ket thuc chua    
    GOTO    $-1          ; Neu chua, tiep tuc cho den khi ket thuc
        
    BCF     EECON1,WREN  ; Tat phep ghi
    BANKSEL 0X00                   
    RETURN              


WriteEEPROM  
    MOVF    ADDRESS_COUNTER,W  
    CALL    EEPROM_ADDRESS     
    MOVF    ADDRESS_COUNTER,W  
    CALL    ROW1               
    XORLW   0X00               ; So sanh ket qua voi 0x00
    BTFSC   STATUS,Z           ; Neu ket qua bang 0 thi quay lai
    RETURN
    CALL    EEPROM_WRITE       
    INCF    ADDRESS_COUNTER,1  ; Tang dia chi len 1
    GOTO    WriteEEPROM        

DisplayRow 
    MOVF    ADDRESS_COUNTER,W  ; Lay gia tri dia chi vao W
    CALL    EEPROM_ADDRESS     ; Goi ham thiet lap dia chi EEPROM
    CALL    EEPROM_READ        
    BTFSC   ADDRESS_COUNTER,4  ; Neu dia chi >= 16 (dong thu 2), nhay den SECOND_ROW
    GOTO    SECOND_ROW
    CALL    DATA_WRITE         
    INCF    ADDRESS_COUNTER,1  
    GOTO    DisplayRow         


SECOND_ROW
    CALL    LCD_SECOND_ROW     

MESSAGE
    MOVF    ADDRESS_COUNTER,W  
    CALL    EEPROM_ADDRESS     
    CALL    EEPROM_READ        
    BTFSC   ADDRESS_COUNTER,5  ; Neu dia chi >= 32, nhay den END_MESSAGE
    GOTO    END_MESSAGE
    CALL    DATA_WRITE         ; Goi ham ghi du lieu len LCD
    INCF    ADDRESS_COUNTER,1  
    GOTO    MESSAGE            


END_MESSAGE
    GOTO    END_MESSAGE        

MAIN_PROGRAM
    BANKSEL TRISB
    CLRF    TRISB              
    CALL    LCD_INIT           
    CALL    WriteEEPROM        
    CLRF    ADDRESS_COUNTER    
    CALL    DisplayRow         


LCD_INIT                            
    MOVLW   H'02'              
    CALL    COMMAND_WRITE      
    MOVLW   H'06'              
    CALL    COMMAND_WRITE                
    MOVLW   0X28               
    CALL    COMMAND_WRITE                
    MOVLW   H'0C'              
    CALL    COMMAND_WRITE                
    RETURN


COMMAND_WRITE     
    BANKSEL PORTB                        
    MOVWF   LCD_DATA                    
    SWAPF   LCD_DATA,W         ; Dao vi tri byte trong W                
    CALL    COMMAND_SEND            
    MOVF    LCD_DATA,W                    
    CALL    COMMAND_SEND                 
    RETURN


COMMAND_SEND
    BANKSEL PORTB                        
    ANDLW   0X0F              ; Lay 4 bit thap cua du lieu                  
    MOVWF   PORTB                          
    BANKSEL PORTB                    
    BCF     PORTB,4           ; Xoa bit 4 cua PORTB               
    CALL    DELAY                         
    CALL    E_PULSE           ; Goi xung clock
    RETURN


DATA_WRITE 
    BANKSEL PORTB
    MOVWF   LCD_DATA                     
    SWAPF   LCD_DATA,W        ; Dao vi tri byte trong W               
    CALL    SEND_DATA          
    MOVF    LCD_DATA,W        ; Chuyen lai du lieu vao W            
    CALL    SEND_DATA                        
    RETURN


SEND_DATA
    BANKSEL PORTB
    ANDLW   0X0F              ; Lay 4 bit thap cua du lieu                  
    MOVWF   PORTB             ; Chuyen du lieu vao PORTB                    
    BANKSEL PORTB                
    BSF     PORTB,4           ; Set bit 4 cua PORTB               
    CALL    DELAY                          
    CALL    E_PULSE           ; Goi xung clock                
    RETURN


E_PULSE                            
    BSF     PORTB,5                          
    BCF     PORTB,5           ; Xoa bit 5 cua PORTB                
    RETURN


LCD_SECOND_ROW                            
    MOVLW   0XC0                            
    CALL    COMMAND_WRITE      
    RETURN


LCD_FIRST_ROW_OFFSET                        
    ADDLW   0X80                              
    CALL    COMMAND_WRITE                      
    RETURN


LCD_SECOND_ROW_OFFSET                            
    ADDLW   0XC0              ; Dia chi dau dong thu 2                  
    CALL    COMMAND_WRITE                    
    RETURN


DELAY
    MOVLW   H'20'
    MOVWF   COUNTER_DELAY1    
LOOP1
    MOVLW   H'20'
    MOVWF   COUNTER_DELAY2    
LOOP2
    DECFSZ  COUNTER_DELAY2,F  
    GOTO    LOOP2
    DECFSZ  COUNTER_DELAY1,F  
    GOTO    LOOP1
    RETURN


ROW1 
    ADDWF   PCL,F             
    RETLW   'S'
    RETLW   'U'
    RETLW   ' '
    RETLW   'P'
    RETLW   'H'
    RETLW   'A'
    RETLW   'M'
    RETLW   ' '
    RETLW   'K'
    RETLW   'Y'
    RETLW   ' '
    RETLW   'T'
    RETLW   'H'
    RETLW   'U'
    RETLW   'A'
    RETLW   'T'
    RETLW   ' '
    RETLW   'H'
    RETLW   'O'
    RETLW   ' '
    RETLW   'C'
    RETLW   'H'
    RETLW   'I'
    RETLW   ' '
    RETLW   'M'
    RETLW   'I'
    RETLW   'N'
    RETLW   'H'
    RETLW   ' '
    RETLW   ' '
    RETLW   ' '
    RETLW   ' '
   
RETLW   0X00      
END
