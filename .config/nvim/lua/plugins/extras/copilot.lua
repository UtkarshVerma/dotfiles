return {
  {
    "zbirenbaum/copilot.lua",
    main = "copilot",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = { auto_trigger = true },
      panel = { enabled = false },
    },
  },
}
