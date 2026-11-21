# 治愈系视频生成 · ComfyUI 专属工作流包

基于 **Wan 2.2（通义万相）官方原生节点**定制，专为「治愈系」短视频：暖光、慢动作、低饱和、安静氛围。

> 说明：云端无法访问你本机的 `F:\COMFYUI\入门工作流`，因此无法直接扫描该目录。  
> 本包按 **2025–2026 当前最稳、最好用的开源视频方案（Wan2.2）** 重新搭好，拖进 ComfyUI 即可用。

---

## 选哪个工作流？

| 文件 | 场景 | 显存建议 | 建议优先级 |
|------|------|----------|------------|
| `workflows/01_治愈系_文生视频_Wan22_5B.json` | 纯文字出视频 | ≥8GB | ★★★★★ 先跑这个 |
| `workflows/02_治愈系_图生视频_Wan22_5B.json` | 一张静帧动起来 | ≥8GB | ★★★★★ |
| `workflows/03_治愈系_文生视频_Wan22_14B.json` | 高画质文生视频 | ≥16GB（24GB 更稳） | ★★★★ |
| `workflows/04_治愈系_图生视频_Wan22_14B.json` | 高画质图生视频 | ≥16GB（24GB 更稳） | ★★★★ |

**推荐路线：** 5B 定提示词与构图 → 满意后再换 14B 出成片。

---

## 安装步骤（5 分钟）

### 1. 更新 ComfyUI

必须用较新版本（含 Wan2.2 原生节点）。菜单里应能看到：

- `Wan22ImageToVideoLatent`
- `EmptyHunyuanLatentVideo` / `WanImageToVideo`
- `ModelSamplingSD3`

### 2. 下载模型到对应目录

模型统一仓库（推荐）：  
https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/tree/main/split_files

#### 公共依赖（5B / 14B 都要）

| 文件 | 放到 |
|------|------|
| `umt5_xxl_fp8_e4m3fn_scaled.safetensors` | `ComfyUI/models/text_encoders/` |

#### 只跑 5B（入门）

| 文件 | 放到 |
|------|------|
| `wan2.2_ti2v_5B_fp16.safetensors` | `ComfyUI/models/diffusion_models/` |
| `wan2.2_vae.safetensors` | `ComfyUI/models/vae/` |

#### 再跑 14B 文生视频

| 文件 | 放到 |
|------|------|
| `wan2.2_t2v_high_noise_14B_fp8_scaled.safetensors` | `ComfyUI/models/diffusion_models/` |
| `wan2.2_t2v_low_noise_14B_fp8_scaled.safetensors` | `ComfyUI/models/diffusion_models/` |
| `wan_2.1_vae.safetensors` | `ComfyUI/models/vae/` |

#### 再跑 14B 图生视频

| 文件 | 放到 |
|------|------|
| `wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors` | `ComfyUI/models/diffusion_models/` |
| `wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors` | `ComfyUI/models/diffusion_models/` |
| `wan_2.1_vae.safetensors` | `ComfyUI/models/vae/`（与上面共用） |

### 3. 加载工作流

把 `workflows/*.json` 拖进 ComfyUI 画布，或 `工作流 → 打开`。

### 4. 运行

改提示词（可选）→ `Ctrl + Enter`。

预置默认：`832×480`、`81` 帧（约 5 秒量级）。显存够再提到 `1280×704`、`121` 帧。

---

## 缺什么？对照这张表告诉我

把你机器情况按下面回我，我可以继续给你改「低显存 GGUF 版 / Lightning 4 步加速版 / 加插帧 / 加配乐轨」：

- [ ] 显卡型号与显存（例如 RTX 4060 8GB / 4090 24GB）
- [ ] ComfyUI 版本（桌面版 / 便携包 / 源码）
- [ ] 是否已有 Wan2.1 / Wan2.2 任意模型
- [ ] 目标：竖屏短视频（9:16）还是横屏（16:9）
- [ ] 要不要「图生视频」为主（有静帧素材）还是「文生视频」为主
- [ ] 是否需要配乐 / 口型 / 运镜控制（Fun Control）

### 常见缺口

| 缺口 | 影响 | 怎么补 |
|------|------|--------|
| 没更新 ComfyUI | 红节点 / 找不到 Wan22 节点 | 更新到最新 Nightly/正式版 |
| 缺 `umt5_xxl...` | 文本编码失败 | 下到 `text_encoders/` |
| 5B 却装了 `wan_2.1_vae` | 5B 出图异常 | 5B 必须用 `wan2.2_vae` |
| 14B 却只用了单个 unet | 质量差或报错 | 高噪+低噪两个都要 |
| 显存不够 | CUDA OOM | 先用 5B + 832×480；或换 GGUF |
| 想要更快 | 20–30 步偏慢 | 可加 LightX2V 4-steps LoRA（质量略降） |

---

## 治愈系提示词怎么写

公式：

```text
主体 + 场景 + 缓慢动作 + 光影/色彩 + 镜头运动 + 氛围词
```

示例与更多模板见：`prompts/治愈系提示词库.md`

**正向关键词：** 柔光、暖色、低饱和、浅景深、慢镜头、微风、光斑缓慢移动、安静、电影感  
**负向已预填：** 过饱和、剧烈运动、霓虹、恐怖、字幕、水印、闪烁等

---

## 和「入门工作流」目录的关系

若你本机 `F:\COMFYUI\入门工作流` 里已有 Wan / SVD / CogVideo / 可灵类 json：

1. 把本包整个文件夹拷到例如 `F:\COMFYUI\user\default\workflows\治愈系视频\`
2. 或把 4 个 json 直接拖进 ComfyUI
3. 若你愿意把该目录打成 zip 发上来 / 挂到网盘，我可以再帮你「扫一遍、标出哪些本来就能直接做治愈系视频」

---

## 参考

- ComfyUI 官方 Wan2.2 教程：https://docs.comfy.org/zh/tutorials/video/wan/wan2_2  
- 官方示例仓库：https://github.com/comfyanonymous/ComfyUI_examples/tree/master/wan22  
- 模型打包：https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged  
