load("@rules_cc//cc:defs.bzl", "cc_library")

# External BUILD file for @ezbutton (ezButton 1.0.6).
# Install with: arduino-cli lib install "ezButton"

cc_library(
    name = "ezbutton",
    srcs = ["src/ezButton.cpp"],
    hdrs = ["src/ezButton.h"],
    includes = ["src"],
    deps = ["@arduino_avr_core//:arduino_core"],
    visibility = ["//visibility:public"],
)
