#ifndef _TIME_CONSTANTS

#define _TIME_CONSTANTS

// Timing (milliseconds)
constexpr unsigned long WAIT_BETWEEN_KEY_PRESS_MS   = 75;
constexpr unsigned long DEBOUNCE_TIME_MS            = 50;
constexpr unsigned long LED_FEEDBACK_MS             = 50;
constexpr unsigned long MULTI_TRIGGER_PREVENTION_MS = 300;
// unsigned long to match millis() return type and avoid overflow in subtraction
unsigned long lastSwitchDetectedMillis = 0;

#endif