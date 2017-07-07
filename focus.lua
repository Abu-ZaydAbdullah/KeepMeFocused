-- Place applications you want to block in this array in the format "app_name","other_app_name"...
blacklist_applications = {}
-- Place websites you want to block in this array in the format "domain_name","other_domain_name"...
blacklist_websites = {}

function applicationWatcher(appName, eventType, appObject)
    for _, c in pairs(blacklist_applications) do
        if (eventType == hs.application.watcher.launching or eventType == hs.application.watcher.activated or eventType == hs.application.watcher.launched) then
            if (appName == c) then
                app = hs.appfinder.appFromName(appName)
                app:kill()
                hs.notify.new({title="Hey Focus", informativeText="This application is a distraction!\n Distraction cannot be allowed."}):send()
            end
        end
    end
end

function tabWatcher(appName, eventType, appObject)
    if (appName == "Safari") then
        tabCount = [[
              tell application "Safari"
              --Variables
              set winlist to every window
              set totaltabcount to 0

                try
                set tabcount to number of tabs in front window
                set totaltabcount to totaltabcount + tabcount
                on error errmsg
                end try
                end repeat

                return totaltabcount as string
                end tell
                ]]

        script = [[
                tell application "Safari"
                set theURL to URL of front document
                return theURL as string
                end tell
                ]]

        getTime = [[
                set theResponse to display dialog "How long would you like to focus?" default answer ""
                return (text returned of theResponse) as number
                ]]



        ok,result = hs.applescript(script)
        ok,verifyTabNumber = hs.applescript(tabCount)
        parsedUrl = result:match('^%w+://([^/]+)')

        for _, v in pairs(blacklist_websites) do
            if (v == parsedUrl and verifyTabNumber ~= "0" and verifyTabNumber ~= "1") then
                hs.application.launchOrFocus("Safari")
                local safari = hs.appfinder.appFromName("Safari")
                local str_default = {"File", "Close Tab"}
                local default = safari:findMenuItem(str_default)
                safari:selectMenuItem(str_default)
                hs.notify.new({title="Hey Focus", informativeText="This website is a distraction!\n Distraction cannot be allowed."}):send()
            elseif (v == parsedUrl and verifyTabNumber == "1") then
                hs.application.launchOrFocus("Safari")
                local safari = hs.appfinder.appFromName("Safari")
                local str_default = {"File", "Close Window"}
                local default = safari:findMenuItem(str_default)
                safari:selectMenuItem(str_default)
            end
        end
    end
end

function focusTimer(x)
  hs.timer.doAfter(x * 60, function ()
appWatcher:stop()
webWatcher:stop()
hs.notify.new({title="Hey Focus", informativeText="Done focusing."}):send()
  end)
 appWatcher:start()
 webWatcher:start()
hs.notify.new({title="Hey Focus", informativeText="Focusing for " .. x .. " minutes."}):send()
end


appWatcher = hs.application.watcher.new(applicationWatcher)
webWatcher = hs.application.watcher.new(tabWatcher)



local iconPath = '~/.hammerspoon/icon.png'
local menu = hs.menubar.new()

menu:setIcon(iconPath)

menuTable =    {
    { title = "Focus", fn = function() appWatcher:start() webWatcher:start() hs.notify.new({title="Hey Focus", informativeText="Started focusing."}):send() end},
    { title = "Unfocus", fn = function() appWatcher:stop() webWatcher:stop() hs.notify.new({title="Hey Focus", informativeText="Done focusing."}):send() end},
    { title = "15 minutes", fn = function() focusTimer(15) end},
    { title = "30 minutes", fn = function() focusTimer(30) end},
    { title = "1 hour", fn = function() focusTimer(60) end},
    -- Work in progress
    -- { title = "Custom", fn = function() time = hs.applescript(getTime) focusTimer(time) end},
}
menu:setMenu(menuTable)
