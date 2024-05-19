My Nixos config, I'm *very* new, and like my nvim, will probably keep it pretty simple to start with.

The majority of my config, it's structure and many of the options, are ~~stolen from~~ based off:
https://github.com/DarkKronicle/nazarick

Todo:
```neorg
- ( ) git oauth helper
- (-) firefox
-- ( ) I set 'cycle tabs in recently used order' manually, I need to make that set via nix
-- ( ) Setup all my extentions and custom css
--- Making progress, need to add either the NUR, or that one package. My structure is different enough finding good docs has been hard.
-- ( ) Setup tridactly
-- Still issues setting custom options. Sets user.js file correctly (simlinks in profile), but firefox doesnt load it?
- ( ) nvim
-- I manually installed the lua TS parser? I want that to be done via nix? Or is that okay?
-- I need to port to nix, currently just threw my config into ~/.config/nvim
-- I'm thinking nixCats, I want to stick with lazy, but have nix handle the parsers. -- some cool effects from doing it that way
- ( ) hardware config -- apparnetly there's a repo for a bunch of different laptops I can steal from
- ( ) gpu: drivers and config, maybe make a powersave profile
- ( ) Switch to sway. Plasma has been completely servicable, like no complaints, but I want my i3 workflow back :p
```
