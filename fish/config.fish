if status is-interactive
    # No greeting
    set fish_greeting
    
    # Starship
    starship init fish | source
end