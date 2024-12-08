package("package_with_broken_on_load")
    add_configs("hide_existing_package_error_1", {default = is_plat("windows"), type = "boolean"})
    add_configs("hide_existing_package_error_2", {default = is_plat("macosx"), type = "boolean"})

    if on_check then
        on_check(function (package)
            if package:is_plat("linux") then
                raise("This package does not support Linux for ... reasons.")
            end
        end)
    end

    on_load(function (package)
        if package:config("hide_existing_package_error_1") then -- CI does not check this
            add_syslinks("advapi32") -- incorrect method
        end
        if package:config("hide_existing_package_error_2") then -- CI does not check this
            raise("This package is broken on purpose.") -- raise inside of on_load
        end
    end)

    on_install(function (package)
    end)

    on_test(function (package)
    end)
