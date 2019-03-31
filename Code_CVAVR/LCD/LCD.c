#include <mega16.h>
#include <delay.h>
#include <alcd.h>


void main(void)
{


   int dem = 0;
   int a;//hang chuc
   int b;//hang don vi





PORTA=0x00;
DDRA=0x00;

PORTB=0x00;
DDRB=0x00;

PORTC=0x00;
DDRC=0x00;


PORTD=0x00;
DDRD=0x00;


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

lcd_init(16);

while (1)
      {
      


           a = dem/10;
           b = dem%10;
           lcd_gotoxy(0,0);
           lcd_puts("Counter:");
           lcd_gotoxy(9,0);
           if(dem <= 9)
           {lcd_putchar(b+0x30);}
           if(dem > 9)
           {lcd_putchar(a+0x30);lcd_putchar(b+0x30);}
           delay_ms(20);
           dem++;
           if(dem > 99)
           {dem = 0;lcd_gotoxy(10,0);lcd_puts(" ");}
      }
}
