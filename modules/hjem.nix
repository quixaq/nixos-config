{
  hjem = {
    users = {
      quixaq = {
        user = "quixaq";
        directory = "/home/quixaq";

        xdg.config.files = {
          "hypr".source = ../config/hypr;
          "mimeapps.list".source = ../config/mimeapps.list;
          "kitty/kitty.conf".source = ../config/kitty.conf;
          "rofi/config.rasi".source = ../config/rofi/config.rasi;
          "waybar".source = ../config/waybar;
          "gtk-3.0/settings.ini".source = ../config/gtk3.ini;
          "clipse/config.json".source = ../config/clipse.json;
        };
        files = {
          ".p10k.zsh".source = ../config/shell/p10k.zsh;
          ".zshrc".source = ../config/shell/.zshrc;
          ".gitconfig".source = ../config/git/.gitconfig;
          ".ssh/allowed_signers".source = ../config/git/allowed_signers;
          ".local/share/rofi/themes/custom.rasi".source = ../config/rofi/theme.rasi;
        };
      };
    };
  };
}
