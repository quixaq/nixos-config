{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.quixaq = {
    isNormalUser = true;
    description = "quixaq";
    extraGroups = [
      "networkmanager"
      "realtime"
      "audio"
      "render"
      "video"
      "kvm"
    ];
    shell = pkgs.zsh;
    # packages = with pkgs; [];
    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];
  };
}
