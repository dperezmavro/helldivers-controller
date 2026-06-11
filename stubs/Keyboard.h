#pragma once
// Stub for clang-tidy host-side analysis.
// The real Keyboard.h extends HID/USB classes that depend on AVR USB
// descriptor types (InterfaceDescriptor, USBSetup, etc.) unavailable to clang.
#include <stdint.h>

#define KEY_LEFT_CTRL 0x80

class Keyboard_ {
public:
    void begin();
    void press(uint8_t key);
    void release(uint8_t key);
    void releaseAll();
};
extern Keyboard_ Keyboard;
