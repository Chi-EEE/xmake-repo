package("libomp")

    set_homepage("https://openmp.llvm.org/")
    set_description("LLVM's OpenMP runtime library.")

    set_urls("https://github.com/llvm/llvm-project/releases/download/llvmorg-$(version)/openmp-$(version).src.tar.xz")
    add_versions("10.0.1", "d19f728c8e04fb1e94566c8d76aef50ec926cd2f95ef3bf1e0a5de4909b28b44")

    add_deps("cmake")

    add_links("omp")
    if is_plat("linux") then
        add_syslinks("pthread", "dl")
    end

    on_install("macosx", "linux", function (package)
        local configs = {"-DLIBOMP_INSTALL_ALIASES=OFF"}
        local shared = package:config("shared")
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (shared and "ON" or "OFF"))
        table.insert(configs, "-DLIBOMP_ENABLE_SHARED=" .. (shared and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("omp_get_thread_num", {includes = "omp.h"}))
    end)
