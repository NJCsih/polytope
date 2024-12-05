# Simple little wrapper for ls, just provides some less verbose shortcuts for
# common operations I do frequently, and formats nicer.
#
# It is significantly slower on large operations, but it's usually not a
# problem, and I can just ls if I'm gonna say `ls /nix/store | find 'package'`,
# grepping this would be the wrong way to go about that anyway.

def l [ -a                  # -a     | show everything (ls -a)
      , -l: string          # -l     | columns to show
      , -s: string          # -s     | sort by
      , -S: string          # -S     | sort by reverse
      , -i                  # -i     | if we should include index in table
      , --sel: string       # --sel  | what columns to show
      , inputpath?: string  #        | what dir to ls
      ] {


    # Input filepath handling --------------------------------------------------
    mut $path = "";
    if ($inputpath == null) {
        $path = ".";
    } else {
        $path = $inputpath
    }

    let myuser = whoami;
    $path = (echo $path | str replace '~' (['/home/', $myuser] | str join));


    # Aquire lsdata ------------------------------------------------------------
    mut lsdata: table = [{}];
    if ($a) {
        $lsdata = ls -la $path;
    } else {
        $lsdata = ls -l $path;
    }


    # Sort columns if asked ----------------------------------------------------
    if ($s != null) {
        $lsdata = $lsdata | sort-by {$s};
    }
    if ($s != null) {
        $lsdata = $lsdata | sort-by {$s} --reverse;
    }


    # Select columns if asked --------------------------------------------------
    if ($sel != null) {
        $lsdata = $lsdata | select $sel;
    } else {
        $lsdata = $lsdata | select name type size modified mode;
    }


    # Convert to table  and output ---------------------------------------------
    $lsdata = $lsdata | table -i $i -t light;
    return $lsdata
}
