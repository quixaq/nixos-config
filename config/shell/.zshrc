. ~/.local/share/../bin/env
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
. /run/current-system/sw/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

alias sudo='doas'
alias clean='mat2'
alias music_download='mullvad-exclude yt-dlp --concurrent-fragments 10 -f \"bestaudio/best\" -xi --audio-quality 0 --audio-format opus --embed-thumbnail --embed-metadata -o \"%(title)s.%(ext)s\" --no-overwrites'
alias video_download='mullvad-exclude yt-dlp --concurrent-fragments 10 -f \"bv+ba/b\" --embed-thumbnail --embed-metadata -o \"%(title)s.%(ext)s\" --no-overwrites'
alias ls='eza'
alias find='fd'
alias grep='rg'
alias cat='bat'
alias du='dust'
alias top='htop'
alias ps='procs'
alias neofetch='qfetch'
alias fastfetch='qfetch'
alias nixbuild='nh os build && (doas /bin/sh -c "./result/bin/switch-to-configuration test ; ./result/bin/switch-to-configuration boot" ; rm result)'
