require("twilight").setup({
    expand = {
        "function",
        "method",
        "method_definition",
        "function_definition",
        "function_item"
    },
    context = 10
})
