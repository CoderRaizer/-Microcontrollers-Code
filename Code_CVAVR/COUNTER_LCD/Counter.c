#include <mega16.h>
#include <delay.h>
#include <alcd.h>
int i = 0;//so san pham
int t,c,dv;//bieu dien so san pham
int j = 0;//so thung
int a,b,c;//bieu dien so thung
int t,c,dv;
int valueAt = 0;
int update = 0;


void main(void)
{

PORTA=0x00;
DDRA=0x00;
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


lcd_init(16);
i = TCNT0;
valueAt = i;
while (1)
      {
        
       i = TCNT0;
       if(i != valueAt){
            valueAt = i;
            update = 1;  
       }

       if(update == 1 && i % 10 == 0){
            j++;//tang so thung
       }
       
       if(j > 9){
            a = j/100;
            b = (j/10)%10;
            c = j%10;
       }
       
       t = i/100;
       c = (i/10)%10;
       dv = i%10;
       
       lcd_gotoxy(0,0);
       lcd_puts("So SP: ");
       lcd_gotoxy(10,0);
       lcd_putchar(t+48);//+48 la chuyen ra ma ASCII
       lcd_putchar(c+48);//+48 la chuyen ra ma ASCII
       lcd_putchar(dv+48);//+48 la chuyen ra ma ASCII
       
       lcd_gotoxy(0,1);
       lcd_puts("So Thung: ");
       if(j <= 9){
           lcd_putchar(j+48);
       } else {
            lcd_putchar(a+48);//+48 la chuyen ra ma ASCII
            lcd_putchar(b+48);//+48 la chuyen ra ma ASCII
            lcd_putchar(c+48);//+48 la chuyen ra ma ASCII  
       }
       
       update = 0;//tat su kien
       
      }
}
