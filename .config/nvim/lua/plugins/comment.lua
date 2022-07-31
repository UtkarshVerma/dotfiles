local status_ok, comment = pcall(require, "Comment")
if not status_ok then
    return
end

comment.setup({
    -- LHS of operator-pending mapping in NORMAL + VISUAL mode
    opleader = {
        line = "gc",
        block = "gb"
    }
})
