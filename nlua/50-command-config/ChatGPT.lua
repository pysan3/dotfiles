local function setup_chatgpt()
  require("chatgpt").setup({
  })
end

if string.len(vim.env.OPENAI_API_KEY or "") < 1 then
  vim.notify(string.format("$OPENAI_API_KEY not set: %s", vim.env.OPENAI_API_KEY or "nil"), vim.log.levels["ERROR"])
  vim.ui.input({ prompt = "OPENAI_API_KEY = " }, function(input)
    if input ~= nil then
      vim.loop.os_setenv("OPENAI_API_KEY", input)
      setup_chatgpt()
    end
  end)
else
  setup_chatgpt()
end
