local dayAbr = {"Sun","Mon","Tue","Wed","Thu","Fri","Sat"}
local dayLookup = {Sun=1,Mon=2,Tue=3,Wed=4,Thu=5,Fri=6,Sat=7}
local monAbr = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}
local monLookup = {Jan=1,Feb=2,Mar=3,Apr=4,May=5,Jun=6,Jul=7,Aug=8,Sep=9,Oct=10,Nov=11,Dec=12}
--Tue, 15 Nov 1994 12:45:26 GMT
local time = {}

function time.new(tab)
    local t = tab or os.date("!*t")
    t.totalSeconds = os.time(tab)
    function t.httpTime()
        return string.format("%s, %d %s %d %02d:%02d:%02d GMT",dayAbr[t.wday],t.day,monAbr[t.month],t.year,t.hour,t.min,t.sec)
    end
    return t
end

function time.parseHttpTime(str)
    local wday, day, month, year, hour, min, sec  = str:match("(%a%a%a), (%d%d) (%a%a%a) (%d%d%d%d) (%d%d):(%d%d):(%d%d) GMT")
    local parsed = {
        sec = sec+0,
        min = min+0,
        day = day+0,
        wday = dayLookup[wday],
        month = monLookup[month],
        year = year+0
    }
    return time.new(parsed)
end

return time