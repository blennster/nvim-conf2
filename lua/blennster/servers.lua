local M = {}

M.servers = function()
    local efmEslint = require('efmls-configs.linters.eslint')
    local efmPrettier = require('efmls-configs.formatters.prettier')
    local efmLanguages = {
        python = {
            require('efmls-configs.linters.flake8'),
            require('efmls-configs.formatters.autopep8'),
        },
        rust = { require('efmls-configs.formatters.rustfmt') },
        go = { require('efmls-configs.formatters.gofmt') },
        sh = {
            {
                formatCommand = "shfmt -i 2 -sr -ci -",
                formatStdin = true
            },
            require('efmls-configs.linters.shellcheck')
        },
        yaml = {
            {
                formatCommand = "yamlfmt -formatter retain_line_breaks=true,indentless_arrays=false -in",
                formatStdin = true
            }
        },
        typescript = { efmEslint },
        javascript = { efmEslint },
        typescriptreact = { efmEslint },
        javascriptreact = { efmEslint },
        json = { efmPrettier },
        markdown = { efmPrettier }
    }

    -- Enable the following language servers
    local servers = {
        -- https://github.com/creativenull/efmls-configs-nvim
        efm = {
            init_options = { documentFormatting = true },
            settings = {
                rootMarkers = { ".git/" },
                languages = efmLanguages
            },
            filetypes = vim.tbl_keys(efmLanguages)
        },
        clangd = {},
        gopls = {},
        pyright = {},
        rust_analyzer = {},
        yamlls = {
            settings = {
                yaml = {
                    schemaStore = { enable = false, url = '' },
                    schemas = require('schemastore').yaml.schemas(),
                }
            }
        },
        nil_ls = {
            settings = {
                ['nil'] = {
                    formatting = {
                        command = { "alejandra" }
                    }
                }
            }
        },
        -- tsserver = {},
        -- html = { filetypes = { 'html', 'twig', 'hbs'} },
        lua_ls = {
            settings = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                },
            }
        },
        jdtls = {
            cmd = { "jdt-language-server",
                "-configuration", vim.fn.expand("~/.jdtls/config"),
                "-data", vim.fn.expand("~/.jdtls/workspace")
            },
            init_options = {
                extendedClientCapabilities = {
                    progressReportProvider = true,
                },
            },
        },
        jsonls = {
            settings = {
                json = {
                    schemas = require('schemastore').json.schemas(),
                    validate = true,
                },
            },
            cmd = { "vscode-json-languageserver", "--stdio" }
        },
        bashls = {},
        tsserver = {},
    }

    return servers
end

return M
