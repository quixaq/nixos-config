{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntax-highlighting.enable = true;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "";
    };

    shellAliases = {
      sudo = "doas";
      clean = "mat2";
      music_download = "mullvad-exclude yt-dlp --concurrent-fragments 10 -f \"bestaudio/best\" -xi --audio-quality 0 --audio-format opus --embed-thumbnail --embed-metadata -o \"%(title)s.%(ext)s\" --no-overwrites";
      video_download = "mullvad-exclude yt-dlp --concurrent-fragments 10 -f \"bv+ba/b\" --embed-thumbnail --embed-metadata -o \"%(title)s.%(ext)s\" --no-overwrites";
      ls = "eza";
      find = "fd";
      grep = "rg";
      cat = "bat";
      du = "dust";
      top = "htop";
      ps = "procs";
    };
  };
}
