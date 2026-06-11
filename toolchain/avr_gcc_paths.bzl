"""Captures Bazel's cache root so the cc toolchain can list it in
cxx_builtin_include_directories. http_archive places content under
<cache_root>/cache/repos/... and sandboxed actions under
<cache_root>/<output_base>/sandbox/...; both prefixes need to count
as builtin or gcc's absolute-path includes are flagged as undeclared."""

def _impl(rctx):
    p = str(rctx.path(Label("@avr_gcc//:bin/avr-gcc")).realpath)
    idx = p.find("/cache/repos/")
    bazel_root = p[:idx] if idx > 0 else p
    rctx.file("BUILD.bazel", "")
    rctx.file("paths.bzl", "BAZEL_CACHE_ROOT = %r\n" % bazel_root)

avr_gcc_paths = repository_rule(implementation = _impl)
