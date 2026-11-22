@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo.
echo === 步骤1: 预览将要移动的 Wan2.2 模型 ===
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0整理Wan22模型到正确目录.ps1" -Root "F:\COMFYUI"
echo.
echo === 若预览无误，按任意键开始真正移动；否则 Ctrl+C 取消 ===
pause
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0整理Wan22模型到正确目录.ps1" -Root "F:\COMFYUI" -Apply
echo.
echo === 同步工作流目录到 F:\COMFYUI\工作流 ===
if exist "%~dp0工作流" (
  xcopy "%~dp0工作流" "F:\COMFYUI\工作流\" /E /I /Y
  echo 工作流已同步。
) else (
  echo 未找到旁边的 工作流 文件夹，请先把整个 F盘_COMFYUI_工作流 拷到任意位置再运行本 bat。
)
echo.
pause
