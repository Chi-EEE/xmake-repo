package("quickjs-ng")
    set_homepage("https://github.com/quickjs-ng/quickjs")
    set_description("QuickJS, the Next Generation: a mighty JavaScript engine")
    set_license("MIT")

    add_urls("https://github.com/quickjs-ng/quickjs.git", {submodules = false})

    add_versions("18.11.2024", "55b67a6591071b2ada8895a7000e0fec5f348016")

    add_configs("libc", {description = "Build standard library modules as part of the library", default = false, type = "boolean"})

    if is_plat("linux", "bsd") then
        add_syslinks("m", "pthread")
    end

    if on_check then
        on_check("windows", function (package)
                local configs = {languages = "c11"}
                if package:has_tool("cc", "cl") then
                    configs.cflags = "/experimental:c11atomics"
                end
                assert(package:has_cincludes("stdatomic.h", {configs = configs}),
                "package(quickjs-ng) Requires at least C11 and stdatomic.h")
        end)
    end

    add_deps("mimalloc")
    add_deps("cmake")

    on_install(function (package)
        local configs = {"-DBUILD_CLI_WITH_STATIC_MIMALLOC=ON"}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        table.insert(configs, "-DCONFIG_ASAN=" .. (package:config("asan") and "ON" or "OFF"))
        table.insert(configs, "-DCONFIG_MSAN=" .. (package:config("msan") and "ON" or "OFF"))
        table.insert(configs, "-DCONFIG_UBSAN=" .. (package:config("ubsan") and "ON" or "OFF"))
        table.insert(configs, "-DBUILD_QJS_LIBC=" .. (package:config("libc") and "ON" or "OFF"))
        if package:config("shared") and package:is_plat("windows") then
            table.insert(configs, "-DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON")
        end
        import("package.tools.cmake").install(package, configs)
        os.cp("quickjs.h", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("JS_NewRuntime", {includes = "quickjs.h"}))
    end)
