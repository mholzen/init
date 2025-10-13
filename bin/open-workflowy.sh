#!/bin/bash

# Default Workflowy URL (change this to your preferred deep URL)
DEFAULT_URL="https://workflowy.com/"

# Use provided URL or default
URL="${1:-$DEFAULT_URL}"

# AppleScript to open Workflowy, position window, and hide other apps
osascript <<EOF
-- Open URL in WorkFlowy
tell application "WorkFlowy"
    activate
    open location "$URL"
end tell

-- Wait until WorkFlowy is actually frontmost
repeat 20 times
    if application "WorkFlowy" is frontmost then
        exit repeat
    end if
    delay 0.1
end repeat

-- Position window in center of screen
tell application "System Events"
    tell process "WorkFlowy"

        -- Get screen size
        tell application "Finder"
            set screenBounds to bounds of window of desktop
            set screenWidth to item 3 of screenBounds
            set screenHeight to item 4 of screenBounds
        end tell

        -- Set window size and position (adjust these values as needed)
        set windowWidth to 1400
        set windowHeight to 1000

        -- Calculate center position
        set xPos to (screenWidth - windowWidth) / 2
        set yPos to (screenHeight - windowHeight) / 2

        -- Position the window
        tell window 1
            set position to {xPos, yPos}
            set size to {windowWidth, windowHeight}
        end tell
    end tell
end tell

-- Ensure WorkFlowy is still frontmost before hiding others
delay 0.5

-- Hide all other applications using Command-Option-H
tell application "System Events"
    if application "WorkFlowy" is frontmost then
        tell process "WorkFlowy"
            keystroke "h" using {command down, option down}
        end tell
    end if
end tell
EOF
