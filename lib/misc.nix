{ lib, ... }:
rec {
  writeScript =
    pkgs: name: content:
    pkgs.writeTextFile {
      inherit name;
      executable = true;
      text = content;
      destination = "/bin/${name}";
      meta.mainProgram = name;
    };

}
