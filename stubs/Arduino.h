#pragma once
// Stub for clang-tidy host-side analysis.
// The real Arduino.h transitively includes avr-gcc headers with AVR inline
// assembly (util/delay_basic.h) that clang cannot parse.
#include <stddef.h>
#include <stdint.h>
#include <string.h>

#define HIGH          1
#define LOW           0
#define INPUT         0
#define OUTPUT        1
#define INPUT_PULLUP  2
#define LED_BUILTIN   17

unsigned long millis();
void          delay(unsigned long ms);
int           digitalRead(int pin);
void          digitalWrite(int pin, int val);
void          pinMode(int pin, int mode);

class HardwareSerial {
public:
    void begin(unsigned long baud);
    void print(int);
    void print(const char*);
    void println(int);
    void println(const char*);
};
extern HardwareSerial Serial;
