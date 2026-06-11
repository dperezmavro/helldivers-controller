load("@rules_cc//cc:defs.bzl", "cc_library")

# External BUILD file for @arduino_keyboard (Arduino Keyboard library).

cc_library(
    name = "keyboard",
    srcs = glob(["src/*.cpp"]),
    hdrs = glob(["src/*.h"]),
    includes = ["src"],
    deps = ["@arduino_avr_core//:hid"],
    visibility = ["//visibility:public"],
)
