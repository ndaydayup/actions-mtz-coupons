# F:\COMFYUI\工作流 · 按模型分类索引

## 模型已经下到 F:\COMFYUI，但目录乱？

1. 把整个 `F盘_COMFYUI_工作流` 文件夹拷到本机任意位置（或直接放进 `F:\COMFYUI\`）
2. **双击** `一键整理Wan22模型.bat`
3. 先看预览 → 回车后真正移动，并同步 `工作流\` 到 `F:\COMFYUI\工作流\`

也可只用 PowerShell：

```powershell
powershell -ExecutionPolicy Bypass -File "整理Wan22模型到正确目录.ps1" -Root "F:\COMFYUI"
powershell -ExecutionPolicy Bypass -File "整理Wan22模型到正确目录.ps1" -Root "F:\COMFYUI" -Apply
```

若脚本报「未精确匹配」，把打印的文件名列表发我，我补规则。

---

把本目录 **整个 `工作流` 文件夹** 拷到：

```text
F:\COMFYUI\工作流\
```

## 目录树

```text
F:\COMFYUI\工作流\
├── MiniMax-H3\              ← 当前最优（带原生音频）
│   └── 治愈系\
│       ├── 01_文生视频.json
│       ├── 02_图生视频.json
│       └── 03_参考生视频.json
├── Wan2.2\                  ← 备选 / 显存不够时
│   ├── 5B\治愈系\
│   │   ├── 01_文生视频.json
│   │   └── 02_图生视频.json
│   └── 14B\治愈系\
│       ├── 01_文生视频.json
│       └── 02_图生视频.json
├── 其他模型\                ← 预留扩展
└── _说明与提示词\
    ├── 治愈系提示词库.md
    └── 缺什么-对照清单.md
```

## 怎么用

1. 有 MiniMax H3 → 打开 `MiniMax-H3\治愈系\01_文生视频.json`
2. 只有 Wan / 显存小 → 打开 `Wan2.2\5B\治愈系\...`
3. 以后新模型：新建 `工作流\模型名\题材\xxx.json`，保持同一分类习惯

## 分类规则（建议你以后也按这个放）

| 层级 | 含义 | 例子 |
|------|------|------|
| 1 | 模型家族 | `MiniMax-H3` / `Wan2.2` / `Flux` |
| 2 | 型号或体量（可选） | `5B` / `14B` / `fl2va` |
| 3 | 题材或用途 | `治愈系` / `电商` / `人物口型` |
| 4 | 任务类型文件名 | `01_文生视频.json` |
