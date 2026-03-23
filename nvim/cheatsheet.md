# Neovim Config Cheatsheet (Minimalist & Plugin-Light)

这是一个基于 Neovim 内置功能与 `mini.nvim` 生态构建的高性能配置。
遵循 **80 字符行宽**、**无图标 (No Icons)** 且 **无 Snippets** 的设计原则。

## 1. 核心导航 (Navigation)
- `j` / `k` : 智能折行跳转（不带 count 时为 `gj`/`gk`）。
- `Ctrl + d/u` : 半屏翻页并居中。
- `n` / `N` : 搜索结果跳转并居中。
- `<leader>c` : 清除搜索高亮。
- `<leader>bn/bp` : 切换上一个/下一个 Buffer。
- `<leader>bd` : 安全删除当前 Buffer (`mini.bufremove`)。

## 2. 文件浏览 (mini.files)
- `<leader>e` : 开关文件浏览器。
- `j` / `k` : 移动光标。
- `h` / `l` : 向左回到父目录 / 向右进入目录或打开文件。
- `Enter` : 确认选择。
- `g.` : 切换隐藏文件显示。
- **编辑模式** : 直接修改文件名或另起一行输入名称，保存 (`:w`) 即可同步更改。

## 3. 搜索与模糊查找 (fzf-lua)
- `<leader>ff` : 查找文件。
- `<leader>fg` : 全局搜索 (Live Grep)。
- `<leader>fb` : 列出当前打开的 Buffer。
- `<leader>fo` : 最近打开的文件 (Oldfiles)。
- `<leader>fx` : 列出当前文档的诊断信息。
- `<leader>fz` : 在当前文件中进行模糊搜索。

## 4. LSP 与代码开发
- `gd` : 跳转到定义。
- `gr` : 查看所有引用。
- `K` : 显示悬浮文档 (Hover)。
- `<leader>la` : 执行代码操作 (Code Action)。
- `<leader>lr` : 重命名 (Rename)。
- `<leader>ls` : 列出文档符号 (Symbols)。
- `<leader>bf` : 格式化当前 Buffer (`conform.nvim`)。
- `[d` / `]d` : 跳转到上一个/下一个诊断错误。
- `<leader>ld` : 打开当前行的诊断悬浮窗。

## 5. Git 集成 (mini.diff)
- `]h` / `[h` : 跳转到下一个/上一个修改块 (Hunk)。
- `<leader>hp` : 切换显示当前 Hunk 的差异 Overlay。
- `<leader>gs` : 查看 Git 状态 (`fzf-lua`)。

## 6. 文本编辑技巧 (mini.modules)
- **Surround (`sa/sd/sr`)**:
    - `saiw"` : 为当前单词加上双引号。
    - `sd"` : 删除周围的双引号。
    - `sr"(` : 将双引号替换为小括号。
- **Operators**:
    - `gx` : 交换文本位置。
    - `gs` : 对选中行进行排序。
    - `gm` : 复制/倍增选中文本。
- **Indent Scope**: 侧边会有 `|` 线条提示当前的缩进范围。

## 7. 补全 (blink.cmp)
- 输入字符时自动触发。
- `Tab` : 接受建议。
- `Ctrl + n/p` : 在补全列表中上下移动。

---
*注：本配置使用 `mason-lspconfig` 自动管理语言服务器，首次打开特定类型文件时可能会有简短的安装过程。*
