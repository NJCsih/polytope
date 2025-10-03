# Courtesy of darkKronicle's evil genius

{ ... }:
final: prev: {
  # Override unwrapped, not normal
  virtualbox = prev.virtualbox.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [
      # https://github.com/aanderse/nixpkgs/blob/1a41cc3687c5aedbb6464c897e900e9724570a11/pkgs/applications/virtualization/virtualbox/default.nix
      # curl 8.16 upgrade breakage
      (prev.fetchpatch {
        url = "https://salsa.debian.org/pkg-virtualbox-team/virtualbox/-/raw/dbf9a6ef75380ebd2705df0198c6ac8073d0b4cb/debian/patches/new-curl.patch";
        hash = "sha256-WWnCWdXlJo9jTr8yXA0NxcDQBScryuu/53wyX0rhszk=";
      })
    ];
  });
}
