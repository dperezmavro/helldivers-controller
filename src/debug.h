#ifndef _DEBUG

#define _DEBUG

// #define DEBUG

#ifdef DEBUG
#define SERIAL_DEBUG(x) Serial.println(x);
#else
#define SERIAL_DEBUG(x)
#endif

#endif