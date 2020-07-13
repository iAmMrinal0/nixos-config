# NixOS config for ThinkPad X1 Carbon
{ config, lib, pkgs, ... }:

{
  imports =
    [ ../hardware/carbon.nix
      ../base.nix
    ];

  networking.hostName = "vormir"; # Define your hostname.

  services.xserver.resolutions = [ { x = 1920; y = 1080; } ];

  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

  environment.variables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = lib.mkDefault "1";
  };
}