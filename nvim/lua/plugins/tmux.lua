--------------------------------------------------------------------------------
--# TMUX Related Plugins #------------------------------------------------------

vim.pack.add({
    'https://github.com/christoomey/vim-tmux-navigator', -- vim tmux keybinds
    'https://github.com/karnull/switchboard.nvim',       -- execute in tmux
})

--# TMUX Compile #--------------------------------------------------------------

require('switchboard').setup({
    save_session = true,
    local_config = ".commands",
    overlay_sleep = 0,

    commands = {
        lazygit = "lazygit",
        copilot = 'copilot',
    },

    build_run_config = {{
        extension = {'c', 'cpp', 'h', 'ino'},
        cd_root   =  true,
        commands  = {
            run   = 'make run',
            build = 'make',
            debug = 'gdb ./bin',
        },
        binds = {
            label = 'O/*<Esc>76A-<Esc>A*/<CR>',
            import= 'I#include ',
            openbr= 'o{<CR>}<Esc>O',
        }
    },{
        extension = {'rs'},
        commands  = {
            run   = 'cargo run',
            build = 'cargo build',
        }
    },{
        extension = {'go'},
        cd_root   = true,
        commands  = {
            run   = 'go run .',
            build = 'go build .',
            debug = 'dlv debug',
        },
        binds = {
            label = 'O/*<Esc>76A=<Esc>A*/<CR>',
            import= 'Iimport ""<Esc>i',
            openbr= 'A {<CR>}<Esc>O',
        }
    },{
        extension = {'py'},
        cd_root   = true,
        commands  = {
            run   = 'uv run main',
            build = 'uv run pyinstaller --onefile --name bin --specpath ./build --console --noconfirm ./*/__main__.py',
        },
        binds = {
            label = 'O#<Esc>79A=<Esc>jgUU',
            import= 'Iimport ',
        }
    }},
})


-- Map() defined in nvim/lua/binds/keybinds.lua

Map('n', '<leader>rr', ':Switchboard overlay run<CR>')
Map('n', '<leader>r]', ':Switchboard vsplit run<CR>')
Map('n', '<leader>r[', ':Switchboard split run<CR>')
Map('n', '<leader>bb', ':Switchboard overlay build<CR>')

Map('n', '<leader>b]', ':Switchboard vsplit build<CR>')
Map('n', '<leader>b[', ':Switchboard split build<CR>')
Map('n', '<leader>dd', ':Switchboard overlay debug<CR>')
Map('n', '<leader>db', ':Switchboard background debug<CR>')

Map('n', '<leader>gg', ':Switchboard overlay lazygit<CR>')
Map('n', '<leader>a', ':Switchboard overlay copilot<CR>')

Map('ni', '<leader>il', ':Switchboard bind label<CR>')
Map('ni', '<leader>ii', ':Switchboard bind import<CR>')
Map('ni', '<leader>{' , ':Switchboard bind openbr<CR>')

