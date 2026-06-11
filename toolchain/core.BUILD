load("@rules_cc//cc:defs.bzl", "cc_library")

# External BUILD file for @arduino_avr_core (Arduino AVR Core 1.8.8).
# Uses the Arduino Micro (ATmega32U4) variant, which is pin-compatible with
# the SparkFun Pro Micro for the digital pins this project uses (2-9).

cc_library(
    name = "arduino_core",
    srcs = glob([
        "cores/arduino/*.c",
        "cores/arduino/*.cpp",
        "cores/arduino/*.S",
    ]),
    hdrs = glob([
        "cores/arduino/*.h",
        "variants/**/*.h",  # micro/pins_arduino.h includes ../leonardo/pins_arduino.h
    ]) + [
        "cores/arduino/new",  # extensionless header included by new.cpp
    ],
    includes = [
        "cores/arduino",
        "variants/micro",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "hid",
    srcs = ["libraries/HID/src/HID.cpp"],
    hdrs = ["libraries/HID/src/HID.h"],
    includes = ["libraries/HID/src"],
    deps = [":arduino_core"],
    visibility = ["//visibility:public"],
)
