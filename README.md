# typst-cv

Minimal Docker build environment for compiling YAML-driven [Typst](https://typst.app/) CVs and static HTML in GitLab CI/CD. Used by [Sieboldianus/cv](https://github.com/Sieboldianus/cv).

## Included

- **Base:** `python:3.12-slim-bookworm`
- **Typst:** `0.15.1` (pinned release binary)
- **Fonts:** `EB Garamond` OTF family ([octaviopardo/EBGaramond12](https://github.com/octaviopardo/EBGaramond12), with Medium, SemiBold, Bold, and Italics)
- **Python:** `pyyaml`, `jinja2`, `jsonschema`
- **Deploy / VCS:** `git`, `openssh-client`, `rsync`

## Build Locally

```bash
docker build -t typst-cv .
```

Versioning is read from `.version` and pushed to the GitLab Container Registry via `.gitlab-ci.yml`.