load("@rules_cc//cc:defs.bzl", "cc_library")

# External BUILD file for @arduino_avr_core (Arduino AVR Core 1.8.8).
# The board variant (pins_arduino.h) comes from @sparkfun_avr//:promicro_variant.

cc_library(
    name = "arduino_core",
    srcs = glob([
        "cores/arduino/*.c",
        "cores/arduino/*.cpp",
        "cores/arduino/*.S",
    ]),
    hdrs = glob(["cores/arduino/*.h"]) + [
        "cores/arduino/new",  # extensionless header included by new.cpp
    ],
    includes = ["cores/arduino"],
    deps = ["@sparkfun_avr//:promicro_variant"],
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
