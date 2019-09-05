local t = require('luatest')
local g = t.group('luaunit')

g.test_assert_tnt_specific = function()
    t.assert(true)
    t.assert({})
    t.assert_error(function() t.assert(box.NULL) end)
    t.assert_not(box.NULL)
    t.assert_error(function() t.assert_not(true) end)
    t.assert_error(function() t.assert_not({}) end)
end

g.test_fail_if_tnt_specific = function()
    t.fail_if(box.NULL, 'unexpected')
    t.assert_error(function() t.fail_if(true, 'expected') end)
    t.assert_error(function() t.fail_if({}, 'expected') end)
end

local function assert_any_error(fn, ...)
    local ok, err = pcall(fn, ...)
    t.assert(ok, 'Got error: ' .. tostring(err))
end

g.test_skip_if_tnt_specific = function()
    assert_any_error(t.skip_if, box.NULL, 'unexpected')
    t.assert_error_msg_contains(t.SKIP_PREFIX, function() t.skip_if(true, 'expected') end)
    t.assert_error_msg_contains(t.SKIP_PREFIX, function() t.skip_if({}, 'expected') end)
end

g.test_success_if_tnt_specific = function()
    assert_any_error(t.success_if, box.NULL)
    t.assert_error_msg_contains(t.SUCCESS_PREFIX, function() t.success_if(true) end)
    t.assert_error_msg_contains(t.SUCCESS_PREFIX, function() t.success_if({}) end)
end

g.test_assert_aliases = function ()
    t.assert_is(t.assert, t.assert_eval_to_true)
    t.assert_is(t.assert_not, t.assert_eval_to_false)
end

g.test_assert_covers = function()
    local subject = t.assert_covers
    subject({a = 1, b = 2, c = 3}, {})
    subject({a = 1, b = 2, c = 3}, {a = 1})
    subject({a = 1, b = 2, c = 3}, {a = 1, c = 3})
    subject({a = 1, b = 2, c = 3}, {a = 1, b = 2, c = 3})

    t.assert_error(subject, {a = 1, b = 2, c = 3}, {a = 2})
    t.assert_error(subject, {a = 1, b = 2, c = 3}, {a = 1, b = 1})
    t.assert_error(subject, {a = 1, b = 2, c = 3}, {a = 1, b = 2, c = 3, d = 4})
    t.assert_error(subject, {a = 1, b = 2, c = 3}, {d = 1})
end

g.test_assert_not_covers = function()
    local subject = t.assert_not_covers
    subject({a = 1, b = 2, c = 3}, {a = 2})
    subject({a = 1, b = 2, c = 3}, {a = 1, b = 1})
    subject({a = 1, b = 2, c = 3}, {a = 1, b = 2, c = 3, d = 4})
    subject({a = 1, b = 2, c = 3}, {d = 1})

    t.assert_error(subject, {a = 1, b = 2, c = 3}, {})
    t.assert_error(subject, {a = 1, b = 2, c = 3}, {a = 1})
    t.assert_error(subject, {a = 1, b = 2, c = 3}, {a = 1, c = 3})
    t.assert_error(subject, {a = 1, b = 2, c = 3}, {a = 1, b = 2, c = 3})
end