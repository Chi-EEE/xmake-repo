package("package_with_dep_error")
    add_configs("hide_existing_package_error_1", {default = false, type = "boolean"})

    on_load(function (package)
        if package:config("hide_existing_package_error_1") then -- CI does not check this
            add_syslinks("advapi32") -- incorrect method
            raise("This package is broken on purpose.") -- raise inside of on_load
        end
    end)

    on_install(function (package)
    end)

    on_test(function (package)
    end)