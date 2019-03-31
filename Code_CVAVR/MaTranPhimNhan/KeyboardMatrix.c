#include <mega16.h>
#include <delay.h>

void main(void)
{
    unsigned char i = 0xff;
    int index = 0;
    unsigned char a = 0xff;
    unsigned char b = 0xff;
    unsigned char c = 0xff;
    unsigned char d = 0xff;
    
PORTA=0x00;
DDRA=0x00;
PORTB=0x00;
DDRB=0xFF;
PORTC=0x00;
DDRC=0x00;
PORTD=0x00;
DDRD=0xFF;
TCCR0=0x00;
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
        // Place your code her
        if(index > 4){ index = 4; }
        
        if(index == 1){
        PORTB = a;PORTD = 0x80;delay_ms(20);
        }
        
        else if(index == 2){
        PORTB = b;PORTD = 0x80;delay_ms(20);
        PORTB = a;PORTD = 0x40;delay_ms(20);
        }
        
        else if(index == 3){
        PORTB = c;PORTD = 0x80;delay_ms(20);
        PORTB = b;PORTD = 0x40;delay_ms(20);
        PORTB = a;PORTD = 0x20;delay_ms(20);
        }
        
        else if(index == 4){
        PORTB = d;PORTD = 0x80;delay_ms(20);
        PORTB = c;PORTD = 0x40;delay_ms(20);
        PORTB = b;PORTD = 0x20;delay_ms(20);
        PORTB = a;PORTD = 0x10;delay_ms(20);
        }

        delay_ms(20);
        
        
        PORTD = 0x01;//0001 -> cot 0
        switch(PINC)
        {   
            //hang 0
            case 0x01:{i = 0xc0;index++;break;}//0
            //hang 1
            case 0x02:{i = 0xF9;index++;break;}//1
            //hang 2
            case 0x04:{i = 0xA4;index++;break;}//2
            //hang 3
            case 0x08:{i = 0xB0;index++;break;}//3
        }

        PORTD = 0x02;//0010 -> cot 1
        switch(PINC)
        {   
            //hang 0
            case 0x01:{i = 0x99;index++;break;}//4
            //hang 1
            case 0x02:{i = 0x92;index++;break;}//5
            //hang 2
            case 0x04:{i = 0x82;index++;break;}//6
            //hang 3
            case 0x08:{i = 0xf8;index++;break;}//7
        }

        PORTD = 0x04;//0100 -> cot 2
        switch(PINC)
        {   
            //hang 0
            case 0x01:{i = 0x80;index++;break;}//8
            //hang 1
            case 0x02:{i = 0x90;index++;break;}//9
            //hang 2
            case 0x04:{i = 0x88;index++;break;}//A
            //hang 3
            case 0x08:{i = 0x83;index++;break;}//B
        }

        PORTD = 0x08;//1000 -> cot 3
        switch(PINC)
        {   
            //hang 0
            case 0x01:{i = 0xC6;index++;break;}//C
            //hang 1
            case 0x02:{i = 0xA1;index++;break;}//D
            //hang 2
            case 0x04:{i = 0x86;index++;break;}//E
            //hang 3
            case 0x08:{i = 0x8E;index++;break;}//F
        }

        if(index == 1){a=i;}
        else if(index == 2){b=i;}
        else if(index == 3){c=i;}
        else if(index == 4){d=i;}
      
      }
}

