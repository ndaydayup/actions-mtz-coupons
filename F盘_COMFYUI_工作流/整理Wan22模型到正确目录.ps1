#Requires -Version 5.1
<#
.SYNOPSIS
  扫描 F:\COMFYUI（或你指定的根目录）里已下载的 Wan2.2 / 相关文件，
  移动到 ComfyUI 正确的 models 子目录，方便直接测工作流。

.用法
  1) 右键「使用 PowerShell 运行」；或
  2) 在 PowerShell 里：
       cd F:\COMFYUI
       powershell -ExecutionPolicy Bypass -File ".\整理Wan22模型到正确目录.ps1"
       # 先预览，确认无误后再真正移动：
       powershell -ExecutionPolicy Bypass -File ".\整理Wan22模型到正确目录.ps1" -Apply

.说明
  默认只预览（DryRun）。加 -Apply 才会真正 Move-Item。
  已在目标位置的同名文件会跳过，不会覆盖。
#>

param(
  [string]$Root = "F:\COMFYUI",
  [switch]$Apply
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $Root)) {
  Write-Host "找不到目录: $Root" -ForegroundColor Red
  Write-Host "请把 -Root 改成你的 ComfyUI 根目录，例如: -Root 'D:\AI\ComfyUI'"
  exit 1
}

# 目标目录
$dirs = @{
  diffusion = Join-Path $Root "models\diffusion_models"
  textenc   = Join-Path $Root "models\text_encoders"
  vae       = Join-Path $Root "models\vae"
  loras     = Join-Path $Root "models\loras"
  clipvis   = Join-Path $Root "models\clip_vision"
}

foreach ($d in $dirs.Values) {
  if (-not (Test-Path -LiteralPath $d)) {
    New-Item -ItemType Directory -Path $d -Force | Out-Null
    Write-Host "已创建: $d"
  }
}

# 文件名 -> 目标类型（按完整文件名小写匹配；也支持模糊包含）
$exact = @{
  # —— Wan2.2 5B ——
  "wan2.2_ti2v_5b_fp16.safetensors"                        = "diffusion"
  "wan2.2_vae.safetensors"                                 = "vae"

  # —— Wan2.2 14B T2V ——
  "wan2.2_t2v_high_noise_14b_fp8_scaled.safetensors"       = "diffusion"
  "wan2.2_t2v_low_noise_14b_fp8_scaled.safetensors"        = "diffusion"
  "wan2.2_t2v_high_noise_14b_fp16.safetensors"             = "diffusion"
  "wan2.2_t2v_low_noise_14b_fp16.safetensors"              = "diffusion"

  # —— Wan2.2 14B I2V ——
  "wan2.2_i2v_high_noise_14b_fp8_scaled.safetensors"       = "diffusion"
  "wan2.2_i2v_low_noise_14b_fp8_scaled.safetensors"        = "diffusion"
  "wan2.2_i2v_high_noise_14b_fp16.safetensors"             = "diffusion"
  "wan2.2_i2v_low_noise_14b_fp16.safetensors"              = "diffusion"

  # —— 文本编码器 / VAE（Wan 共用）——
  "umt5_xxl_fp8_e4m3fn_scaled.safetensors"                 = "textenc"
  "umt5_xxl_fp16.safetensors"                              = "textenc"
  "wan_2.1_vae.safetensors"                                = "vae"
  "wan2.1_vae.safetensors"                                 = "vae"

  # —— 可选加速 LoRA ——
  "wan2.2_t2v_lightx2v_4steps_lora_v1.1_high_noise.safetensors" = "loras"
  "wan2.2_t2v_lightx2v_4steps_lora_v1.1_low_noise.safetensors"  = "loras"
  "wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors"   = "loras"
  "wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors"    = "loras"

  # —— MiniMax H3（若同目录也下了）——
  "minimax_h3_fl2va_pruned_int8_convrot.safetensors"       = "diffusion"
  "minimax_h3_ref2va_pruned_int8_convrot.safetensors"      = "diffusion"
  "qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors"           = "textenc"
  "minimax_h3_video_vae_int8_convrot.safetensors"          = "vae"
  "minimax_h3_video_vae_fp16.safetensors"                  = "vae"
  "minimax_h3_audio_vae_fp32.safetensors"                  = "vae"
  "minimax_h3_fl2v_turbo_8step_v1.0_comfyui_bf16.safetensors" = "loras"
  "minimax_h3_ref2v_turbo_4step_v0.1_comfyui_bf16.safetensors" = "loras"
}

function Resolve-Kind([string]$name) {
  $key = $name.ToLowerInvariant()
  if ($exact.ContainsKey($key)) { return $exact[$key] }

  # 模糊规则（下载名略有出入时）
  if ($key -match 'wan2\.2_.*\.(safetensors|gguf)$' -and $key -match '(t2v|i2v|ti2v|high_noise|low_noise)') {
    return "diffusion"
  }
  if ($key -eq 'wan2.2_vae.safetensors' -or $key -match '^wan_?2\.[12]_vae') { return "vae" }
  if ($key -match '^umt5_xxl') { return "textenc" }
  if ($key -match 'wan2\.2_.*lora' -or $key -match 'lightx2v') { return "loras" }
  if ($key -match '^minimax_h3_.*(fl2va|ref2va)') { return "diffusion" }
  if ($key -match '^minimax_h3_.*vae') { return "vae" }
  if ($key -match '^qwen3vl_32b_minimax') { return "textenc" }
  if ($key -match 'minimax_h3_.*turbo') { return "loras" }
  return $null
}

# 跳过已经在正确 models 子目录里的文件；仍扫描下载缓存等位置
$skipRoots = @(
  (Join-Path $Root "models\diffusion_models"),
  (Join-Path $Root "models\text_encoders"),
  (Join-Path $Root "models\vae"),
  (Join-Path $Root "models\loras"),
  (Join-Path $Root "models\clip_vision")
) | ForEach-Object { (Resolve-Path $_ -ErrorAction SilentlyContinue).Path }

Write-Host ""
Write-Host "根目录: $Root"
Write-Host ("模式: " + ($(if ($Apply) { "真正移动 (-Apply)" } else { "仅预览（加 -Apply 才会移动）" })))
Write-Host "正在扫描 *.safetensors / *.gguf ..."
Write-Host ""

$files = Get-ChildItem -LiteralPath $Root -Recurse -File -Include *.safetensors,*.gguf -ErrorAction SilentlyContinue
$plan = @()
$unknown = @()

foreach ($f in $files) {
  $kind = Resolve-Kind $f.Name
  if (-not $kind) {
    # 只记录看起来像 Wan/MiniMax 的未知文件，避免刷屏
    if ($f.Name -match '(?i)wan|umt5|minimax_h3|qwen3vl_32b_minimax') {
      $unknown += $f
    }
    continue
  }

  $destDir = $dirs[$kind]
  $destPath = Join-Path $destDir $f.Name

  # 已在正确目录
  if ($f.FullName -eq $destPath) { continue }

  # 已在任一标准 models 子目录且文件名正确 → 若目标不同才移
  $alreadyOk = $false
  foreach ($sr in $skipRoots) {
    if ($sr -and $f.DirectoryName -eq $sr -and $f.Name -eq [IO.Path]::GetFileName($destPath)) {
      # 在正确类型目录里就不挪
      if ($f.DirectoryName -eq $destDir) { $alreadyOk = $true }
    }
  }
  if ($alreadyOk) { continue }

  $plan += [pscustomobject]@{
    Kind = $kind
    From = $f.FullName
    To   = $destPath
    SizeGB = [math]::Round($f.Length / 1GB, 2)
  }
}

if ($plan.Count -eq 0) {
  Write-Host "没有发现需要移动的匹配文件。" -ForegroundColor Yellow
  Write-Host "若模型在别的盘，请: -Root '你的路径'"
} else {
  Write-Host ("计划处理 {0} 个文件:" -f $plan.Count) -ForegroundColor Cyan
  $plan | Format-Table Kind, SizeGB, From, To -AutoSize | Out-String | Write-Host

  if ($Apply) {
    foreach ($p in $plan) {
      if (Test-Path -LiteralPath $p.To) {
        Write-Host ("跳过（目标已存在）: {0}" -f $p.To) -ForegroundColor DarkYellow
        continue
      }
      Move-Item -LiteralPath $p.From -Destination $p.To
      Write-Host ("已移动 -> {0}" -f $p.To) -ForegroundColor Green
    }
  } else {
    Write-Host "以上为预览。确认无误后执行:" -ForegroundColor Yellow
    Write-Host ("  powershell -ExecutionPolicy Bypass -File `"{0}`" -Root `"{1}`" -Apply" -f $PSCommandPath, $Root)
  }
}

if ($unknown.Count -gt 0) {
  Write-Host ""
  Write-Host "以下文件名未精确匹配（请把列表发我，我帮你补规则）:" -ForegroundColor Magenta
  $unknown | ForEach-Object { Write-Host ("  - {0}" -f $_.FullName) }
}

# 测工作流前的最低清单
Write-Host ""
Write-Host "======== 测工作流前自检 ========" -ForegroundColor Cyan
$checks = @(
  @{ Path = $dirs.diffusion; Need = @("wan2.2_ti2v_5B_fp16.safetensors"); Tip = "5B 文生/图生主模型" },
  @{ Path = $dirs.vae;       Need = @("wan2.2_vae.safetensors"); Tip = "5B 专用 VAE（不要用错成 2.1）" },
  @{ Path = $dirs.textenc;   Need = @("umt5_xxl_fp8_e4m3fn_scaled.safetensors"); Tip = "文本编码器" }
)
foreach ($c in $checks) {
  $found = $false
  foreach ($n in $c.Need) {
    if (Test-Path (Join-Path $c.Path $n)) { $found = $true; break }
    # 大小写不敏感再扫一遍
    $hit = Get-ChildItem -LiteralPath $c.Path -Filter $n -ErrorAction SilentlyContinue
    if ($hit) { $found = $true; break }
  }
  if ($found) {
    Write-Host ("[OK] {0}" -f $c.Tip) -ForegroundColor Green
  } else {
    Write-Host ("[缺] {0}  -> 需要: {1}" -f $c.Tip, ($c.Need -join " / ")) -ForegroundColor Red
  }
}

Write-Host ""
Write-Host "工作流路径（拷好后）:"
Write-Host ("  {0}" -f (Join-Path $Root "工作流\Wan2.2\5B\治愈系\01_文生视频.json"))
Write-Host "拖进 ComfyUI 即可测试。"
