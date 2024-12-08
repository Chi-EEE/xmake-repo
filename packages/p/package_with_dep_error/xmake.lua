package("package_with_dep_error")
    add_deps("package_config_error", {configs = {hide_existing_package_error_1 = is_plat("windows")}})

    on_load(function (package)
    end)

    on_install(function (package)
    end)

    on_test(function (package)
    end)
