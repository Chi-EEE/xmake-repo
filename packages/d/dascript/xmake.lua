package("dascript")
    set_homepage("https://daslang.io")
    set_description("daslang - high-performance statically strong typed scripting language")
    set_license("BSD-3-Clause")

    add_urls("https://github.com/GaijinEntertainment/daScript.git", {submodules = false})
    add_versions("0.5", "d1857f889ca7420d042fcedaadb246b6a76775c0")

    add_deps("bison", "flex")
    add_deps("cmake")

    on_install(function (package)
        io.replace("CMakeLists.txt", "libDaScriptTest", "", {plain = true})
        local configs = {
            "-DDAS_FLEX_BISON_DISABLED=OFF",
            "-DDAS_CLANG_BIND_DISABLED=ON",
            "-DDAS_LLVM_DISABLED=ON",
            "-DDAS_QUIRREL_DISABLED=ON",
            "-DDAS_HV_DISABLED=ON",
            "-DDAS_GLFW_DISABLED=ON",-- off
            "-DDAS_IMGUI_DISABLED=ON",
            "-DDAS_BGFX_DISABLED=ON",
            "-DDAS_XBYAK_DISABLED=ON",
            "-DDAS_MINFFT_DISABLED=ON",
            "-DDAS_AUDIO_DISABLED=ON",
            "-DDAS_STDDLG_DISABLED=ON",-- off
            "-DDAS_STBIMAGE_DISABLED=ON",-- off
            "-DDAS_STBTRUETYPE_DISABLED=ON",-- off
            "-DDAS_SFML_DISABLED=ON",
            "-DDAS_PUGIXML_DISABLED=ON",
            "-DDAS_SQLITE_DISABLED=ON",
            "-DDAS_TOOLS_DISABLED=ON",-- off
            "-DDAS_AOT_EXAMPLES_DISABLED=ON",-- off
            "-DDAS_PROFILE_DISABLED=ON",-- off
            "-DDAS_TUTORIAL_DISABLED=ON",-- off
            "-DDAS_TESTS_DISABLED=ON"-- off
        }
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include "daScript/daScript.h"
            void test() {
                das::vector<string> files;
            }
        ]]}, {configs = {languages = "cxx17"}}))
    end)
