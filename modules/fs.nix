{
  fileSystems."/" = {
    options = [
      "compress-force=zstd:1"
      "noatime"
    ];
  };
  fileSystems."/home" = {
    options = [
      "compress-force=zstd:1"
      "noatime"
    ];
  };
  fileSystems."/data" = {
    options = [
      "compress-force=zstd:1"
      "noatime"
    ];
  };
}
