# My Nixos config -- Getting by

I'm not good at this, I don't claim to be. It's been a fun summer project though, and I think I'll stick with it.

I don't spend that much time on this? It could be nicer. If you want something better, look at [DarkKronicle's config](https://github.com/DarkKronicle/nazarick), they've done so much to help me while I learn nix. There's no chance I would have done any of this without them.


Todo:
```neorg
* 'Full Competence' from my device
- ( ) Install/configure zelij
- ( ) Use zoxide?
- ( ) Actually use atuin
- ( ) Make taskwarrior configured via hm/nix, I just ran `task config dateformat Y_M_D-H_N` but it would be cool if nix did that
- (-) swww -- just need it to run when sway starts
- ( ) install quartus, see Kronicle's Notes
-- This looks.... hard...
- ( ) Fix audio -- switch to pipewire and use easyeffects, maybe try to do that one at a time...
- (x) Screnlocker
- (x) fix firefox for canvas -- doesn't load on pages that arent quizzes?! -- Seems to have started after my ff -v 120 change?
- (x) xdg portal -- Works! I'm happy, but could do with a bit of themeing. I don't care for the moment however.
- (x) fix sway rofi bindings -- Done, pretty easy to fix, but the keyboards are not idea... so many nkro issues :(
- (x) Install new ram

- ( ) Make this installed via nix: https://addons.mozilla.org/en-US/firefox/addon/complete-black-theme-for-firef/

- (x) nvim -- I'm gonna keep working on it, but I'm very happy wiht it currently.
-- Making progress, slowly s
-- Also still need to work out how to make jdtls not complain if no dir root is found :/

* Fixes that would be nice:
- ( ) Add battery into pfetch, make pfetch not query packages
- ( ) Nixos replace colorschemes into configs
- ( ) firefox vencord, tridactyl
- ( ) lix on stable branch for less recompiles -- probably *really* easy, just havent bothered
- ( ) Work out a better method for ssh and kerberos configs which I don't want to be in git. -- Is this what sops is for?!
- ( ) get a notification daemon? I never use notifications, except for thunderbird (should probably leave for mutt) which has decided to pop up a full sway window on my current workspace whenever nagios wants to tell me that things which arent my problem are really not any worse than they were, but are still not perfect
- ( ) acpilight installed at system level on tetrahedron, then let polkit let it through without sudo? -- keybinds would be nice
-- after making polkit let it through, just drop bindings into sway config?
-- the package acpilight works, the command's still xbacklight, despite being on wayland.
- ( ) auto wifi connection -- This is probably just gonna require a broader switch to gnome-keyring from keepass. -- I'm still holding on hope to a keepass db reading a keyfile from sops!
-- What is sops even for? Like... I haven't really had any situations where I've needed it
- (x) firefox custom css


* New stuff that would be nice:
- ( ) install mutt
- ( ) firenvim
- ( ) Kronicle's DNS -- seems nice, not *needed* more of a infosec philosophy thing.
```

Notes:
```neorg
- Make a java link within an intelij project:
-- @code bash
   nix-build '<nixpkgs>' -A jdk -o jdk
   @end

```
