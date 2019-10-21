local fun = require('fun')

local utils = require('luatest.utils')

return function(lu)
    local TextOutput = lu.LuaUnit.outputType

    utils.patch(TextOutput, 'end_suite', function(super) return function(self)
        super(self)
        local list = fun.chain(self.result.failedTests, self.result.errorTests):
            map(function(x) return x.testName end):
            totable()
        if #list > 0 then
            table.sort(list)
            if self.verbosity > lu.VERBOSITY_DEFAULT then
                print("\n=========================================================")
            else
                print()
            end
            print(TextOutput.BOLD_CODE .. 'Failed tests:\n' .. TextOutput.ERROR_COLOR_CODE)
            for _, x in pairs(list) do
                print(x)
            end
            io.stdout:write(TextOutput.RESET_TERM)
        end
    end end)
end
