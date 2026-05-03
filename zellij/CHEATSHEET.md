# Zellij Cheatsheet

This cheatsheet matches the keybindings in `config.kdl`.

## Basics

- Start mode: `locked`
- Enter normal mode: `Ctrl g`
- Return to locked mode: `Ctrl g`
- Quit Zellij: `Ctrl g`, then `Ctrl q`
- Detach session: `Ctrl g`, then `o`, then `d`

## Direct Shortcuts

These work in both `locked` and `normal` modes.

- Move focus: `Alt h/j/k/l` or `Alt Left/Down/Up/Right`
- Move focus or tab horizontally: `Alt h/l` or `Alt Left/Right`
- Previous / next tab: `Alt ,`, `Alt .`
- New pane: `Alt n`
- Toggle floating panes: `Alt f`
- Resize pane: `Alt +`, `Alt =`, `Alt -`
- Previous / next swap layout: `Alt [`, `Alt ]`
- Move tab left / right: `Alt i`, `Alt o`
- Toggle pane in group: `Alt p`
- Toggle group marking: `Alt Shift p`

## Mode Menu

From `normal` mode:

- Pane mode: `p`
- Tab mode: `t`
- Resize mode: `r`
- Move mode: `m`
- Scroll mode: `s`
- Session mode: `o`
- Lock Zellij: `Ctrl g`

Because the default mode is `locked`, press `Ctrl g` first before using these.

## Pane Mode

Enter with `Ctrl g`, then `p`.

- Move focus: `h/j/k/l` or arrow keys
- Switch focus: `Tab`
- New pane: `n`
- New pane below: `d`
- New pane right: `r`
- New stacked pane: `s`
- Close focused pane: `x`
- Toggle fullscreen: `f`
- Toggle floating / embedded: `e`
- Toggle floating panes: `w`
- Toggle pane frames: `z`
- Toggle pane pinned: `i`
- Rename pane: `c`
- Return to normal mode: `p`

## Tab Mode

Enter with `Ctrl g`, then `t`.

- Go to tab 1-9: `1` ... `9`
- Previous tab: `h`, `k`, `Left`, `Up`
- Next tab: `j`, `l`, `Down`, `Right`
- Toggle last tab: `Tab`
- New tab: `n`
- Close tab: `x`
- Rename tab: `r`
- Toggle sync tab: `s`
- Break pane into new tab: `b`
- Break pane left / right: `[`, `]`
- Return to normal mode: `t`

## Resize Mode

Enter with `Ctrl g`, then `r`.

- Increase size: `+`, `=`
- Decrease size: `-`
- Resize toward left/down/up/right: `h/j/k/l` or arrow keys
- Resize away from left/down/up/right: `H/J/K/L`
- Return to normal mode: `r`

## Move Mode

Enter with `Ctrl g`, then `m`.

- Move pane: `h/j/k/l` or arrow keys
- Move pane forward: `n` or `Tab`
- Move pane backward: `p`
- Return to normal mode: `m`

## Scroll And Search

Enter scroll mode with `Ctrl g`, then `s`.

- Scroll line: `j/k` or `Down/Up`
- Page scroll: `h/l`, `Left/Right`, `PageUp/PageDown`, `Ctrl b`, `Ctrl f`
- Half-page scroll: `u`, `d`
- Edit scrollback: `e`
- Start search: `f`
- Scroll to bottom and lock: `Ctrl c`
- Return to normal mode: `s`

In search mode:

- Search down / up: `n`, `p`
- Toggle case sensitivity: `c`
- Toggle whole word: `o`
- Toggle wrap: `w`

## Session Mode

Enter with `Ctrl g`, then `o`.

- Detach: `d`
- Session manager: `w`
- Layout manager: `l`
- Plugin manager: `p`
- Configuration: `c`
- About: `a`
- Share: `s`
- Return to normal mode: `o`

## Current UI Choices

- Theme: `gruvbox-dark-hard`
- Simplified UI separators: enabled
- Pane frames: enabled
