"""CC toolchain configuration for avr-gcc targeting ATmega32U4 (Arduino Pro Micro 5V/16MHz)."""

load("@rules_cc//cc/common:cc_common.bzl", "cc_common")
load(
    "@rules_cc//cc:cc_toolchain_config_lib.bzl",
    "feature",
    "flag_group",
    "flag_set",
    "tool_path",
)
load("@rules_cc//cc:action_names.bzl", "ACTION_NAMES")

_COMPILE_ACTIONS = [
    ACTION_NAMES.c_compile,
    ACTION_NAMES.cpp_compile,
    ACTION_NAMES.assemble,
    ACTION_NAMES.preprocess_assemble,
    ACTION_NAMES.cpp_header_parsing,
]

_LINK_ACTIONS = [
    ACTION_NAMES.cpp_link_executable,
    ACTION_NAMES.cpp_link_dynamic_library,
    ACTION_NAMES.cpp_link_nodeps_dynamic_library,
]

def _impl(ctx):
    bin = ctx.attr.avr_gcc_bin_dir
    tool_paths = [
        tool_path(name = "gcc",      path = bin + "/avr-gcc"),
        tool_path(name = "g++",      path = bin + "/avr-g++"),
        tool_path(name = "ar",       path = bin + "/avr-ar"),
        tool_path(name = "ld",       path = bin + "/avr-gcc"),
        tool_path(name = "cpp",      path = bin + "/avr-cpp"),
        tool_path(name = "nm",       path = bin + "/avr-nm"),
        tool_path(name = "objcopy",  path = bin + "/avr-objcopy"),
        tool_path(name = "objdump",  path = bin + "/avr-objdump"),
        tool_path(name = "strip",    path = bin + "/avr-strip"),
        tool_path(name = "gcov",     path = "/usr/bin/false"),
        tool_path(name = "dwp",      path = "/usr/bin/false"),
        tool_path(name = "llvm-cov", path = "/usr/bin/false"),
    ]

    # Flags common to all compile + link actions.
    avr_base = feature(
        name = "avr_base",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = _COMPILE_ACTIONS + _LINK_ACTIONS,
                flag_groups = [flag_group(flags = ["-mmcu=atmega32u4"])],
            ),
            flag_set(
                actions = _COMPILE_ACTIONS,
                flag_groups = [flag_group(flags = [
                    "-DF_CPU=8000000L",
                    "-DARDUINO=10607",
                    "-DARDUINO_AVR_PROMICRO",
                    "-DARDUINO_ARCH_AVR",
                    "-DUSB_VID=0x1b4f",
                    "-DUSB_PID=0x9204",
                    "-Os",
                    "-ffunction-sections",
                    "-fdata-sections",
                    "-flto",
                    # fat LTO embeds regular object code alongside the LTO IR so
                    # the linker can resolve symbols from .a archives normally while
                    # still doing whole-program optimization at link time.
                    "-ffat-lto-objects",
                ])],
            ),
        ],
    )

    cpp_flags = feature(
        name = "cpp_flags",
        enabled = True,
        flag_sets = [flag_set(
            actions = [ACTION_NAMES.cpp_compile],
            flag_groups = [flag_group(flags = [
                "-std=gnu++11",
                "-fpermissive",
                "-fno-exceptions",
                "-fno-threadsafe-statics",
                "-Wno-error=narrowing",
            ])],
        )],
    )

    c_flags = feature(
        name = "c_flags",
        enabled = True,
        flag_sets = [flag_set(
            actions = [ACTION_NAMES.c_compile],
            flag_groups = [flag_group(flags = ["-std=gnu11"])],
        )],
    )

    link_flags = feature(
        name = "link_flags",
        enabled = True,
        flag_sets = [flag_set(
            actions = _LINK_ACTIONS,
            flag_groups = [flag_group(flags = [
                "-Os",
                "-flto",
                "-Wl,--gc-sections",
            ])],
        )],
    )

    # AVR has no position-independent code or dynamic linking.
    supports_pic = feature(name = "supports_pic", enabled = False)
    supports_dynamic_linker = feature(name = "supports_dynamic_linker", enabled = False)

    avr_root = "/Users/dionisioperez-mavrogenis/Library/Arduino15/packages/arduino/tools/avr-gcc/7.3.0-atmel3.6.1-arduino7"

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        toolchain_identifier = "avr-gcc-atmega32u4",
        host_system_name = "x86_64-apple-darwin",
        target_system_name = "avr-unknown-none",
        target_cpu = "avr",
        target_libc = "avr-libc",
        compiler = "avr-gcc",
        abi_version = "avr-gcc-7.3.0",
        abi_libc_version = "avr-libc",
        tool_paths = tool_paths,
        features = [
            avr_base,
            cpp_flags,
            c_flags,
            link_flags,
            supports_pic,
            supports_dynamic_linker,
        ],
        # avr-gcc's built-in system include paths; declared here so Bazel does
        # not treat absolute paths from these directories as undeclared deps.
        cxx_builtin_include_directories = [
            avr_root + "/lib/gcc/avr/7.3.0/include",
            avr_root + "/lib/gcc/avr/7.3.0/include-fixed",
            avr_root + "/avr/include",
        ],
    )

avr_toolchain_config = rule(
    implementation = _impl,
    attrs = {
        "avr_gcc_bin_dir": attr.string(
            mandatory = True,
            doc = "Absolute path to the avr-gcc bin directory.",
        ),
    },
)
