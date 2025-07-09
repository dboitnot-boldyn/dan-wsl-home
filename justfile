_default:
    just --list

# Re-run recipe CMD whenever a file changes
watch CMD *ARGS:
    nix-shell -p watchexec --command "watchexec -c -r --stdin-quit --stop-timeout=2s -d 500ms --print-events -- just {{CMD}} {{ARGS}}"
alias w := watch

switch:
    home-manager switch

test-fetch: switch
    fastfetch

show-starship *ARGS:
    #!/usr/bin/env bash
    set -euo pipefail
    export PS1="$(starship prompt {{ARGS}})"
    echo "${PS1@P}"

@explain-starship *ARGS: (show-starship ARGS)
    starship explain {{ARGS}}
    echo

test-starship: switch 
    just explain-starship
    just explain-starship -s 1
    AWS_PROFILE=sandbox just explain-starship
    just -d / --justfile {{justfile()}} explain-starship

test-eza: switch
    eza -l
