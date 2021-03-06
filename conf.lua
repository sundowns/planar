function love.conf(t)
  local game_title = "Planar - LoveJam 2020"

  t.window.title = game_title
  t.window.minwidth = 720 -- 1280 for 16:9
  t.window.minheight = 720
  t.console = false
  t.window.fullscreen = false
  t.window.msaa = 8
  t.window.vsync = 1

  t.releases = {
    title = game_title, -- The project title (string)
    package = nil, -- The project command and package name (string)
    loveVersion = 11.3, -- The project LÖVE version
    version = "0.1", -- The project version
    author = "Tom Smallridge", -- Your name (string)
    email = "tom@smallridge.com.au", -- Your email (string)
    description = "Planar LoveJam 2020", -- The project description (string)
    homepage = "https://example.com", -- The project homepage (string)
    identifier = "planar.grim.gamers", -- The project Uniform Type Identifier (string)
    excludeFileList = {
      ".git",
      "tests",
      ".luacheckrc",
      "README.md",
      ".vscode",
      ".circleci",
      ".gitignore",
      "tmp",
      "*.tmx"
    },
    releaseDirectory = "dist" -- Where to store the project releases (string)
  }
end
