<h1 align="center">
  <br>
  <img src="./_images/logo.png" alt="" width="100">
  <br>
  Kortin does dotfiles
  <br>
</h1>

<p align="center">
  <strong>这是我个人的 macOS 开发环境统一配置管理和备份的仓库</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/PRs-welcome-%23DA70D6.svg" alt="PRs welcome!" />
  <img alt="License" src="https://img.shields.io/badge/license-MIT-%23DA70D6">
</p>


## What's inside
目录结构分别代表各个工具的配置
 - **git**: Git 相关的配置以及我常用的 alias
 - **zsh**: Zsh shell 的配置文件，包括插件、别名和自定义函数
 - **karabiner**: Karabiner-Elements 键盘自定义配置
 - **hammerspoon**: Hammerspoon 自动化脚本和配置
 - **iterm2**: iTerm2 终端模拟器的配置和脚本
 - **sketchybar**: macOS 状态栏自定义配置
 - **nvim**: Neovim 编辑器配置
 - **wezterm**: WezTerm 终端模拟器配置
 - **lazygit**: LazyGit 终端 Git 客户端配置
 - **yabai**: Yabai 窗口管理器配置
 - **vscode**: Visual Studio Code 编辑器配置
 - **tmux**: Tmux 终端复用器配置

### Git
- 使用 Delta 作为 diff 和 merge 工具
- 支持多种 git commit 类型的函数式别名（feat、fix、docs、style 等）
- 常用命令的简化别名（st、c、cm、co、br 等）
- 图形化日志显示（lg、ls 命令）
- 集成 LazyGit（ui 命令）
- 内置 gitignore 模板生成（ignore 命令）
- 适用于多工作区的配置

### zsh
- 基于 Oh My Zsh 框架
- 使用 wedisagree 主题
- 丰富的插件集合:
  - git, git-commit: Git 支持和提交助手
  - sudo: 双击 Esc 自动添加 sudo
  - eza: 现代化的 ls 替代品
  - fzf: 模糊文件查找
  - zsh-autosuggestions: 自动补全建议
  - zsh-syntax-highlighting: 语法高亮
  - zoxide: 智能目录跳转（z 命令）
  - copypath, copyfile: 复制文件路径和内容
- 自定义别名和函数
  - Python, Git, 文件操作的快捷命令
  - 格式化的文件列表 (ls 使用 eza)
  - 常用配置文件的快速编辑
  - 基于文件后缀的自动操作

### Sketchybar
由于我习惯使用 macOS 的多桌面进行开发，每个桌面会打开不同的应用，我需要知道我当前所处的桌面以及打开了哪些 App，macOS 原生系统显然不支持这项功能。

我使用 Sketchybar 最核心的需求就是补齐这项短板。同时，我也可以自定义一些实时的系统资源监控，以及任何我需要的功能。
<img src="./_images/sketchybar.png" />

Sketchybar 使用 Lua 配置，包含以下主要组件：
- 桌面空间指示器
- 系统资源监控（CPU、内存、电池）
- 当前正在运行的应用图标显示
- 音量和时间显示

### Yabai
Yabai 是一个高度可定制的窗口管理器，为 macOS 提供平铺窗口管理功能：
- 自动排列窗口以高效利用屏幕空间
- 快速键盘导航在窗口和桌面间切换
- 自定义窗口规则和布局
- 与 skhd 快捷键守护进程集成

### hammerspoon
目前只有两个脚本
- 连接上公司内网的 Wi-Fi 后自动静音 Mac;
- 双击 Alt 弹出一个快捷打开常用 App 的应用环
  <img src="./_images/hammerspoon-ring.gif" />

### Karabiner-Elements
键盘自定义配置包括：
- 修改键的绑定和行为
- 针对特定应用的自定义键盘映射
- 复杂修饰键组合

### iTerm2 & WezTerm
两种高级终端模拟器的配置：
- 配色方案和字体设置
- 热键窗口配置
- Shell 集成功能
- 窗口分割和布局设置

## How to use

### 自动配置
1. `cd` 到当前项目, 给于 `install.sh` 读写执行的权限
```shell
chmod +x ./install.sh
```
2. 将配置文件软链接到系统对应位置
```shell
./install.sh setup
```
3. 如需更新配置，可以运行
```shell
./install.sh backup
```

### 手动配置
复制你所需的配置部分到对应的配置文件即可

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
