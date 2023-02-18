if status is-interactive
    # Commands to run in interactive sessions can go here
    set MAKEFLAGS "-j"(nproc) 
    fish_add_path /home/franz/.deno/bin
end
