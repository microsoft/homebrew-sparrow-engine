class SparrowEngine < Formula
  desc "Camera-trap ML inference engine (sparrow-engine CLI binary)"
  homepage "https://github.com/microsoft/Pytorch-Wildlife"
  license "MIT"
  version "0.1.10"

  # RP-4 (2026-05-26): the formula points at the GH Release tarballs produced
  # by .github/workflows/release.yml § build-cli-* and attached by
  # publish-cli-release-assets. Layout is:
  #   sparrow-engine-cpu-<ver>-<platform>/
  #   ├── bin/spe(.exe)
  #   ├── lib/libonnxruntime.{so.X.Y.Z,dylib}
  #   ├── README.md
  #   └── VERSION
  #
  # SHA256 placeholders MUST be replaced before tap publish — the cut-release
  # script fetches the .sha256 sidecars from the GH Release and substitutes
  # them in. Until then, this formula will not install (brew validates the
  # checksum before unpacking).

  on_macos do
    on_arm do
      url "https://github.com/microsoft/Pytorch-Wildlife/releases/download/v#{version}/sparrow-engine-cpu-#{version}-macos-aarch64.tar.gz"
      sha256 "fe645e8e990f4342c63423544b0ddd96fcff6bc9a3adc6de6c5c908384ae50f3"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/microsoft/Pytorch-Wildlife/releases/download/v#{version}/sparrow-engine-cpu-#{version}-linux-x86_64.tar.gz"
      sha256 "0439c2d2ccc4f3a80e8ed7c4f2789bf775d5a995d21213f56826ead4acf892ce"
    end
  end

  def install
    # The tarball roots at sparrow-engine-cpu-<ver>-<platform>/ — brew strips
    # one level of tarball root automatically, so Dir["*"] sees bin/, lib/,
    # README.md, VERSION directly.
    #
    # We install into libexec/ (not bin/ + lib/ directly under prefix) and
    # symlink bin/spe to libexec/bin/spe. Rationale: the in-binary
    # ort_resolver::init_ort_env() canonicalises current_exe() and walks one
    # dir up from bin/ to find lib/. With libexec/{bin,lib} the resolver
    # sees <libexec_dir>/lib/libonnxruntime.<ver> and dlopens it correctly.
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/spe"
  end

  test do
    # Validates the resolver: `spe --version` exercises clap parsing AND the
    # in-binary ort_resolver path. If the resolver didn't find lib/, the
    # subsequent device subcommand would fail at ORT init — keeping the test
    # tight to --version so it's fast and dep-free.
    assert_match version.to_s, shell_output("#{bin}/spe --version")
  end
end
