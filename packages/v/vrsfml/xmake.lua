package("vrsfml")
    set_homepage("https://github.com/vittorioromeo/VRSFML")
    set_description("VRSFML: Vittorio Romeo's SFML fork")

    add_urls("https://github.com/vittorioromeo/vrsfml.git")
    add_versions("2024.08.19", "400b17a309c72e182f7d583d95f3b0d926e2ff8e")

    add_patches("2024.08.19", path.join(os.scriptdir(), "patches", "2024.08.19", "fix.patch"), "6524daaa11ec4637d79267b415d930a392042af78830c50ae692ffc188df9ddf")

    add_deps("cpptrace", "doctest", "freetype", "glad", "imgui", "libdwarf", "libflac", "libogg", "libvorbis", "miniaudio", "minimp3", "stb", "zlib",  "zstd")

    on_install(function (package)
        for _, headerfile in ipairs(table.join(os.files("src/**.cpp"), os.files("src/**.hpp"))) do
            io.replace(headerfile, "glad/gl.h", "glad/glad.h", {plain = true})
        end
    
        os.cp(path.join(package:scriptdir(), "port", "xmake.lua"), "xmake.lua")
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("foo", {includes = "foo.h", cxflags = "/permissive-"}))
    end)
