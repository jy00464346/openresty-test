local x = tonumber(arg[1])
print(string.sub(require("jit.vmdef").bcnames, x*6+1, x*6+6))
