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
        vim.opt.clipboard = "unnamedplus" -- Use system clipboard for yank/paste
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
        mappings = {
          goToDefinition = "gd";
          goToDeclaration = "gD";
          goToType = "gy";
          listImplementations = "gI";
          listReferences = "gr";
          hover = "K";
          renameSymbol = "<leader>rn";
          codeAction = "<leader>ca";
          nextDiagnostic = "]d";
          previousDiagnostic = "[d";
          signatureHelp = "<C-k>";
        };
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

      # fzf-lua for fuzzy finding
      fzf-lua = {
        enable = true;
        profile = "telescope"; # Use telescope-like profile for familiar UX
        setupOpts = {
          winopts = {
            border = "rounded";
          };
        };
      };

      # File explorer
      filetree = {
        nvimTree = {
          enable = true;
          openOnSetup = false;
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

      # Dashboard
      dashboard = {
        alpha = {
          enable = true;
          theme = "dashboard"; # Options: "dashboard", "startify", "theta"
        };
      };

      # Customize alpha dashboard buttons to match keybindings
      luaConfigRC.alphaButtons = ''
        local alpha = require('alpha')
        local dashboard = require('alpha.themes.dashboard')

        -- Override buttons with your custom keybindings
        dashboard.section.buttons.val = {
          dashboard.button("SPC SPC", "  Find file", ":lua require('fzf-lua').files()<CR>"),
          dashboard.button("SPC /", "  Find text", ":lua require('fzf-lua').live_grep()<CR>"),
          dashboard.button("SPC f r", "  Recent files", ":lua require('fzf-lua').oldfiles()<CR>"),
          dashboard.button("SPC e", "  File explorer", ":NvimTreeToggle<CR>"),
          dashboard.button("q", "  Quit", ":qa<CR>"),
        }

        alpha.setup(dashboard.opts)
      '';
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

      # Indent guides, scope highlighting, smooth scrolling, and git features
      extraPlugins = {
        snacks-nvim = {
          package = pkgs.vimPlugins.snacks-nvim;
          setup = ''
            require('snacks').setup({
              indent = {
                enabled = true,
                char = "▏",
              },
              scope = {
                enabled = true,
              },
              scroll = {
                enabled = true,
              },
              git = {
                enabled = true,
              },
            })
          '';
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

        scala = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };

        java = {
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
        # Insert mode: Restore Ctrl+W for word deletion
        # (keyd remaps it system-wide, so we need to handle it)
        {
          key = "<C-w>";
          mode = "i";
          action = "<C-o>db";
          silent = true;
          desc = "Delete word backwards";
        }
        # fzf-lua keybindings
        {
          key = "<leader><space>";
          mode = "n";
          action = "<cmd>lua require('fzf-lua').files()<CR>";
          silent = true;
          desc = "Find files";
        }
        {
          key = "<leader>/";
          mode = "n";
          action = "<cmd>lua require('fzf-lua').live_grep()<CR>";
          silent = true;
          desc = "Live grep";
        }
        {
          key = "<leader>fb";
          mode = "n";
          action = "<cmd>lua require('fzf-lua').buffers()<CR>";
          silent = true;
          desc = "Find buffers";
        }
        {
          key = "<leader>fh";
          mode = "n";
          action = "<cmd>lua require('fzf-lua').help_tags()<CR>";
          silent = true;
          desc = "Help tags";
        }
        {
          key = "<leader>fr";
          mode = "n";
          action = "<cmd>lua require('fzf-lua').oldfiles()<CR>";
          silent = true;
          desc = "Recent files";
        }
        {
          key = "<leader>fc";
          mode = "n";
          action = "<cmd>lua require('fzf-lua').commands()<CR>";
          silent = true;
          desc = "Find commands";
        }
        {
          key = "<leader>gs";
          mode = "n";
          action = "<cmd>lua require('fzf-lua').git_status()<CR>";
          silent = true;
          desc = "Git status";
        }
        # Diagnostics
        {
          key = "ud";
          mode = "n";
          action = "<cmd>lua vim.diagnostic.open_float()<CR>";
          silent = true;
          desc = "Show diagnostics";
        }
        {
          key = "<leader>td";
          mode = "n";
          action = "<cmd>lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>";
          silent = true;
          desc = "Toggle diagnostics";
        }
        # Buffer management
        {
          key = "bd";
          mode = "n";
          action = "<cmd>bdelete<CR>";
          silent = true;
          desc = "Close active buffer";
        }
        # Git blame
        {
          key = "gb";
          mode = "n";
          action = "<cmd>lua Snacks.git.blame_line()<CR>";
          silent = true;
          desc = "Git blame line";
        }
      ];
    };
  };
}
