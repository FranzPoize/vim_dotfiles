if status is-interactive
    # Commands to run in interactive sessions can go here
    set MAKEFLAGS "-j"(nproc) 
    fish_add_path /home/franz/.deno/bin
end
set -x MANPAGER 'nvim +Man!'
set -x MANWIDTH 999 

set -x CC /usr/bin/clang
set -x CXX /usr/bin/clang++
set -x PYTHONBREAKPOINT kalong.breakpoint
