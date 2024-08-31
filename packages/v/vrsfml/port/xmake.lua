add_rules("mode.release", "mode.debug")

add_requires("cpptrace", "doctest", "freetype", "glad", "imgui", "libdwarf", "libflac", "libogg", "libvorbis", "miniaudio", "minimp3", "stb", "zlib",  "zstd")

target("vrsfml")
    set_kind("$(kind)")
    set_languages("c++20")
    if is_kind("static") then
        add_defines("SFML_STATIC")
    end

    add_cxxflags("cl::/permissive-") -- standards conformance mode
    add_cxxflags("cl::/w14242") -- 'identifier': conversion from 'type1' to 'type1', possible loss of data
    add_cxxflags("cl::/w14254") -- 'operator': conversion from 'type1:field_bits' to 'type2:field_bits', possible loss of data
    add_cxxflags("cl::/w14263") -- 'function': member function does not override any base class virtual member function
    add_cxxflags("cl::/w14265") -- 'classname': class has virtual functions, but destructor is not virtual instances of this class may not be destructed correctly
    add_cxxflags("cl::/w14287") -- 'operator': unsigned/negative constant mismatch
    add_cxxflags("cl::/we4289") -- nonstandard extension used: 'variable': loop control variable declared in the for-loop is used outside the for-loop scope
    add_cxxflags("cl::/w14296") -- 'operator': expression is always 'boolean_value'
    add_cxxflags("cl::/w14311") -- 'variable': pointer truncation from 'type1' to 'type2'
    add_cxxflags("cl::/w14545") -- expression before comma evaluates to a function which is missing an argument list
    add_cxxflags("cl::/w14546") -- function call before comma missing argument list
    add_cxxflags("cl::/w14547") -- 'operator': operator before comma has no effect; expected operator with side-effect
    add_cxxflags("cl::/w14549") -- 'operator': operator before comma has no effect; did you intend 'operator'?
    add_cxxflags("cl::/w14555") -- expression has no effect; expected expression with side- effect
    add_cxxflags("cl::/w14619") -- pragma warning: there is no warning number 'number'
    add_cxxflags("cl::/w14640") -- Enable warning on thread un-safe static member initialization
    add_cxxflags("cl::/w14826") -- Conversion from 'type1' to 'type_2' is sign-extended. This may cause unexpected runtime behavior.
    add_cxxflags("cl::/w14905") -- wide string literal cast to 'LPSTR'
    add_cxxflags("cl::/w14906") -- string literal cast to 'LPWSTR'
    add_cxxflags("cl::/w14928") -- illegal copy-initialization; more than one user-defined conversion has been implicitly applied

    add_cxxflags("cl::/wd4068") -- disable warnings about unknown pragmas (e.g. #pragma GCC)
    add_cxxflags("cl::/wd4505") -- disable warnings about unused functions that might be platform-specific
    add_cxxflags("cl::/wd4800") -- disable warnings regarding implicit conversions to bool
            
    add_packages("cpptrace", "doctest", "freetype", "glad", "imgui", "libdwarf", "libflac", "libogg", "libvorbis", "miniaudio", "minimp3", "stb", "zlib",  "zstd")

    on_config(function (target)
        if target:has_tool("gcc", "gxx") then
            target:add("defines", "__GNUC__")
        elseif target:has_tool("cc", "cxx", "clang", "clangxx") then
            target:add("defines", "__clang__")
        end
    end)
    
    add_defines("SFML_ENABLE_STACK_TRACES", "SFML_ENABLE_LIFETIME_TRACKING")
    add_defines("SFML_BUILD_WINDOW", "SFML_BUILD_GRAPHICS", "SFML_BUILD_IMGUI", "SFML_BUILD_AUDIO", "SFML_BUILD_NETWORK")
    add_defines("SFML_OPENGL_ES", "GL_GLEXT_PROTOTYPES")

    add_headerfiles("include/(**.hpp)", "src/(**.hpp)", "include/(**.inl)")

    add_includedirs("include", "src")

    add_headerfiles("src/(SFML/Audio/**.hpp)")
    add_files("src/SFML/Audio/**.cpp")

    add_headerfiles("src/(SFML/Base/**.hpp)")
    add_files("src/SFML/Base/**.cpp")

    add_headerfiles("src/(SFML/Graphics/**.hpp)")
    add_files("src/SFML/Graphics/**.cpp")

    add_headerfiles("src/(SFML/ImGui/**.hpp)")
    add_files("src/SFML/ImGui/**.cpp")

    add_headerfiles("src/(SFML/Network/*.hpp)")
    add_files("src/SFML/Network/*.cpp")

    add_headerfiles("src/(SFML/System/*.hpp)")
    add_files("src/SFML/System/*.cpp")

    add_headerfiles("src/(SFML/Window/*.hpp)")
    add_files("src/SFML/Window/*.cpp")

    add_defines("_LIBCPP_REMOVE_TRANSITIVE_INCLUDES")
    if is_plat("windows", "mingw") then
        if is_kind("shared") then
            add_rules("utils.symbols.export_all", {export_classes = true})
        end
        add_defines("_WIN32")
        add_defines("_CRT_SECURE_NO_WARNINGS")
        
        add_headerfiles("src/SFML/Network/Win32/**.hpp")
        add_files("src/SFML/Network/Win32/**.cpp")
        
        add_headerfiles("src/SFML/System/Win32/**.hpp")
        add_files("src/SFML/System/Win32/**.cpp")

        add_headerfiles("src/SFML/Window/Win32/**.hpp")
        add_files("src/SFML/Window/Win32/**.cpp")
    else
        add_headerfiles("src/SFML/Network/Unix/**.hpp")
        add_files("src/SFML/Network/Unix/**.cpp")
        
        add_headerfiles("src/SFML/System/Unix/**.hpp")
        add_files("src/SFML/System/Unix/**.cpp")

        add_defines("__unix__")
        if is_plat("android") then
            add_defines("__ANDROID__")
        
            add_headerfiles("src/SFML/System/Android/**.hpp")
            add_files("src/SFML/System/Android/**.cpp")

            add_headerfiles("src/SFML/Window/Android/**.hpp")
            add_files("src/SFML/Window/Android/**.cpp")
        end

        if is_plat("linux") then
            add_defines("__linux__")
            add_files("src/SFML/Window/Unix/**.cpp")
            add_files("src/SFML/Window/Unix/**.cpp")
        end

        if is_plat("bsd") then
            add_defines("__FreeBSD__")
            add_headerfiles("src/SFML/Window/Unix/**.hpp")
            add_headerfiles("src/SFML/Window/FreeBSD/**.hpp")
            add_files("src/SFML/Window/Unix/**.cpp")
            add_files("src/SFML/Window/FreeBSD/**.cpp")
        end

        if is_plat("wasm") then
            add_defines("__EMSCRIPTEN__")
            add_headerfiles("src/SFML/Window/Emscripten/**.hpp")
            add_files("src/SFML/Window/Emscripten/**.cpp")
        end

        if is_plat("iphone") then
            add_defines("__APPLE__")
            add_defines("__MACH__")
            add_defines("TARGET_OS_IPHONE")
            add_headerfiles("src/SFML/Window/iOS/**.hpp")
            add_files("src/SFML/Window/iOS/**.cpp")
        end

        if is_plat("macosx") then
            add_defines("__APPLE__")
            add_defines("__MACH__")
            add_defines("TARGET_OS_MAC")
            add_headerfiles("src/SFML/Window/macOS/**.hpp")
            add_files("src/SFML/Window/macOS/**.cpp", "src/SFML/Window/macOS/**.mm")
        end
    end

    add_rules("utils.install.pkgconfig_importfiles")
    add_rules("utils.install.cmake_importfiles")