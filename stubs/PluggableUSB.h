#pragma once
// Minimal stub used by clang-tidy (host-side analysis).
// HID.h includes PluggableUSB.h; the real version depends on USB/AVR types
// defined in the Arduino core that are not available to the host clang.
class PluggableUSBModule {};
