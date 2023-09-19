set -x MANPAGER 'nvim +Man!'
set -x MANWIDTH 999 

set -x CC /usr/bin/clang
set -x CXX /usr/bin/clang++
set -x PYTHONBREAKPOINT kalong.breakpoint
set -x VISUAL nvim

starship init fish | source
