# microsoft/homebrew-sparrow-engine — Homebrew tap for the sparrow-engine CLI

Tap for the [sparrow-engine](https://github.com/microsoft/Pytorch-Wildlife) ML inference CLI — single-binary install of the camera-trap species detection + audio classification engine.

## Install

```bash
brew tap microsoft/sparrow-engine
brew install sparrow-engine
spe --version
spe device     # active inference device, e.g. {"device":"cpu"}
```

See the [user manual](https://github.com/microsoft/Pytorch-Wildlife/blob/sparrow-engine-dev/docs/user-manual.md) for full CLI usage.

## What this provides

A single brew-managed `spe` binary for macOS arm64 + brew-Linux x86_64, with bundled `libonnxruntime` inside the keg — no separate `pip install onnxruntime` required. The tarball matrix originates at the [sparrow-engine GitHub Releases](https://github.com/microsoft/Pytorch-Wildlife/releases) (per RP-4 / Path B); this tap is a thin distribution surface that pins SHA256 checksums to those release assets.

## Formula source of truth

The canonical formula lives in the source repo at [`installer/homebrew/sparrow-engine.rb`](https://github.com/microsoft/Pytorch-Wildlife/blob/sparrow-engine-dev/installer/homebrew/sparrow-engine.rb). Each release bump fetches `.sha256` sidecars from the GH Release, substitutes them in, and pushes the updated formula here. The operator runbook lives at [`installer/homebrew/README.md`](https://github.com/microsoft/Pytorch-Wildlife/blob/sparrow-engine-dev/installer/homebrew/README.md) upstream.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit [Contributor License Agreements](https://cla.opensource.microsoft.com).

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft
trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
