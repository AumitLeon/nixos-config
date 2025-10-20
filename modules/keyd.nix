{
  config,
  pkgs,
  ...
}: {
  # Enable keyd for system-wide key remapping
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
        settings = {
          main = {
            # Map Super key to act as Command (Meta) for Mac-style shortcuts
            # This matches standard Mac keyboard layout
            leftmeta = "layer(meta)";
            rightmeta = "layer(meta)";
          };

          # Meta layer - when you hold the physical Super key (Command)
          meta = {
            # Basic text editing (Mac-style)
            c = "C-c"; # Copy
            v = "C-v"; # Paste
            x = "C-x"; # Cut
            z = "C-z"; # Undo

            # File operations
            s = "C-s"; # Save
            o = "C-o"; # Open
            n = "C-n"; # New
            w = "C-w"; # Close tab/window
            q = "C-q"; # Quit

            # Text navigation (Mac-style)
            a = "C-a"; # Select all
            f = "C-f"; # Find

            # Tab management
            t = "C-t"; # New tab
            tab = "C-tab"; # Switch tabs

            # Terminal shortcuts (Ghostty)
            # Note: 'd' is handled natively by Ghostty (not remapped to avoid Ctrl+d EOF conflict)
            d = "C-d"; # Split tab right
            k = "C-k"; # Clear screen
            leftbrace = "C-leftbrace"; # Previous split / go to split
            rightbrace = "C-rightbrace"; # Next split / go to split

            # Text formatting
            b = "C-b"; # Bold
            i = "C-i"; # Italic
            u = "C-u"; # Underline

            # Zoom
            equal = "C-equal"; # Zoom in (Command+=)
            minus = "C-minus"; # Zoom out (Command+-)
            "0" = "C-0"; # Reset zoom

            # Browser shortcuts
            r = "C-r"; # Reload
            l = "C-l"; # Focus address bar

            # Arrow key navigation (Mac-style word/line jumping)
            left = "home"; # Jump to beginning of line
            right = "end"; # Jump to end of line
            up = "C-home"; # Jump to beginning of document
            down = "C-end"; # Jump to end of document

            # Backspace/Delete (Mac-style)
            backspace = "C-backspace"; # Delete word
          };

          # Alt layer - when you hold the physical Alt key (Option)
          alt = {
            # Word-by-word navigation
            left = "C-left"; # Jump word left
            right = "C-right"; # Jump word right

            # Delete word
            backspace = "C-backspace";

            # Tab switching (Alt+number to switch tabs in browsers)
            "1" = "A-1";
            "2" = "A-2";
            "3" = "A-3";
            "4" = "A-4";
            "5" = "A-5";
            "6" = "A-6";
            "7" = "A-7";
            "8" = "A-8";
            "9" = "A-9";
          };

          # Shift+Meta layer for shifted shortcuts
          "shift+meta" = {
            # Redo
            z = "C-S-z";

            # Tab navigation
            tab = "C-S-tab"; # Previous tab

            # Reverse find
            f = "C-S-f";

            # Terminal shortcuts (Ghostty)
            # Note: 'd' is handled natively by Ghostty (not remapped to avoid conflicts)
            leftbrace = "C-S-leftbrace"; # Previous tab
            rightbrace = "C-S-rightbrace"; # Next tab
            w = "C-S-w"; # Close window
          };
        };
      };
    };
  };
}
