My Nixos config, I'm *very* new, and like my nvim, will probably keep it pretty simple to start with.

The majority of my config, it's structure and many of the options, are ~~stolen from~~ based off:
https://github.com/DarkKronicle/nazarick

Why do I order my todo list by priority if I just reorder it whenever I want to do something else

Todo:
```neorg
- ( ) Switch to sway. Plasma has been completely servicable, like no complaints, but I want my i3 workflow back :p
- ( ) git oauth helper
- ( ) nvim
-- I manually installed the lua TS parser? I want that to be done via nix? Or is that okay?
--- Same with java
-- I need to port to nix, currently just threw my config into ~/.config/nvim
-- I'm thinking nixCats, I want to stick with lazy, but have nix handle the parsers. -- some cool effects from doing it that way
- ( ) hardware config -- apparnetly there's a repo for a bunch of different laptops I can steal from
- ( ) gpu: drivers and config, maybe make a powersave profile
- (x) firefox
-- ( ) Setup custom css
-- ( ) Setup tridactly
-- add vencord plugin
-- (x) Finish setting all my custom options, leave extentions as the user's problem to avoid using NUR
--- How do I just completely disable the firefox password manager? That's about all that's left
-- (x) I set 'cycle tabs in recently used order' manually, I need to make that set via nix -- there's an option I have set now
-- (x) Still issues setting custom options. Sets user.js file correctly (simlinks in profile), but firefox doesnt load it?
--- Fixed, looks like articfox was disabled, but things are being set correctly
-- (x) Setup all my extentions -- I dont want to have to use nur just for this
--- Making progress, need to add either the NUR, or that one package. My structure is different enough finding good docs has been hard. -- I dont really want nur just for this?
```
