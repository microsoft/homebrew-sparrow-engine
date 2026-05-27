class SparrowEngineGpu < Formula
  desc "Camera-trap ML inference engine — GPU (NVIDIA CUDA) CLI binary"
  homepage "https://github.com/microsoft/Pytorch-Wildlife"
  license "MIT"
  version "0.1.10"

  # Linux x86_64 only — NVIDIA CUDA does not exist on macOS, and Linux aarch64
  # has no matching tarball in the RP-4 release matrix. macOS users wanting
  # local inference install `sparrow-engine` (CPU formula) instead.
  on_linux do
    on_intel do
      url "https://github.com/microsoft/Pytorch-Wildlife/releases/download/v#{version}/sparrow-engine-gpu-#{version}-linux-x86_64.tar.gz"
      sha256 "51fe506b92d9e55e167cb4717a3444b5a305414225877ec6511d285aca1e26d0"
    end
  end

  def caveats
    <<~EOS
      sparrow-engine-gpu requires NVIDIA GPU drivers + CUDA 12 + cuDNN 9 + nvJPEG
      to be installed on the host. Brew cannot manage NVIDIA's binary blobs;
      install them via apt or pip first.

      Option A — system CUDA (Ubuntu / Debian, recommended for servers):
        sudo apt install nvidia-cuda-toolkit nvidia-cudnn

      Option B — Python sidecar wheels (no root, no system CUDA):
        pip install nvidia-cudnn-cu12 nvidia-cublas-cu12 nvidia-curand-cu12 \\
                    nvidia-cufft-cu12 nvidia-nvjpeg-cu12 nvidia-cuda-runtime-cu12
        export LD_LIBRARY_PATH="$(python -c 'import nvidia.cudnn, os; print(os.path.dirname(nvidia.cudnn.__file__) + \"/lib\")'):$LD_LIBRARY_PATH"

      Verify the host is ready:
        spe-gpu device       # expected: {"device":"cuda:0"}

      Full GPU install path:
        https://github.com/microsoft/Pytorch-Wildlife/blob/sparrow-engine-dev/docs/user-manual.md#25-gpu-install-sparrow-engine-gpu

      The tarball is ~256 MB — bundles libonnxruntime + ORT CUDA provider
      sidecars. NVIDIA-managed shared libraries (cuDNN / cuBLAS / nvJPEG /
      CUDA runtime) are host-managed per above; they are NOT bundled.
    EOS
  end

  def install
    # Same layout pattern as the CPU formula:
    # libexec/{bin,lib} + symlink bin/spe-gpu -> libexec/bin/spe-gpu.
    # The in-binary ort_resolver canonicalises current_exe() then walks one
    # dir up from bin/ to find lib/, so libexec/lib/libonnxruntime.so.X.Y.Z
    # is auto-discovered. GPU additionally prepends libexec/lib to
    # LD_LIBRARY_PATH at startup so the CUDA provider sidecars next to
    # libonnxruntime get picked up too.
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/spe-gpu"
  end

  test do
    # `--version` exercises clap + the resolver but not ORT init. ORT init
    # would require an NVIDIA GPU which the brew test sandbox cannot
    # guarantee. Operators verify device with `spe-gpu device` post-install.
    assert_match version.to_s, shell_output("#{bin}/spe-gpu --version")
  end
end
