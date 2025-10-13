{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
  ];
  # Replace the basic neovim config with nvf
  programs.nvf = {
    enable = true;
    enableManpages = true;

    settings.vim = {
      viAlias = true;
      vimAlias = true;

      # Prevent junk files
      preventJunkFiles = true;

      # Basic settings
      lineNumberMode = "relNumber";

      # Set tab width using luaConfigRC
      luaConfigRC.tabSettings = ''
        vim.opt.tabstop = 2        -- Number of spaces tabs count for
        vim.opt.shiftwidth = 2     -- Size of an indent
        vim.opt.expandtab = true   -- Use spaces instead of tabs
        vim.opt.softtabstop = 2    -- Number of spaces per Tab
        vim.opt.smartindent = true -- Smart autoindenting on new lines
      '';

      # Add commenting support with gc
      comments = {
        comment-nvim = {
          enable = true;
        };
      };

      # Theme - choose one you like
      theme = {
        enable = true;
        name = "gruvbox"; # Options: "catppuccin", "onedark", "tokyonight", "gruvbox", "nord"
        style = "dark"; # For catppuccin: "mocha", "macchiato", "frappe", "latte"
      };

      # LSP support
      lsp = {
        enable = true;
        formatOnSave = true;
        lspkind.enable = true;
      };

      # Debugger
      debugger = {
        nvim-dap = {
          enable = true;
          ui.enable = true;
        };
      };

      # Autocomplete
      autocomplete = {
        nvim-cmp = {
          enable = true;
        };
      };

      # Treesitter for syntax highlighting
      treesitter = {
        enable = true;
        fold = true;
        context.enable = true;
      };

      # Telescope for fuzzy finding
      telescope = {
        enable = true;
      };

      # File explorer
      filetree = {
        nvimTree = {
          enable = true;
          mappings = {
            toggle = "<leader>e";
            findFile = "<leader>f";
          };
        };
      };

      # Git integration
      git = {
        enable = true;
        gitsigns = {
          enable = true;
          codeActions.enable = true;
        };
      };

      # Status line
      statusline = {
        lualine = {
          enable = true;
          theme = "auto";
        };
      };

      # Buffer/tab line
      tabline = {
        nvimBufferline = {
          enable = true;
        };
      };

      # Terminal
      terminal = {
        toggleterm = {
          enable = true;
          mappings.open = "<C-t>";
        };
      };
      #
      # # Utility plugins
      # utility = {
      #   diffview-nvim.enable = true;
      #
      #   # Markdown preview
      #   # markdown-preview.enable = true;
      #
      #   # Comment toggling
      #   comment-nvim.enable = true;
      # };

      # UI enhancements
      ui = {
        noice.enable = true; # Better UI for messages, cmdline and popupmenu
        borders = {
          enable = true;
          globalStyle = "rounded";
        };
      };

      # Language support
      languages = {
        nix = {
          enable = true;
          format.enable = true;
          lsp = {
            enable = true;
            server = "nixd"; # or "nil"
          };
          treesitter.enable = true;
        };

        bash = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };

        python = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
          format.enable = true;
        };

        markdown = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };

        # Add more languages as needed:
        # rust = {
        #   enable = true;
        #   lsp.enable = true;
        #   treesitter.enable = true;
        # };
        #
        # ts = {  # TypeScript/JavaScript
        #   enable = true;
        #   lsp.enable = true;
        #   treesitter.enable = true;
        # };
        #
        # go = {
        #   enable = true;
        #   lsp.enable = true;
        #   treesitter.enable = true;
        # };
      };

      # Custom keybindings
      keymaps = [
        # Telescope keybindings
        {
          key = "<leader><space>";
          mode = "n";
          action = "<cmd>Telescope find_files<CR>";
          silent = true;
          desc = "Find files";
        }
        {
          key = "<leader>/";
          mode = "n";
          action = "<cmd>Telescope live_grep<CR>";
          silent = true;
          desc = "Live grep";
        }
        {
          key = "<leader>fb";
          mode = "n";
          action = "<cmd>Telescope buffers<CR>";
          silent = true;
          desc = "Find buffers";
        }
        {
          key = "<leader>fh";
          mode = "n";
          action = "<cmd>Telescope help_tags<CR>";
          silent = true;
          desc = "Help tags";
        }
        {
          key = "<leader>fr";
          mode = "n";
          action = "<cmd>Telescope oldfiles<CR>";
          silent = true;
          desc = "Recent files";
        }
        {
          key = "<leader>fc";
          mode = "n";
          action = "<cmd>Telescope commands<CR>";
          silent = true;
          desc = "Find commands";
        }
        {
          key = "<leader>gs";
          mode = "n";
          action = "<cmd>Telescope git_status<CR>";
          silent = true;
          desc = "Git status";
        }

        # ... your other keybindings ...
      ];
    };
  };
}
