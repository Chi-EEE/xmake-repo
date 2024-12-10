package("freeimage")

    set_homepage("https://sourceforge.net/projects/freeimage/")
    set_description("FreeImage is a library project for developers who would like to support popular graphics image formats (PNG, JPEG, TIFF, BMP and others).")

    add_urls("https://sourceforge.net/projects/freeimage/files/Source%20Distribution/$(version).zip", {version = function (version)
        return version .. "/FreeImage" .. version:gsub("%.", "")
    end})
    add_versions("3.18.0", "f41379682f9ada94ea7b34fe86bf9ee00935a3147be41b6569c9605a53e438fd")

    add_patches("3.18.0", path.join(os.scriptdir(), "patches", "3.18.0", "libjxr.patch"), "fddbb9fa736da383f54352dc0ab848d083d9279b66cc6ac53910236144ad75ab")
	add_patches("3.18.0", path.join(os.scriptdir(), "patches", "3.18.0", "openexr.patch"), "051940ec58fd5ae85b65c67b83fd46eda807c9039f0f5207769ac871350af830")
	add_patches("3.18.0", path.join(os.scriptdir(), "patches", "3.18.0", "pluginbmp.patch"), "2029f95478c8ce77f83671fe8e1889c11caa04eef2584abf0cd0a9f6a7047db0")

    add_configs("rgb", {description = "Use RGB instead of BGR.", default = false})

    if is_plat("macosx") then
        add_deps("libpng")
    end

    if on_check then
        on_check("windows|x86", function (package)
            import("core.tool.toolchain")

            local msvc = toolchain.load("msvc", {plat = package:plat(), arch = package:arch()})
            if msvc then
                local vs = msvc:config("vs")
                assert(vs and tonumber(vs) >= 2019, "package(field3d): current version need vs >= 2019")
            end
        end)
    end

    on_load("windows", function (package)
        if not package:config("shared") then
            package:add("defines", "FREEIMAGE_LIB")
        end
    end)

    on_install("windows|x64", "windows|x86", "macosx", "linux", function (package)
        local sources, includes
        local content = io.readfile("Makefile.srcs")
        sources = content:match("SRCS = (.-)\n"):split(" ")
        includes = content:match("INCLUDE = (.-)\n"):gsub("%-I", ""):split(" ")
        local rgb_type = package:config("rgb") and "FREEIMAGE_COLORORDER=1" or "FREEIMAGE_COLORORDER=0"
        io.writefile("xmake.lua", format([[
            add_rules("mode.debug", "mode.release")
            includes("check_cincludes.lua")
            if is_plat("macosx") then
                add_requires("libpng")
            end
            target("freeimage")
                set_kind("$(kind)")
                set_languages("c++11")
                if is_plat("macosx") then
                    add_packages("libpng")
                end
                add_files({"%s"})
                add_headerfiles("Source/FreeImage.h", "Source/FreeImageIO.h")
                set_symbols("hidden")
                add_includedirs({"%s"})
                check_cincludes("Z_HAVE_UNISTD_H", "unistd.h")
                add_defines("OPJ_STATIC", "NO_LCMS", "LIBRAW_NODLL", "DISABLE_PERF_MEASUREMENT", "]] .. rgb_type .. [[")
                if is_plat("windows") then
                    add_files("FreeImage.rc")
                    add_defines("WIN32", "_CRT_SECURE_NO_DEPRECATE")
                    add_defines(is_kind("static") and "FREEIMAGE_LIB" or "FREEIMAGE_EXPORTS")
                else
                    add_defines("__ANSI__")
                end
        ]], table.concat(sources, "\",\""), table.concat(includes, "\", \"")))
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("FreeImage_Initialise", {includes = "FreeImage.h"}))
    end)