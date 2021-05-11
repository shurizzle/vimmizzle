require 'strings-case'

def disable(what)
  iwhat = Strings::Case.sentencecase(what).downcase
  [
    "nnoremap <#{what}> :echo \"No #{iwhat} for you!\"<CR>",
    "vnoremap <#{what}> :<C-u>echo \"No #{iwhat} for you!\"<CR>",
    "inoremap <#{what}> <C-o>echo \"No #{iwhat} for you!\"<CR>",
  ]
end

puts %w|Left Right Up Down PageUp PageDown End Home|.flat_map(&self.method(:disable)).join("\n")
