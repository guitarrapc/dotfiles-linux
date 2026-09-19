dotfiles-linux

## target Distro

* Ubuntu 22.04 LTS (Both standalone & WSL)
* Ubuntu 20.04 LTS (Both standalone & WSL)
* Ubuntu 18.04 LTS (Both standalone & WSL)

## Ref

* top configuration: https://beyondjapan.com/blog/2021/10/tips_for_top_command/

## Codex skills

`HOME/.agents/skills` contains the user-level Codex skills. The repository-root
`dotfiles_link_dirs` selects each skill directory for linking to
`~/.agents/skills/<skill-name>` as a whole, so `SKILL.md` remains a regular file.

Use a version of DotfilesLinker or dotfileslinker-go that supports
`dotfiles_link_dirs`; older binaries and the legacy install scripts do not
apply this setting. From this repository root, preview and then apply:

```shell
dotfileslinker --dry-run --force
dotfileslinker --force
```

`--force` is needed when replacing existing directories containing file-level
links. It replaces existing destinations, so preserve any local-only files first.
