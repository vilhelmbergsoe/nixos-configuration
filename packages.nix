{ pkgs, config, ... }:

let

in

{
  # Install all the packages
  environment.systemPackages = with pkgs; [
    # Desktop
    dmenu st slstatus clipmenu feh dunst brightnessctl xclip pywal

    # Command-line tools
    vim ripgrep fd lf tmux pass gnupg ffmpeg libnotify htop imagemagick file

    # GUI applications
    ungoogled-chromium mpv sxiv pcmanfm

    # Development
    git gcc gnumake go
  ];
}
