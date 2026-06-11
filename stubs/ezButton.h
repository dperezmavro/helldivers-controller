#pragma once
// Stub for clang-tidy host-side analysis.
// ezButton.h itself is pure C++ but includes Arduino.h; the stub Arduino.h
// satisfies that dependency cleanly.
#include "Arduino.h"

class ezButton {
public:
    explicit ezButton(int pin, int buttonType = INPUT_PULLUP) noexcept;
    void loop();
    bool isPressed() const;
    void setDebounceTime(unsigned long ms);
};
