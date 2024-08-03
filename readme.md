# My Nixos config, Uses snowfall-lib, which I'm only now really understanding.

The majority of my config, it's structure and many of the options, were based off:
> https://github.com/DarkKronicle/nazarick

They've since moved to a fully custom structure without snowfall, but I'd still reccomend checking out their config. They do a lot of really neat stuff.

Fix the sway config, have it with some home manager stuff, then load the file as extraconfig. Dont need to send -c to ~/.conf then


Todo:
```neorg

- fix sway rofi bindings
- lix on stable branch for less recompiles
- xdg portal
- fix firefox for canvas
- get nvim fully working
- Install ram
- install quartus, see Kronicle's Notes
- auto wifi connection
- firefox custom css, vencord, tridactyl
- install mutt
- Volume keybinds
- Kronicle's DNS
- consider a bar like Kronicle, idk, literally I just need battery and time

- ( ) nvim
-- I manually installed the lua TS parser? I want that to be done via nix? Or is that okay?
--- Same with java -- I think I may not nix my nvimrc? That may be sacrelig, but I need it to be able to drag and drop into a non-HM/Nixos system.
-- I need to port to nix, currently just threw my config into ~/.config/nvim
-- I'm thinking nixCats, I want to stick with lazy, but have nix handle the parsers. -- some cool effects from doing it that way
```

Notes:
```neorg
- Make a java link within an intelij project:
-- @code bash
   nix-build '<nixpkgs>' -A jdk -o jdk
   @end

```
