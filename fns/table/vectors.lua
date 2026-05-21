local table = _ENV.table

function table.vecsum(tbl1, tbl2, res)
    assert(type(tbl1) == 'table' and type(tbl2) == 'table', "arguments #1 and #2 must be tables")
    assert(#tbl1 == #tbl2, "arguments #1 and #2 must tables of the same length")
    res = res or tbl1
    assert(type(res) == 'table', "optional argument #3 must be a table")
    for i = 1,#tbl1 do
        res[i] = tbl1[i] + tbl2[i]
    end
    return res
end

function table.vecmul(tbl, k, res)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    assert(type(k) == 'number', "argument #2 must be a number")
    res = res and {} or tbl
    assert(type(res) == 'table', "optional argument #3 must be a table")
    for i = 1,#tbl do
        res[i] = tbl[i] * k
    end
    return res
end

function table.sum(tbl, res)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    res = res or 0
    assert(type(res) == 'number', "optional argument #2 must be a number")

    for _, n in ipairs(tbl) do
        assert(type(n) == 'number', "argument #1 must only contain numbers")
        res = res + n
    end

    return res
end

function table.max(tbl)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    local max = tbl[1]
    for _, n in ipairs(tbl) do
        max = math.max(max, n)
    end
    return max
end