. ~/.local/share/../bin/env
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
. "$P10K_PATH"

alias -- sudo='run0'
alias -- doas='run0'
alias -- clean='mat2'
alias -- music_download='run0 mullvad-exclude run0 --user=quixaq yt-dlp --concurrent-fragments 10 -f "bestaudio/best" -xi --audio-quality 0 --audio-format opus --embed-thumbnail --embed-metadata -o "%(title)s.%(ext)s" --no-overwrites'
alias -- video_download='run0 mullvad-exclude run0 --user=quixaq yt-dlp --concurrent-fragments 10 -f "bv+ba/b" --embed-thumbnail --embed-metadata -o "%(title)s.%(ext)s" --no-overwrites'
alias -- ls='eza'
alias -- find='fd'
alias -- grep='rg'
alias -- cat='bat'
alias -- du='dust'
alias -- top='htop'
alias -- ps='procs'
alias -- neofetch='qfetch'
alias -- fastfetch='qfetch'

nh() {
    if [[ "$1" == "os" && "$2" == "switch" ]]; then
        command nh os boot "${@:3}" && (echo "\e[92m>\e[0m Switching to configuration" ; run0 /nix/var/nix/profiles/system/bin/switch-to-configuration test)
    else
        command nh "$@"
    fi
}
