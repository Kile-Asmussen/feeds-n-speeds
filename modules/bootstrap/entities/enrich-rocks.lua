--! data: make rock entities give more resources when mined
local fns = require 'fns'

local gadgets = fns.gadgets
local puts = gadgets.throughputs
local merge = fns.table.merge


merge(data.raw['simple-entity'], {
    __rec = true,
    ['huge-rock'] = {
        minable = {
            __merge = true,
            results = puts{
                ['stone']      = { 24, 50 },
                ['coal']       = { 24, 50 },
                ['iron-ore']   = { 11, 18 },
            },
        },
    },
    ['big-sand-rock'] = {
        minable = {
            __merge = true,
            results = puts{
                ['stone']      = { 19, 25 },
                ['copper-ore'] = { 0, 5 },
                ['sulfur'] = { 5, 14 },
            },
        },
    },
    ['big-rock'] = {
        minable = {
            __merge = true,
            results = puts{
                ['stone']      = { 18, 22 },
                ['iron-ore']   = { 0, 8 },
                ['copper-ore'] = { 0, 3 },
            },
            result = fns.utils.null,
            count = fns.utils.null,
        }
    }
})

local dead_tree_minable = 

merge(data.raw['tree'], {
    [{
        'dead-dry-hairy-tree',
        'dead-grey-trunk',
        'dead-tree-desert'
    }] = {
        __merge = true,
        minable = {
            __merge = true,
            results = puts{
                ['wood']   = 2,
                ['sulfur'] = { 1, 0.1 },
            },
            result = fns.utils.null,
            count  = fns.utils.null,
        }
    },
})