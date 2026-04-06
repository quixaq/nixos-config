{ pkgs, ... }:

{
  # Musnix
  musnix = {
    enable = true;
    kernel.realtime = true;
    kernel.packages = pkgs.linuxKernel.packages.linux_xanmod_stable;
    rtirq.enable = true;
    rtcqs.enable = true;
    das_watchdog.enable = true;
  };
  # PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire."92-no-stutter" = {
      "context.properties" = {
        "default.clock.rate" = 96000;
        "default.clock.allowed-rates" = [
          32000
          44100
          48000
          96000
        ];
        "default.clock.quantum" = 2048;
        "default.clock.min-quantum" = 2048;
        "default.clock.max-quantum" = 4096;
        "default.thread.prio" = 80;
      };
    };
    extraConfig.pipewire-pulse."92-low-latency" = {
      "context.properties" = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = { };
        }
      ];
      "pulse.properties" = {
        "pulse.min.quantum" = "2048/48000";
        "pulse.max.quantum" = "4096/48000";
      };
    };
  };
}
