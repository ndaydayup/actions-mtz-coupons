# 治愈系视频 · ComfyUI 工作流包

> **先看**：`【先看】文件放哪里.md`  
> 文件**不会**自动出现在 `F:\COMFYUI`，需从本仓库下载后拷贝到本机。

---

## 当前最优结论（你已下 MiniMax H3）

| 排名 | 方案 | 说明 |
|------|------|------|
| ★★★★★ | **MiniMax H3** | 原生立体声音频（雨声/钢琴一起出），指令更强，成片更完整 |
| ★★★★ | Wan 2.2 14B | 画质强，但**不带原生配乐/音效** |
| ★★★ | Wan 2.2 5B | 显存友好试错用 |

**有 H3 就优先跑 `05 / 06 / 07`。**

要求：**ComfyUI ≥ 0.30.0**

官方指南：https://docs.comfy.org/zh/tutorials/video/minimax/minimax-h3

---

## 工作流列表

### A. MiniMax H3（推荐）

| 文件 | 用途 | 主模型 |
|------|------|--------|
| `workflows/05_治愈系_文生视频_MiniMax_H3.json` | 文生视频+音频 | `fl2va` |
| `workflows/06_治愈系_图生视频_MiniMax_H3.json` | 图生视频+音频 | `fl2va` |
| `workflows/07_治愈系_参考生视频_MiniMax_H3.json` | 参考生视频 | `ref2va`（与 fl2va **不能混用**） |

预置：治愈系提示词、`turbo` 关闭（质量优先）、成片约 `0.98 MP / 16:9`。

### B. Wan 2.2（备选 / 显存不够时）

| 文件 | 用途 | 显存 |
|------|------|------|
| `01_治愈系_文生视频_Wan22_5B.json` | 文生 | ≥8GB |
| `02_治愈系_图生视频_Wan22_5B.json` | 图生 | ≥8GB |
| `03_治愈系_文生视频_Wan22_14B.json` | 高画质文生 | ≥16GB |
| `04_治愈系_图生视频_Wan22_14B.json` | 高画质图生 | ≥16GB |

---

## MiniMax H3 模型放哪里

仓库：https://huggingface.co/Comfy-Org/MiniMax-H3

### 文生 / 图生（FL2VA）最少需要

| 文件 | 目录 |
|------|------|
| `minimax_h3_fl2va_pruned_int8_convrot.safetensors` | `ComfyUI/models/diffusion_models/` |
| `qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors` | `ComfyUI/models/text_encoders/` |
| `minimax_h3_video_vae_int8_convrot.safetensors` | `ComfyUI/models/vae/` |
| `minimax_h3_audio_vae_fp32.safetensors` | `ComfyUI/models/vae/` |
| `minimax_h3_fl2v_turbo_8step_v1.0_comfyui_bf16.safetensors`（可选加速） | `ComfyUI/models/loras/` |

### 参考生视频（R2V）额外

| 文件 | 目录 |
|------|------|
| `minimax_h3_ref2va_pruned_int8_convrot.safetensors` | `diffusion_models/` |
| `minimax_h3_ref2v_turbo_4step_v0.1_comfyui_bf16.safetensors`（可选） | `loras/` |

> 你如果只下了其中一个名字接近的权重，把**实际文件名**发我，我帮你对一下该选哪条工作流。

### 分辨率注意

- 成片：`0.98` Megapixels + 16:9（约 1344×768）  
- **不要**选 `1.0` MP（会变成 1376×768，超限）

---

## 本机推荐目录

```text
F:\COMFYUI\user\default\workflows\治愈系视频\
  ├─ 05_治愈系_文生视频_MiniMax_H3.json
  ├─ 06_治愈系_图生视频_MiniMax_H3.json
  ├─ 07_治愈系_参考生视频_MiniMax_H3.json
  └─ （可选）01–04 Wan 备选
```

或继续放进：`F:\COMFYUI\入门工作流\治愈系视频\`

---

## 缺什么请回我

填 `缺什么-对照清单.md`，尤其是：

1. 显卡型号 / 显存  
2. 你下载的 H3 文件**完整文件名列表**  
3. ComfyUI 版本是否 ≥ 0.30.0  
4. 打开 `05` 是否还有红节点  

有文件名我就能判断：该用 fl2va 还是 ref2va、缺没缺 audio VAE / 文本编码器。
