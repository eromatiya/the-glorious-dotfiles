local awful = require("awful")
local secrets = require('configuration.secrets')
local naughty = require('naughty')
local json = require('library.json')


-- settings for ip checking
local ip_check_url = 'httpbin.org/ip'
local ip_check_cmd = 'curl' .. ' ' .. ip_check_url

if secrets.geoinfo.proxy_for_check_ip then
    ip_check_cmd = ip_check_cmd .. ' ' .. '-x' .. ' ' .. '"' .. secrets.geoinfo.proxy_host .. ':' .. secrets.geoinfo.proxy_port .. '"'
else
    ip_check_cmd = ip_check_cmd .. ' ' .. '--noproxy' .. ' ' .. '"*"'
end

-- settings for ipstack
local ipstack_url = "api.ipstack.com/"


local function is_leap_year(year)
    return (year % 4 == 0 and year % 100 ~= 0) or
           (year % 400 == 0) or
           (year % 3200 == 0 and year % 172800)
end


-- calculate sunrise and sunset
-- from https://www.esrl.noaa.gov/gmd/grad/solcalc/solareqns.PDF
local function calculate_sunrise_and_sunset(lat,long)
    local days = 365
    local year = os.date('%Y')
    if is_leap_year(year) then
        days = 366
    end

    lat = math.rad(lat)

    local day_of_year = os.date('%j')
    local hour = os.date('%H')
    local gamma = (2 * math.pi / days) * (day_of_year - 1 + (hour - 12) / 24)
    local decl = 0.006918 - 0.399912 * math.cos(gamma) + 0.070257 * math.sin(gamma) - 0.006758 * math.cos(2 * gamma) + 
    0.000907 * math.sin(2 * gamma) - 0.002697 * math.cos(3 * gamma) + 0.00148 * math.sin(3 * gamma)
    local etime = 229.18 * (0.000075 + 0.001868 * math.cos(gamma) - 0.032077 * math.sin(gamma) - 0.014615 * math.cos(2 * gamma) - 0.040849 * math.sin(2 * gamma))
    local ha = math.acos(math.cos(math.rad(90.833)) / (math.cos(lat) * math.cos(decl)) - math.tan(lat) * math.tan(decl) )

    local sunrise = 720 - 4 * (long + math.deg(ha)) - etime
    local sunset = 720 - 4 * (long - math.deg(ha)) - etime
    local snoon = 720 - 4 * long - etime

    secrets.geoinfo.sunrise = sunrise
    secrets.geoinfo.sunset = sunset
    secrets.geoinfo.snoon = snoon

    awesome.emit_signal('module::geoinfo_updated')
    
    -- TODO: modify dynamic wallpaper module
end

local function config_ipstack(ip)
    local ipstack_cmd = 'curl' .. ' ' .. '"' .. ipstack_url .. ip .. '?' .. 'access_key=' .. secrets.geoinfo.ipstack_key .. '"'

    if secrets.geoinfo.proxy_for_ipstack then
        ipstack_cmd = ipstack_cmd .. ' ' .. '-x' .. ' ' .. '"' .. secrets.geoinfo.proxy_host .. ':' .. secrets.geoinfo.proxy_port .. '"'
    else
        ipstack_cmd = ipstack_cmd .. ' ' .. '--noproxy' .. ' ' .. '"*"'
    end

    awful.spawn.easy_async_with_shell(ipstack_cmd,function(stdout, stderr, exitreason, exitcode)
        local res = json.parse(stdout)
        local latitude = res.latitude
        local longitude = res.longitude
        
        secrets.geoinfo.latitude = latitude
        secrets.geoinfo.longitude = longitude
        
        calculate_sunrise_and_sunset(latitude,longitude)
    end)
end

awesome.connect_signal(
    'system::network_connected',
    function()
        awful.spawn.easy_async_with_shell(ip_check_cmd,
        function (stdout, stderr, exitreason, exitcode)
            local res = json.parse(stdout)
            local ip = res.origin

            config_ipstack(ip)
        end)

    end
)

awesome.connect_signal(
    'module::update_geoinfo',
    function()
        awful.spawn.easy_async_with_shell(ip_check_cmd,
        function (stdout, stderr, exitreason, exitcode)
            local res = json.parse(stdout)
            local ip = res.origin

            config_ipstack(ip)
        end)

    end
)