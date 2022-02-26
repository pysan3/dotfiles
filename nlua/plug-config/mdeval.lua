require("mdeval").setup({
  require_confirmation = true,
  eval_options = {
    cpp = {
      command = { "clang++", "-std=c++20", "-O0" },
      default_header = [[
      #include <iostream>
      #include <vector>
      using namespace std;
      ]],
    },
  },
})

-- command! MdEval -- evaluates current code block
