package("package_with_broken_on_load")
    add_configs("hide_existing_package_error", {default = is_plat("windows"), type = "boolean"})

    on_load("windows", function (package)
        if package:config("hide_existing_package_error") then
            add_syslinks("advapi32")
        end
    end)

    on_install(function (package)
    end)

    on_test(function (package)
    end)
