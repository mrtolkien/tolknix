{ pkgs, ... }:

# macOS-specific packages
{
  home.packages = with pkgs; [
    # Flutter development (macOS-specific)
    cocoapods
  ];
}
