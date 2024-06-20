#INCLUDE <P16F877A.INC>
__CONFIG _HS_OSC&_WDT_ON&_BOREN_OFF&_PWRTE_ON&_WRT_OFF&_CPD_OFF&_LVP_OFF&_CP_ON&_DEBUG_OFF;//HS-MUC CAO -//-

COUNTER_DL1 	EQU		0X29	
COUNTER_DL2 	EQU		0X30;//slow;//fast-> notro

	ORG 	0X00;// DUA POINT 0X00 MEMORY

ANA_PROGRAM	


	BANKSEL	TRISA
	MOVLW	0XFF
	MOVWF	TRISA
	CLRF	TRISD
	CLRF	TRISC
	CALL	ADC_INIT;SET

   

    

  MAIN0  
	CALL	DL
	CALL	ADC_READ
	GOTO	MAIN0
  
    
ADC_READ
	BANKSEL	ADCON0
    BSF		ADCON0,2; if , f clear all.,BIT2
 
    CALL DL
WAIT 
    BTFSC 	ADCON0,2;// neu bit 1 thi wait con =0 thi tiep tuc thuc hien qua trinh tiep
	GOTO 	WAIT
	
	BANKSEL	ADRESH
    RRF ADRESH
	MOVF	ADRESH,0;// ADDRESS REG LOW & HIGH, set 0->clear
	BANKSEL	PORTD
	MOVWF	PORTD
    RRF ADRESH

	BANKSEL	ADRESL
    RRF ADRESL
	MOVF	ADRESL,0; set 0 d? clear
	BANKSEL	PORTD
	MOVWF	PORTC
	RETURN



ADC_INIT
	BANKSEL	ADCON1
	MOVLW	B'10001110'
	MOVWF	ADCON1

	BANKSEL	ADCON0
	MOVLW	B'01000001'
	MOVWF	ADCON0
	RETURN

DL;// TAO TRE DE XONG R LM TIEP;// ISC NHANH -> NHIEU LENH THI NO K HIEN THI HET DC, 1-1; 0;1 11
	MOVLW	H'FF'
	MOVWF	COUNTER_DL1

  
LOOP1
     
	MOVLW	H'FF'
	MOVWF	COUNTER_DL2
 
LOOP2
    
	DECFSZ	COUNTER_DL2,F
	GOTO	LOOP2

	DECFSZ	COUNTER_DL1,F
	GOTO	LOOP1
 
	RETURN
END
