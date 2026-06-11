load("@rules_cc//cc:defs.bzl", "cc_library")

# External BUILD file for @arduino_mouse (Arduino Mouse library).

cc_library(
    name = "mouse",
    srcs = ["src/Mouse.cpp"],
    hdrs = ["src/Mouse.h"],
    includes = ["src"],
    deps = ["@arduino_avr_core//:hid"],
    visibility = ["//visibility:public"],
)
