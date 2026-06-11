#pragma once
// Stub for clang-tidy host-side analysis.
// Same reasoning as Keyboard.h — real Mouse.h depends on AVR USB infrastructure.
#include <stdint.h>

#define MOUSE_LEFT 1

class Mouse_ {
public:
    void begin();
    void press(uint8_t button = MOUSE_LEFT);
    void release(uint8_t button = MOUSE_LEFT);
};
extern Mouse_ Mouse;
