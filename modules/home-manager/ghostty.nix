{
  config,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;

    settings = {
      theme = "Gruvbox Dark Hard";

      # Keybindings
      # Note: keyd remaps super (Cmd) to ctrl, so Ghostty receives ctrl events
      keybind = [
        "ctrl+c=copy_to_clipboard"
        "ctrl+v=paste_from_clipboard"
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
        "ctrl+equal=increase_font_size:1"
        "ctrl+minus=decrease_font_size:1"
        "ctrl+0=reset_font_size"
        "ctrl+q=quit"
        "ctrl+shift+comma=reload_config"
        "ctrl+k=clear_screen"
        "ctrl+n=new_window"
        # "ctrl+w=close_surface"  # Disabled to allow Neovim's Ctrl+W for word deletion
        "ctrl+shift+w=close_surface"
        "ctrl+t=new_tab"
        "ctrl+shift+left_bracket=previous_tab"
        "ctrl+shift+right_bracket=next_tab"
        "ctrl+d=new_split:right"
        "ctrl+shift+d=new_split:down"
        "ctrl+right_bracket=goto_split:next"
        #"ctrl+left_bracket=goto_split:previous"
      ];
    };
  };
}
