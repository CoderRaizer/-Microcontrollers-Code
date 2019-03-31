#include <mega16.h>
#include <delay.h>

int i,t,c,dv,j=0;
int led7[10] = {0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90};


void main(void)
{

PORTA=0x00;
DDRA=0xFF;
PORTB=0x00;
DDRB=0x00;
PORTC=0x00;
DDRC=0xFF;
PORTD=0x00;
DDRD=0x00;
TCCR0=0x07;
TCNT0=0x00;
OCR0=0x00;
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;
MCUCR=0x00;
MCUCSR=0x00;
TIMSK=0x00;
UCSRB=0x00;
ACSR=0x80;
SFIOR=0x00;
ADCSRA=0x00;
SPCR=0x00;
TWCR=0x00;

while (1)
      {
        i = TCNT0;
        if(i == 10){
        j++;
        TCNT0 = 0;
        }
        
        t = i/100;
        c = (i/10)%10;
        dv = i%10;
        
        PORTC = led7[t];
        PORTA = 0x02;
        delay_ms(2);
        PORTC = 0xff;//tat led
        
        PORTC = led7[c];
        PORTA = 0x04;
        delay_ms(2);
        PORTC = 0xff;//tat led
        
        PORTC = led7[dv];
        PORTA = 0x08;
        delay_ms(2);
        PORTC = 0xff;//tat led
        
        PORTC = led7[j];
        PORTA = 0x01;
        delay_ms(1);
        PORTC = 0xff;
      }    
      
}
