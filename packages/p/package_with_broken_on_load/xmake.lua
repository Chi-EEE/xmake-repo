package("package_with_broken_on_load")
    add_configs("hide_existing_package_error", {default = is_plat("windows"), type = "boolean"})

    if on_check then
        on_check(function (package)
            if package:is_plat("linux") then
                raise("This package does not support Linux for ... reasons.")
            end
        end)
    end

    on_load(function (package)
        if package:config("hide_existing_package_error") then
            add_syslinks("advapi32")
            raise("This package is broken on purpose.")
        end
    end)

    on_install(function (package)
    end)

    on_test(function (package)
    end)
