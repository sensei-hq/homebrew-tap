# homebrew-tap

Homebrew tap for [sensei](https://github.com/sensei-hq/sensei) — AI development intelligence for coding agents.

## Install

```sh
brew tap sensei-hq/tap
brew install sensei-hq/tap/sensei
```

This installs two binaries:

| Binary | Purpose |
|--------|---------|
| `sensei` | Interactive CLI — `sensei init`, `sensei index`, `sensei skills`, etc. |
| `senseid` | Background daemon — MCP server + indexing queue |

## Run as a background service

```sh
brew services start sensei-hq/tap/sensei
```

`senseid` starts automatically on login, runs the MCP server on `localhost:7320`, and indexes your repos in the background (up to 4 parallel workers).

## Install the desktop app

```sh
brew install --cask sensei-hq/tap/sensei-app
```

## Build flavors

Single command per build flavor — no Brewfile to fetch.

```sh
# Stable / production
brew install sensei-hq/tap/sensei

# Dev / contributor (built from develop branch HEAD)
brew install --HEAD sensei-hq/tap/sensei-dev
```

The first run of the daemon installs missing prerequisites (`postgresql@17`,
`ollama`) automatically via per-component install resolvers — no separate
`brew bundle` step needed.

## Formulas

| Formula | Description |
|---------|-------------|
| [`Formula/sensei.rb`](Formula/sensei.rb) | CLI + daemon binaries |
| [`Casks/sensei-app.rb`](Casks/sensei-app.rb) | macOS desktop app |

## Updating

```sh
brew update
brew upgrade sensei
```

## Uninstall

```sh
brew uninstall sensei
brew untap sensei-hq/tap
```

To also remove all app data:

```sh
rm -rf ~/.sensei
```
