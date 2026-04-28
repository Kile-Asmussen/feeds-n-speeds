script.on_init(function()
    helpers.write_file("defines.json", helpers.table_to_json(defines))
    game.exit()
end)
