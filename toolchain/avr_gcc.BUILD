# External BUILD file for @avr_gcc (avr-gcc 7.3.0-atmel3.6.1-arduino7, macOS x86_64).

# Single-file target used by avr_toolchain_config to derive all tool paths.
filegroup(
    name = "avr_gcc_binary",
    srcs = ["bin/avr-gcc"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "all",
    srcs = glob(
        ["bin/**", "lib/**", "include/**", "avr/**", "libexec/**"],
        allow_empty = True,
    ),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "compiler_files",
    srcs = glob(
        ["bin/avr-gcc*", "bin/avr-g++*", "bin/avr-cpp*",
         "lib/**", "include/**", "avr/**", "libexec/**"],
        allow_empty = True,
    ),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "linker_files",
    srcs = glob(
        ["bin/avr-gcc*", "lib/**", "avr/**"],
        allow_empty = True,
    ),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "ar_files",
    srcs = ["bin/avr-ar"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "as_files",
    srcs = ["bin/avr-as"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "objcopy_files",
    srcs = ["bin/avr-objcopy"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "strip_files",
    srcs = ["bin/avr-strip"],
    visibility = ["//visibility:public"],
)
