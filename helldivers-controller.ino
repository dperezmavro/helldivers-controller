#include <Arduino.h>
#include <Keyboard.h>
#include <Mouse.h>
#include <ezButton.h>

#include "stratagem-assignments.h"

// #define DEBUG

#ifdef DEBUG
#define SERIAL_DEBUG(x) Serial.println(x);
#else
#define SERIAL_DEBUG(x)
#endif

// Pin assignments
constexpr int PIN_SLOT_1_BTN    = 3;
constexpr int PIN_SLOT_1_TOGGLE = 2;
constexpr int PIN_SLOT_2_BTN    = 5;
constexpr int PIN_SLOT_2_TOGGLE = 4;
constexpr int PIN_SLOT_3_BTN    = 7;
constexpr int PIN_SLOT_3_TOGGLE = 6;
constexpr int PIN_SLOT_4_BTN    = 8;
constexpr int PIN_SLOT_4_TOGGLE = 9;

// Timing (milliseconds)
constexpr unsigned long WAIT_BETWEEN_KEY_PRESS_MS   = 75;
constexpr unsigned long DEBOUNCE_TIME_MS            = 50;
constexpr unsigned long LED_FEEDBACK_MS             = 50;
constexpr unsigned long MULTI_TRIGGER_PREVENTION_MS = 300;

ezButton slot1(PIN_SLOT_1_BTN, INPUT_PULLUP);
ezButton slot2(PIN_SLOT_2_BTN, INPUT_PULLUP);
ezButton slot3(PIN_SLOT_3_BTN, INPUT_PULLUP);
ezButton slot4(PIN_SLOT_4_BTN, INPUT_PULLUP);

// unsigned long to match millis() return type and avoid overflow in subtraction
unsigned long lastSwitchDetectedMillis = 0;

void callStratagem(const char* primary, const char* secondary, int modePin);

void setup() {
  Serial.begin(9600);

  lastSwitchDetectedMillis = millis();

  pinMode(PIN_SLOT_1_TOGGLE, INPUT);
  pinMode(PIN_SLOT_2_TOGGLE, INPUT);
  pinMode(PIN_SLOT_3_TOGGLE, INPUT);
  pinMode(PIN_SLOT_4_TOGGLE, INPUT);

  slot1.setDebounceTime(DEBOUNCE_TIME_MS);
  slot2.setDebounceTime(DEBOUNCE_TIME_MS);
  slot3.setDebounceTime(DEBOUNCE_TIME_MS);
  slot4.setDebounceTime(DEBOUNCE_TIME_MS);

  Keyboard.begin();
  Mouse.begin();

  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  slot1.loop();
  slot2.loop();
  slot3.loop();
  slot4.loop();

  if (slot1.isPressed()) {
    callStratagem(REINFORCE_CODE, STALWART_CODE, PIN_SLOT_1_TOGGLE);
  } else if (slot2.isPressed()) {
    callStratagem(RESUPPLY_CODE, GUARD_DOG_ROVER_CODE, PIN_SLOT_2_TOGGLE);
  } else if (slot3.isPressed()) {
    callStratagem(SENTRY_AUTOCANNON_CODE, MACHINE_GUN_CODE, PIN_SLOT_3_TOGGLE);
  } else if (slot4.isPressed()) {
    callStratagem(EAGLE_NAPALM_AIRSTRIKE_CODE, FIVE_HUNDRED_KG_AIRSTRIKE_CODE, PIN_SLOT_4_TOGGLE);
  }
}

void callStratagem(const char* primary, const char* secondary, int modePin) {
  if (millis() - lastSwitchDetectedMillis < MULTI_TRIGGER_PREVENTION_MS) {
    SERIAL_DEBUG("spotted multiple bounces");
    return;
  }

  lastSwitchDetectedMillis = millis();

  digitalWrite(LED_BUILTIN, HIGH);
  delay(LED_FEEDBACK_MS);
  digitalWrite(LED_BUILTIN, LOW);

  const bool  isPrimary = (digitalRead(modePin) == HIGH);
  const char* stratagem = isPrimary ? primary : secondary;

  SERIAL_DEBUG(isPrimary);
  SERIAL_DEBUG(" ");
  SERIAL_DEBUG(stratagem);
#ifdef DEBUG
  return;
#endif

  Keyboard.press(KEY_LEFT_CTRL);
  delay(WAIT_BETWEEN_KEY_PRESS_MS);

  const size_t len = strlen(stratagem);
  for (size_t i = 0; i < len; ++i) {
    Keyboard.press(static_cast<uint8_t>(stratagem[i]));
    delay(WAIT_BETWEEN_KEY_PRESS_MS);
    Keyboard.release(static_cast<uint8_t>(stratagem[i]));
    delay(WAIT_BETWEEN_KEY_PRESS_MS);
  }

  Mouse.press();
  delay(WAIT_BETWEEN_KEY_PRESS_MS);
  Mouse.release();

  Keyboard.releaseAll();
}
