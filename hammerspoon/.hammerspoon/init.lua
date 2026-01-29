spaceName = hs.loadSpoon("SpaceName")
if spaceName then
    spaceName
        :start()
        :bindHotkeys({
            -- hotkey to show menu with all spaces
            show={{"ctrl"}, "m"}
        })
end
