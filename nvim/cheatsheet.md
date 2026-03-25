# Neovim Config Cheatsheet

轻量配置，偏向 80 列编码和小屏使用。

## 1. 核心导航
- `j` / `k` : 智能折行跳转。
- `Ctrl + d/u` : 半屏翻页并居中。
- `n` / `N` : 搜索跳转并居中。
- `<leader>c` : 清除搜索高亮。
- `<leader>x` : 黑洞删除。
- 视觉模式 `p` : 粘贴不覆盖寄存器。

## 2. Buffer 与窗口
- `<leader>bb` : 上一个 Buffer。
- `<leader>bn` / `<leader>bp` : 下一个 / 上一个 Buffer。
- `<leader>bd` : 安全删除当前 Buffer。
- `Ctrl + h/j/k/l` : 在窗口间移动。
- `<leader>wv` / `<leader>wh` : 垂直 / 水平分屏。
- `<leader>wc` : 关闭当前窗口。
- `tmux` : `<leader>rh/rj/rk/rl` 调整窗口大小。
- 非 `tmux` : `Ctrl + ←/↓/↑/→` 调整窗口大小。

## 3. 文件与搜索
- `<leader>e` : 文件浏览器。
- `<leader>ff` : 查找文件。
- `<leader>fg` : 全局搜索。
- `<leader>fb` : Buffer 列表。
- `<leader>fo` : 最近文件。
- `<leader>fx` : 当前文档诊断。
- `<leader>fz` : 当前 Buffer 搜索行。
- `<leader>fp` : 复制当前文件绝对路径。

## 4. LSP 与诊断
- `gd` : 跳转到定义。
- `gr` : 查看引用。
- `gi` : 跳转到实现。
- `gt` : 跳转到类型定义。
- `K` : 显示悬浮文档。
- `<leader>la` : Code Action。
- `<leader>lr` : Rename。
- `<leader>ls` : 文档符号。
- `<leader>bf` : 格式化。
- `[d` / `]d` : 上一个 / 下一个诊断。
- `<leader>ld` : 当前行诊断。
- `<leader>lt` : 开关诊断。

## 5. Git
- `<leader>gs` : 列出 Git hunks。
- `<leader>gn` / `<leader>gp` : 跳到下一个 / 上一个 hunk。
- `<leader>gh` : 切换 hunk overlay。
- Git 变更显示在线号上，不占 `signcolumn`。

## 6. 编辑增强
- `sa` / `sd` / `sr` : surround 添加 / 删除 / 替换。
- `gx` : 交换文本。
- `gm` : 复制 / 倍增文本。
- `gs` : 排序。
- 视觉模式 `<` / `>` : 缩进后保持选区。
- `|` : 当前缩进范围提示。

## 7. Mini Clue
- 前缀提示：`<leader>`、`g`、`[`、`]`、`z`、寄存器、窗口。
- `g` 仅显示：`gd`、`gr`、`gi`、`gt`、`gx`、`gs`。
- clue 窗口已收窄。

## 8. 界面行为
- Git 变更用行号着色显示。
- 窄窗口自动关闭 `relativenumber`。
- `colorcolumn=80` 为参考线。

---
注：LSP 通过 `mason-lspconfig` 自动管理，首次打开某些文件类型时可能会短暂安装。
