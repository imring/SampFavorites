package = "samp-favorites"
version = "1.0"
source = {
   url = "git+https://github.com/imring/SampFavorites.git",
   tag = "1.0"
}
description = {
   homepage = "https://github.com/imring/SampFavorites",
   license = "MIT"
}
dependencies = {
   "lua >= 5.1, < 5.4"
}
build = {
   type = "builtin",
   modules = {
      ["SampFavorites"] = "SampFavorites.lua"
   }
}