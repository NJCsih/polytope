# My Nixos config, Uses snowfall-lib, which I'm only now really understanding.

The majority of my config, it's structure and many of the options, were based off:
> https://github.com/DarkKronicle/nazarick

They've since moved to a fully custom structure without snowfall, but I'd still reccomend checking out their config. They do a lot of really neat stuff.


THE GREETER WORKS WOO

Todo:
```neorg
- lix on stable branch for less recompiles

- Still need to do:
-- volume controll via keybinds
-- power menu
-- auto wifi connection on sway
-- xdg portal
-- Fix firefox for crucial websites and some canvas page issues
-- Update firefox lockdown settings for FF128
-- Firefox custom css
-- Firefox tridactyl
-- Firefox vencord

- (x) Switch to sway. Plasma has been completely servicable, like no complaints, but I want my i3 workflow back :p
-- Literally just like steal the xdg portal stuff Kronicle wrote, and that'll be like it for a full switch
-- Or at the very least murder kwallet
-- I guess volume? But I always use my dac anyway. Would be nice if the buttons worked though I guess

-- Mostly working, I'm there 98% of the time, just missing a few things from plama to make it feel fully featured
--- ( ) Volume controll -- Yes I can `nix shell nixpkgs#kmix` but that sucks
--- ( ) Big one: no login manager. I want to use a cool rewrite of ly called lemurs, I've been trying to get that setup, there's just some issues with the custom systemd service I need to finish
--- (x) Screenshot program. -- Sway's not as complete, especially as far as stuff like xdg options are concerned, so many things wont be able to see an open display.
--- (x) I'm back in my rofi config, how that currently works has the feel I want the whole system to eventually
- (-) hardware config -- apparnetly there's a repo for a bunch of different laptops I can steal from
-- Nearly done with hardware stuff, Nvidia drivers work on tetrahedron, havent bothered yet on hex. -- Need to get a better workflow setup with the nvidia-offload script and stuff, I want to just whitelist a few programs not have to specify at launch-time
-- Most of it's done as far as swap and stuff is concerned, really just the nvidia tweaks above, and 
-- oh and hex needs drivers too. Maybe I'll do that now

- ( ) nvim
-- I manually installed the lua TS parser? I want that to be done via nix? Or is that okay?
--- Same with java -- I think I may not nix my nvimrc? That may be sacrelig, but I need it to be able to drag and drop into a non-HM/Nixos system.
-- I need to port to nix, currently just threw my config into ~/.config/nvim
-- I'm thinking nixCats, I want to stick with lazy, but have nix handle the parsers. -- some cool effects from doing it that way

- (x) firefox
-- (x) add default bookmarks for things I'll want everywhere, my github, the davechild regex cheat sheet, etc
-- ( ) Setup custom css
-- ( ) Setup tridactly
-- ( ) vencord plugin
-- (x) jump cutter
-- (x) yt auto hd
- (x) gpu: drivers and config, maybe make a powersave profile
-- Still need to to powersave config, but drivers are doing good
- (x) git
-- (x) Finish setting all my custom options, leave extentions as the user's problem to avoid using NUR
--- How do I just completely disable the firefox password manager? That's about all that's left
-- (x) I set 'cycle tabs in recently used order' manually, I need to make that set via nix -- there's an option I have set now
-- (x) Still issues setting custom options. Sets user.js file correctly (simlinks in profile), but firefox doesnt load it?
--- Fixed, looks like articfox was disabled, but things are being set correctly
-- (x) Setup all my extentions -- I dont want to have to use nur just for this
--- Making progress, need to add either the NUR, or that one package. My structure is different enough finding good docs has been hard. -- I dont really want nur just for this?
```

Notes:
```neorg
- Make a java link within an intelij project:
-- @code bash
   nix-build '<nixpkgs>' -A jdk -o jdk
   @end

```
