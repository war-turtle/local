-- Old app switching config
local favoriteApps = {
  { name = "Intellij", bundleID = "com.jetbrains.intellij" },
  { name = "Vivaldi", bundleID = "com.vivaldi.Vivaldi" },
  { name = "Terminal", bundleID = "org.alacritty" },
  { name = "Emacs", bundleID = "org.gnu.Emacs" }
}

-- Function to cycle between open Windows of the application
function cycleWindows(appBundleID)
  local app = hs.application.get(appBundleID)
  print(app:name())
  if app then
    local windows = hs.window.filter.new{app:name()}:getWindows()
    windows[#windows]:focus()
  end
end

-- Function to launch or focus an app
function launchOrFocusApp(appBundleID)
  cycleWindows(appBundleID)
end

-- Bind hotkeys for favorite apps
for i, app in ipairs(favoriteApps) do
  hs.hotkey.bind({"alt"}, tostring(i), function() launchOrFocusApp(app.bundleID) end)
end

-- New app switching config from 
local hotswitchHs = require("hotswitch-hs/hotswitch-hs")
hotswitchHs.enableAutoUpdate() -- If you don't want to update automatically, remove this line.
hotswitchHs.enableAllSpaceWindows()
hs.hotkey.bind({"command"}, ".", hotswitchHs.openOrClose) -- Set a keybind you like to open HotSwitch-HS panel.
