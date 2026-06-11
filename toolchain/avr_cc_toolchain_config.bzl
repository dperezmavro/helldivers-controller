"""CC toolchain configuration for avr-gcc targeting ATmega32U4 (Arduino Pro Micro 3.3V/8MHz)."""

load("@avr_gcc_paths//:paths.bzl", "BAZEL_CACHE_ROOT")
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
    # tool_paths must be normalised (no ".."), so we use wrapper scripts that
    # live inside the toolchain/ package and locate the real binaries at
    # runtime by scanning Bazel's external/ directory.  This works for both
    # new_local_repository and http_archive without any hardcoded paths.
    tool_paths = [
        tool_path(name = "gcc",      path = "wrappers/avr-gcc"),
        tool_path(name = "g++",      path = "wrappers/avr-g++"),
        tool_path(name = "ar",       path = "wrappers/avr-ar"),
        tool_path(name = "ld",       path = "wrappers/avr-gcc"),
        tool_path(name = "cpp",      path = "wrappers/avr-cpp"),
        tool_path(name = "nm",       path = "wrappers/avr-nm"),
        tool_path(name = "objcopy",  path = "wrappers/avr-objcopy"),
        tool_path(name = "objdump",  path = "wrappers/avr-objdump"),
        tool_path(name = "strip",    path = "wrappers/avr-strip"),
        tool_path(name = "gcov",     path = "/usr/bin/false"),
        tool_path(name = "dwp",      path = "/usr/bin/false"),
        tool_path(name = "llvm-cov", path = "/usr/bin/false"),
    ]

    # Derive the avr-gcc repository root from the binary label so that
    # cxx_builtin_include_directories stay correct for any repo type.
    # ctx.file.avr_gcc.path is execroot-relative, e.g.:
    #   "external/+http_archive+avr_gcc/bin/avr-gcc"
    avr_repo_root = ctx.file.avr_gcc.path[:-len("/bin/avr-gcc")]

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
                    # Keep dependency-file paths execroot-relative so they match
                    # cxx_builtin_include_directories (avr-gcc would otherwise
                    # resolve symlinks into Bazel's CAS giving absolute paths).
                    "-no-canonical-prefixes",
                    "-fno-canonical-system-headers",
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
        # avr-gcc's built-in system include paths (execroot-relative).
        # Declared here so Bazel does not treat absolute paths from these
        # directories as undeclared dependencies.
        # Execroot-relative paths cover most actions; BAZEL_CACHE_ROOT covers
        # the absolute paths gcc reports from CAS or sandbox execroots.
        cxx_builtin_include_directories = [
            avr_repo_root + "/avr/include",
            avr_repo_root + "/lib/gcc/avr/7.3.0/include",
            avr_repo_root + "/lib/gcc/avr/7.3.0/include-fixed",
            BAZEL_CACHE_ROOT,
        ],
    )

avr_toolchain_config = rule(
    implementation = _impl,
    attrs = {
        "avr_gcc": attr.label(
            mandatory = True,
            allow_single_file = True,
            doc = "The avr-gcc binary. Used to derive cxx_builtin_include_directories.",
        ),
    },
)
