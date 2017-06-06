#include<avr/io.h>
#include"delay.h"
int main(void)
{
     PORTD=0x00;
     DDRD=0xF0;
     PORTB=0x00;
     DDRB=0x0F;
     while(1)
     {
     PORTB = 0x88;
     delayms(20);
     PORTB = 0x44;
     delayms(20);
     PORTB = 0x22;
     delayms(20);
     PORTB = 0x11;
     delayms(20);
} }