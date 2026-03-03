hs.allowAppleScript(true)
hs.autoLaunch(true)
hs.automaticallyCheckForUpdates(true)
hs.menuIcon(true)
hs.dockIcon(true)
hs.window.highlight.ui.overlay = false
hs.window.setShadows(false)

PaperWM = hs.loadSpoon("PaperWM")
spaceName = hs.loadSpoon("SpaceName")
mouseFollowsFocus = hs.loadSpoon("MouseFollowsFocus")
Swipe = hs.loadSpoon("Swipe")
log = hs.logger.new("dotfiles", "info")

spaceName:start()

PaperWM:bindHotkeys(
    {
        -- switch to a new focused window in tiled grid
        -- focus_left = {{"ctrl"}, "h"},
        -- focus_right = {{"ctrl"}, "l"},
        -- focus_up    = {{"ctrl"}, "k"},
        -- focus_down  = {{"ctrl"}, "j"},

        -- switch windows by cycling forward/backward
        -- (forward = down or right, backward = up or left)
        -- TODO make this wrap
        focus_prev = {{"ctrl"}, "h"},
        focus_next = {{"ctrl"}, "l"},
        -- move windows around in tiled grid
        swap_left = {{"alt"}, "h"},
        swap_right = {{"alt"}, "l"},
        swap_up = {{"alt"}, "k"},
        swap_down = {{"alt"}, "j"},
        -- position and resize focused window
        center_window = {{"ctrl", "shift"}, "return"},
        -- full_width = {{"ctrl"}, "return"},
        -- cycle_width = {{"ctrl"}, "return"},
        reverse_cycle_width = {{"ctrl"}, "return"},
        -- cycle_height = {{"ctrl", "shift"}, "n"},
        -- reverse_cycle_height = {{"ctrl"}, "n"},
        -- increase/decrease width
        -- increase_width = {{"ctrl", "shift"}, "m"},
        -- decrease_width = {{"ctrl"}, "m"},

        -- move focused window into / out of a column
        slurp_in = {{"ctrl", "shift"}, "i"},
        barf_out = {{"ctrl", "shift"}, "o"},
        -- move the focused window into / out of the tiling layer
        toggle_floating = {{"alt"}, "f"},
        -- raise all floating windows on top of tiled windows
        focus_floating = {{"alt", "cmd", "shift"}, "f"},
        -- focus the first / second / etc window in the current space
        focus_window_1 = {{"alt"}, "1"},
        focus_window_2 = {{"alt"}, "2"},
        focus_window_3 = {{"alt"}, "3"},
        focus_window_4 = {{"alt"}, "4"},
        focus_window_5 = {{"alt"}, "5"},
        focus_window_6 = {{"alt"}, "6"},
        focus_window_7 = {{"alt"}, "7"},
        focus_window_8 = {{"alt"}, "8"},
        focus_window_9 = {{"alt"}, "9"},
        -- switch to a new Mission Control space
        -- switch_space_l = {{"alt", "cmd"}, ","},
        -- switch_space_r = {{"alt", "cmd"}, "."},
        -- switch_space_1 = {{"alt", "cmd"}, "1"},
        -- switch_space_2 = {{"alt", "cmd"}, "2"},
        -- switch_space_3 = {{"alt", "cmd"}, "3"},
        -- switch_space_4 = {{"alt", "cmd"}, "4"},
        -- switch_space_5 = {{"alt", "cmd"}, "5"},
        -- switch_space_6 = {{"alt", "cmd"}, "6"},
        -- switch_space_7 = {{"alt", "cmd"}, "7"},
        -- switch_space_8 = {{"alt", "cmd"}, "8"},
        -- switch_space_9 = {{"alt", "cmd"}, "9"},

        -- move focused window to a new space and tile
        -- TODO
        move_window_1 = {{"alt", "shift"}, "1"},
        move_window_2 = {{"alt", "shift"}, "2"},
        move_window_3 = {{"alt", "shift"}, "3"},
        move_window_4 = {{"alt", "shift"}, "4"},
        move_window_5 = {{"alt", "shift"}, "5"},
        move_window_6 = {{"alt", "shift"}, "6"},
        move_window_7 = {{"alt", "shift"}, "7"},
        move_window_8 = {{"alt", "shift"}, "8"},
        move_window_9 = {{"alt", "shift"}, "9"}
    }
)
Actions = PaperWM.actions.actions()

PaperWM.window_filter:rejectApp("iStat Menus Status")
PaperWM.window_ratios = { 1/2, 2/3, 1 }
PaperWM.window_gap = { top = 4, left = 8, bottom = 4, right = 8 }
PaperWM:start()

DisableMMF = false
LastWindowFocused = nil
CheatTimeout = nil
-- must make this global or it GC's
CtrlTap = hs.eventtap.new(
    { hs.eventtap.event.types.flagsChanged, hs.eventtap.event.types.keyUp },
    function(event)
        local flags = event:getFlags()
        local keyCode = event:getKeyCode()
        DisableMMF = flags.ctrl and not (flags.cmd or flags.alt or flags.shift or flags.fn)
        -- h and l keys
        if keyCode == 4 or keyCode == 37 then
            if CheatTimeout then
                CheatTimeout:stop()
            end
            CheatTimeout = hs.timer.doAfter(0.15, function()
                if LastWindowFocused then
                    mouseFollowsFocus:updateMouse(LastWindowFocused)
                end
            end)
        end
        return false
    end
)
CtrlTap:start()

hs.window.filter.new({override={
    visible = true,
}}):setDefaultFilter({
    visible = true,
}):subscribe({
    hs.window.filter.windowFocused
}, function(window)
    LastWindowFocused = window
    if DisableMMF then
        return
    end
    mouseFollowsFocus:updateMouse(window)
end)

CurrentId = nil
LockedVert = nil
LastExecutionTime = 0
Swipe:start(
    4,
    function(direction, _, id)
        local now = hs.timer.secondsSinceEpoch()
        local vert = direction == "up" or direction == "down"

        if id ~= CurrentId then
            CurrentId = id
            LockedVert = vert
            LastExecutionTime = 0
        end

        if vert ~= LockedVert or now - LastExecutionTime < 0.25 then
            return
        end

        LastExecutionTime = now
        if direction == "left" then
            Actions.focus_right()
        elseif direction == "right" then
            Actions.focus_left()
        elseif direction == "up" then
            hs.execute("/Applications/ISSRight.app")
        elseif direction == "down" then
            hs.execute("/Applications/ISSLeft.app")
        end
    end
)

-- TODO keybind to split screen with ctrl+s
-- TODO SpoonInstall
