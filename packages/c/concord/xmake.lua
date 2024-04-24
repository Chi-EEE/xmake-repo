package("concord")
    set_homepage("https://cogmasters.github.io/concord/")
    set_description("A Discord API wrapper library made in C")
    set_license("MIT")

    add_urls("https://github.com/Cogmasters/concord/archive/refs/tags/$(version).tar.gz",
             "https://github.com/Cogmasters/concord.git")

    add_versions("v2.2.1", "3d3897c2e7ae6edfdeac4231ffc54edb7d97630cf714f260540465e9e5cee354")

    if is_plat("linux", "bsd") then
        add_syslinks("pthread")
    end

    add_deps("libcurl")

    on_install("!windows", function (package)
        for _, file in ipairs(os.files("gencodecs/**.PRE.h")) do
            io.replace(file, ".PRE", "", {plain = true})
            os.mv(file, file:gsub(".PRE", ""))
        end
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("libcurl")
            target("concord")
                set_kind("$(kind)")
                add_packages("libcurl")
                add_defines("GENCODECS_INIT","GENCODECS_JSON_ENCODER","GENCODECS_JSON_DECODER")
                add_files("src/*.c")
                add_headerfiles("core/(*.h)", {prefixdir = "concord"})
                add_headerfiles("include/(*.h)", {prefixdir = "concord"})
                add_headerfiles("gencodecs/(**.h)", {prefixdir = "concord"})
                add_includedirs("core", "include", "gencodecs")
        ]])
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
        #include <concord/discord.h>
        void test()
        {
            struct discord_ret_user ret = { 0 };
            struct discord_user bot;
            discord_user_init(&bot);
            ret.sync = &bot;
            discord_user_cleanup(&bot);
        }
        ]]}, {configs = {languages = "cxx11"}}))
    end)
