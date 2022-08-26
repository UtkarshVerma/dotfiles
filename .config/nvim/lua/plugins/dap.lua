local status_ok, dap = pcall(require, "dap")
if not status_ok then
    return
end

dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = "OpenDebugAD7"
}
