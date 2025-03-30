#include "Keyboard.h"
#include <Mouse.h>
#include <ezButton.h>

// #define DEBUG
#define PIN_SLOT_1_BTN 3
#define PIN_SLOT_1_TOGGLE 2
#define PIN_SLOT_2_BTN 5
#define PIN_SLOT_2_TOGGLE 4
#define PIN_SLOT_3_BTN 7
#define PIN_SLOT_3_TOGGLE 6
#define PIN_SLOT_4_BTN 8
#define PIN_SLOT_4_TOGGLE 9

#define WAIT_BETWEEN_KEY_PRESS 75
#define DEBOUNCE_TIME 50

// button 1
const char reinforceCode[] = "wsdaw";
const char stalwartCode[] = "saswwa";

// button 2
const char resupplyCode[] = "sswd";
const char guardDogRoverCode[] = "swawds";

// button 3
const char sentryAutocannonCode[] = "swdwaw";
const char machineGunCode[] = "saswd";

// button 4
const char eagleNapalmAirstrikeCode[] = "ddsadw";
const char fiveHundredKgAirstrikeCode[] = "wdsss";

// create buttons
ezButton slot_1(PIN_SLOT_1_BTN, INPUT_PULLUP);
ezButton slot_2(PIN_SLOT_2_BTN, INPUT_PULLUP);
ezButton slot_3(PIN_SLOT_3_BTN, INPUT_PULLUP);
ezButton slot_4(PIN_SLOT_4_BTN, INPUT_PULLUP);

// create debouncer
long lastSwitchDetectedMIllis;
const long multiTriggerPreventionInterval = 300;

void setup() {
  Serial.begin(9600);

  // debouncer
  lastSwitchDetectedMIllis = millis();

  // setup toggles
  pinMode(PIN_SLOT_1_TOGGLE, INPUT);
  pinMode(PIN_SLOT_2_TOGGLE, INPUT);
  pinMode(PIN_SLOT_3_TOGGLE, INPUT);
  pinMode(PIN_SLOT_4_TOGGLE, INPUT);

  // setup buttons
  slot_1.setDebounceTime(DEBOUNCE_TIME);
  slot_2.setDebounceTime(DEBOUNCE_TIME);
  slot_3.setDebounceTime(DEBOUNCE_TIME);
  slot_4.setDebounceTime(DEBOUNCE_TIME);

  // start kbd/mouse libraries
  Keyboard.begin();
  Mouse.begin();

  // feedback for debugging
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  slot_1.loop();
  slot_2.loop();
  slot_3.loop();
  slot_4.loop();

  if (slot_1.isPressed()) {
    callStratagem(reinforceCode, stalwartCode, PIN_SLOT_1_TOGGLE);
  } else if (slot_2.isPressed()) {
    callStratagem(resupplyCode, guardDogRoverCode, PIN_SLOT_2_TOGGLE);
  } else if (slot_3.isPressed()) {
    callStratagem(sentryAutocannonCode, machineGunCode, PIN_SLOT_3_TOGGLE);
  } else if (slot_4.isPressed()) {
    callStratagem(eagleNapalmAirstrikeCode, fiveHundredKgAirstrikeCode, PIN_SLOT_4_TOGGLE);
  }
}

void callStratagem(char primaryStratagem[], char secondaryStratagem[], int mode_pin) {
  if (millis() - lastSwitchDetectedMIllis < multiTriggerPreventionInterval) {
#ifdef DEBUG
    Serial.println("spotted multiple bounces");
#endif
    return;
  }

  lastSwitchDetectedMIllis = millis();

  digitalWrite(LED_BUILTIN, HIGH);  // turn the LED on (HIGH is the voltage level)
  delay(50);                        // wait for a second
  digitalWrite(LED_BUILTIN, LOW);   // turn the LED off by making the voltage LOW

  int p = digitalRead(mode_pin);
  char *s = p == 1 ? primaryStratagem : secondaryStratagem;

#ifdef DEBUG
  Serial.print(p);
  Serial.print(" ");
  Serial.println(s);
  return;
#endif

  Keyboard.press(KEY_LEFT_CTRL);
  delay(WAIT_BETWEEN_KEY_PRESS);

  for (int i = 0; i < strlen(s); i++) {
    char c = s[i];

    Keyboard.press(c);
    delay(WAIT_BETWEEN_KEY_PRESS);
    Keyboard.release(c);
    delay(WAIT_BETWEEN_KEY_PRESS);
  }

  Mouse.press();
  delay(WAIT_BETWEEN_KEY_PRESS);
  Mouse.release();

  Keyboard.releaseAll();
}