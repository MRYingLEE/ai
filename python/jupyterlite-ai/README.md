# jupyterlite-ai

[![Github Actions Status](https://github.com/jupyterlite/ai/workflows/Build/badge.svg)](https://github.com/jupyterlite/ai/actions/workflows/build.yml)
[![Documentation Status](https://readthedocs.org/projects/jupyterlite-ai/badge/?version=latest)](https://jupyterlite-ai.readthedocs.io/en/latest/?badge=latest)
[![lite-badge](https://jupyterlite.rtfd.io/en/latest/_static/badge.svg)](https://jupyterlite.github.io/ai/lab/index.html)

AI code completions and chat for JupyterLab, Notebook 7 and JupyterLite.

[a screencast showing the Jupyterlite AI extension in JupyterLite](https://github.com/user-attachments/assets/e33d7d84-53ca-4835-a034-b6757476c98b)

## Requirements

- JupyterLab >= 4.4.0 or Notebook >= 7.4.0

## Try it in your browser

You can try the extension in your browser using JupyterLite:

[![lite-badge](https://jupyterlite.rtfd.io/en/latest/_static/badge.svg)](https://jupyterlite.github.io/ai/lab/index.html)

## Install

To install the extension, execute:

```bash
pip install jupyterlite-ai
```

To install requirements (JupyterLab, JupyterLite and Notebook):

```bash
pip install jupyterlite-ai[jupyter]
```

## Local build and downstream publish

In the DataX workspace, use the canonical local scripts from the repo root:

```bash
cd ../..
./local_build.sh      # clean rebuild + publish into ../datax_now/built-in-wheels
./local_verify.sh     # verify downstream wheel pin freshness
```

`./build_wheel.sh` remains available at the repo root as a compatibility wrapper.

## Documentation

For detailed usage instructions, including how to configure AI providers, see the [documentation](https://jupyterlite-ai.readthedocs.io/).

## Uninstall

To remove the extension, execute:

```bash
pip uninstall jupyterlite-ai
```

## Contributing

See [CONTRIBUTING](../../CONTRIBUTING.md)
