PROCESSOR 16F887
#include <xc.inc>
config FOSC = INTRC_CLKOUT// Oscillator Selection bits (INTOSC oscillator: CLKOUT function on RA6/OSC2/CLKOUT pin, I/O function on RA7/OSC1/CLKIN)
 config WDTE = OFF       // Watchdog Timer Enable bit (WDT disabled and can be enabled by SWDTEN bit of the WDTCON register)
 config PWRTE = OFF       // Power-up Timer Enable bit (PWRT enabled)
 config MCLRE = ON       // RE3/MCLR pin function select bit (RE3/MCLR pin function is MCLR)
 config CP = OFF         // Code Protection bit (Program memory code protection is disabled)
 config CPD = OFF        // Data Code Protection bit (Data memory code protection is disabled)
 config BOREN = ON       // Brown Out Reset Selection bits (BOR enabled)
 config IESO = ON        // Internal External Switchover bit (Internal/External Switchover mode is enabled)
 config FCMEN = ON       // Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is enabled)
 config LVP = OFF        // Low Voltage Programming Enable bit (RB3 pin has digital I/O, HV on MCLR must be used for programming)
 config DEBUG=ON
// CONFIG2
 config BOR4V = BOR40V   // Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
 config WRT = OFF        // Flash Program Memory Self Write Enable bits (Write protection off)
 
PSECT udata
tick:
    DS 1
counter:
    DS 1
counter2:
    DS 1
RESULTLO:
    DS 1
RESULTHI:
    DS 1

PSECT code
delay2:
movlw 0x08
movwf counter
counter_loop2:
movlw 0xff
movwf tick
tick_loop2:
decfsz tick,f
goto tick_loop2
decfsz counter,f
goto counter_loop2
return
    
PSECT resetVec,class=CODE,delta=2
resetVec:
goto main
        
PSECT main,class=CODE,delta=2
main:
BANKSEL TRISA ;
BSF TRISA,0 ;Set RA0 to input
BANKSEL ANSEL ;
BSF ANSEL,0 ;Set RA0 to analog
BANKSEL ADCON0 ;
MOVLW 0B10000001 ;ADC Frc clock,
MOVWF ADCON0 ;AN0, On
BANKSEL ADCON1 ;
MOVLW 0b00000000 ;right justify
MOVWF ADCON1 ;Vdd and Vss as Vref
BANKSEL OSCCON
movlw 0b01110000
Movwf OSCCON
BANKSEL TRISC
movlw 0b00000000
movwf TRISC
movlw 0b00000000
movwf TRISD
BANKSEL PORTC
movlw 0b00000000
movwf PORTC
movlw 0b00000000
movwf PORTD
INICIO:
call delay2
BSF ADCON0,1 ;Start conversion
BTFSC ADCON0,1 ;Is conversion done?
GOTO $-1 ;No, test again
BANKSEL ADRESH ;
MOVF ADRESH,W ;Read upper 8 bits
movwf PORTD
goto INICIO
END resetVec











