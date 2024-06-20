list			p=16f877
include		"p16f877.inc"

cblock		0x20
c0
c1
c2
endc

	ORG		0
	goto		anaprogram
	ORG		4
	goto		int

anaprogram
			banksel			TRISB
			movlw			b'00000001'
			movwf			TRISB
			banksel			PORTB
			clrf				PORTB
			banksel			INTCON
			movlw			b'10010000'
			movwf			INTCON
			banksel			OPTION_REG
			clrf				OPTION_REG
			goto				$
int
			banksel			INTCON
			bcf				INTCON,INTF
			movlw			h'80'
			xorwf			PORTB
			retfie

delay
			movwf			c0
loop0
			movlw			d'255'
			movwf			c1
loop1
			movlw			d'255'
			movwf			c2
loop2
			decfsz			c2,F
			goto				loop2
			decfsz			c1
			goto				loop1
			decfsz			c0
			goto				loop0
			return
END 