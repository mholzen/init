-- Open WorkFlowy at a specific URL, center window, hide others
function openWorkFlowy(url)
  url = url or "workflowy://workflowy.com/#/f03667f91df9"

  -- Launch WorkFlowy and open URL
  local app = hs.application.open("WorkFlowy")

  -- Open the URL
  hs.urlevent.openURL(url)

  -- Wait for app to be frontmost
  hs.timer.waitUntil(
    function() return app:isFrontmost() end,
    function()
      -- Get main screen dimensions
      local screen = hs.screen.mainScreen()
      local screenFrame = screen:frame()

      -- Set desired window size
      local windowWidth = 1400
      local windowHeight = 1000

      -- Calculate center position
      local newFrame = {
        x = (screenFrame.w - windowWidth) / 2,
        y = (screenFrame.h - windowHeight) / 2,
        w = windowWidth,
        h = windowHeight
      }

      -- Position the window
      local win = app:mainWindow()
      if win then
        win:setFrame(newFrame)
      end

      -- Hide all other applications
      local allApps = hs.application.runningApplications()
      for _, otherApp in ipairs(allApps) do
        if otherApp:bundleID() ~= app:bundleID() and otherApp:bundleID() ~= "com.apple.finder" then
          otherApp:hide()
        end
      end
    end,
    0.1  -- check interval
  )
end

-- Bind to Cmd+Option+W
hs.hotkey.bind({"cmd"}, "F1", function()
  openWorkFlowy()
end)
