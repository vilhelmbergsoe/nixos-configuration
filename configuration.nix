{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./packages.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # Auto cleanup
  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "daily";
    };
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Use the systemd-boot EFI boot loader and clean /tmp on boot
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };
  boot.cleanTmpDir = true;

  # Set up networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # Set up locales (timezone and keyboard layout)
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "dk";
  };

  # X settings
  services.xserver = {
    layout = "dk";
    enable = true;
    libinput.enable = true;
    displayManager.lightdm.enable = true;
    windowManager.dwm.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vb = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.bash;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable slock program
  programs.slock.enable = true;

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
    enableSSHSupport = true;
  };

  # Disable graphical password prompt for git
  programs.ssh.askPassword = "";

  # Overlays
  nixpkgs.overlays = [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (old: { src = ./dwm ;});
      st = prev.st.overrideAttrs (old: { src = ./st ;});
      dmenu = prev.dmenu.overrideAttrs (old: { src = ./dmenu ;});
      slstatus = prev.slstatus.overrideAttrs (old: { src = ./slstatus ;});
    })
  ];

  # Do not touch
  system.stateVersion = "21.11"; # Did you read the comment?
}

