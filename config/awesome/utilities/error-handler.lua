-- 🔧 TODO: add _naughty_ notification here
local error_handler = function(err)
  if err ~= "" then
    -- here the level is 4 cause the first is the error
    -- the second the callback the third the pcall and
    -- the fourth the function that called error_handler
    local _, error = pcall(function() error(err, 4) end)
    print(error)
  end
end
return error_handler
