/*
 * File:   13A-777-A.c
 * Author: Nolan
 *
 * Created on January 29, 2023, 8:00 PM
 */


#include <xc.h>
// GAME SELECTION
#include <LuckyNumberGenerator.h>
//#include <LuckTracker.h>
//#include <IChing.h>

// HARDWARE FUNCTIONALITY
// for LCD commands/settings
#define CLEAR_DISPLAY 0x01
#define CURSOR_HOME 0x02
#define FUNCTION_SETTINGS 0x28
#define DISPLAY_SETTINGS 0x0C
#define ENTRY_MODE 0x06
#define SHIFT_CURSOR_RIGHT 0x14
#define SHIFT_CURSOR_LEFT 0x10
#define ROW1 0x80
#define ROW2 0xC0

// for LCD pins
#define RS RB4
#define RS_TRIS TRISB4
#define RW RB5
#define RW_TRIS TRISB5
#define EN RB6
#define EN_TRIS TRISB6
#define D4 RC0
#define D4_TRIS TRISC0
#define D5 RC1
#define D5_TRIS TRISC1
#define D6 RC2
#define D6_TRIS TRISC2
#define D7 RC3
#define D7_TRIS TRISC3

// LCD Functions
void tmr0_delay(char a);
void lcd_en(char a);
void lcd_port(char a, char b, char c);
void lcd_cmd(char a, char b, char c);
void lcd_set_cursor(char a, char b);
void lcd_init(void);
void lcd_write_char(char a);
void lcd_write_string(char *a);
void lcd_contrast(void);
void lcd_backlight(void);

void encoder_init(void);
void encoder_rotation(char steps, char direction);
void encoder_light(char color, char brightness);
void encoder_button(char a);

void power_init(void);
void power_statemachine(char steps, char direction);
void power_batteryvoltage(void);

void button_init(void);
void button_isr(void);
 

void tmr0_delay(char a){
    TMR0IE = 0;
    TMR0IF = 0;
    TMR0 = 0x00;
    OPTION_REG = a;
    while(!TMR0IF);
}

void lcd_en(char a){ //EN is triggered by a falling edge
    EN_TRIS = 0;
    EN  = 1;
    tmr0_delay(a);
    EN  = 0;
    tmr0_delay(a);
}

void lcd_port(char a, char b, char c){
    // 4-BIT MODE
    // "&" is a bit-wise logical operand
    // four high bits
    if(a & 0x10) D4 = 1; else D4 = 0;
    if(a & 0x20) D5 = 1; else D5 = 0;
    if(a & 0x40) D6 = 1; else D6 = 0;
    if(a & 0x80) D7 = 1; else D7 = 0;
    lcd_en(b);
    // four low bits
    if(a & 0x01) D4 = 1; else D4 = 0;
    if(a & 0x02) D5 = 1; else D5 = 0;
    if(a & 0x04) D6 = 1; else D6 = 0;
    if(a & 0x08) D7 = 1; else D7 = 0;
    lcd_en(c);
}

void lcd_cmd(char a, char b, char c){
    RS_TRIS = 0;
    RS = 0;     // command
    RW_TRIS = 0;
    RW = 0;     // write
    D4_TRIS = 0;
    D5_TRIS = 0;
    D6_TRIS = 0;
    D7_TRIS = 0;
    lcd_port(a,b,c);
}

void lcd_set_cursor(char a, char b){
    char temp;
    if(a == 1)
{
    temp = ROW1 + b;
    lcd_cmd(temp, 0x00, 0x00);
}
    else if(a == 2)
{
    temp = ROW2 + b;
    lcd_cmd(temp, 0x00, 0x00);
}
}

void lcd_init(void){
    // configure pins - specific to PIC16F1829
    ANSELC = 0;     // digital
    WPUC = 0;       // disabled weak pull up
    TRISC = 0;      // outputs
    PORTC = 0;
    ANSELB = 0;     // digital
    WPUB = 0;       // disabled weak pull up
    TRISB7 = 0;     // outputs
    PORTB = 0;
    // delay for LCD power up
    tmr0_delay(0);
    //configure lcd
    // 4-BIT MODE
    RS_TRIS = 0;
    RS = 0;     // command
    RW_TRIS = 0;
    RW = 0;     // write
    D7 = 0;
    D6 = 0;
    D5 = 1;
    D4 = 0;
    lcd_en(0);
    // standard configuration
    lcd_cmd(FUNCTION_SETTINGS, 0x00, 0x00);
    lcd_cmd(CLEAR_DISPLAY, 0x00, 0x00);
    lcd_cmd(DISPLAY_SETTINGS, 0x00, 0x00);
    lcd_cmd(CURSOR_HOME, 0x00, 0x00);
}

void lcd_write_char(char a){
   RS_TRIS = 0;
   RS = 1;          // data
   RW_TRIS = 0;
   RW = 0;          // write
   D4_TRIS = 0;
   D5_TRIS = 0;
   D6_TRIS = 0;
   D7_TRIS = 0;
   lcd_port(a, 0x00, 0x00);
}

void lcd_write_string(char *a){
    int i;
    for(i=0;a[i]!='\0';i++)
    lcd_write_char(a[i]);
}

// LCD
void setContrast(char);
void setBacklight(char);
void refreshScreen(void);

// Power Management
void sleepDeep(void);
void sleepActive(void);
void activeGame(void);
void batteryVoltage(void);

// LED
void setLED(char);
void clearLED(void);
void toggleLED(void);

// Button
void isr_readSelectButton(void);

// Encoder
void setEncoderRGB(void);
void readEncoderButton(void);
void readEncoderRotation(void);

// Timer
void setTimer(void);
void getTimer(void);
void incTimer(void);
void spareTime(void);
void timerRatio(void);

// Histogram
void writeHistogram(void);
void writeHistogramValue(void);
void playHistogram(void);
void readHistorgram(void);
void readHistogramValue(void);

