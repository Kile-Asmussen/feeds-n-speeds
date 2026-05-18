
function table.overwrite(tbl1, tbl2)
    assert(type(tbl1) == "table", "argument #1 must be a table")
    assert(type(tbl2) == "table", "argument #2 must be a table")

    for k, v in pairs(tbl2) do
        tbl1[k] = v
    end

    return tbl1
end

function table.replace(tbl1, tbl2)
    assert(type(tbl1) == "table", "argument #1 must be a table")
    assert(type(tbl2) == "table", "argument #2 must be a table")

    for k, _ in pairs(tbl1) do
        if tbl2[k] ~= nil then
            tbl1[k] = tbl2[k]
        end
    end

    return tbl1
end

function table.include(tbl1, tbl2)
    assert(type(tbl1) == "table", "argument #1 must be a table")
    assert(type(tbl2) == "table", "argument #2 must be a table")

    for k, v in pairs(tbl2) do
        if tbl1[k] == nil then
            tbl1[k] = v
        end
    end

    return tbl1
end

