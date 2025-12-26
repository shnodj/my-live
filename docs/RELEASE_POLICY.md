# Release Policy

This document outlines the versioning, branching, and release process for the New-API Desktop project.

## Versioning Strategy

We follow **Semantic Versioning 2.0.0** (SemVer).
Format: `MAJOR.MINOR.PATCH` (e.g., `1.0.0`)

- **MAJOR**: Incompatible API changes or significant architectural shifts.
- **MINOR**: Backward-compatible functionality (new features).
- **PATCH**: Backward-compatible bug fixes.

### Prereleases
Prereleases are denoted by appending a hyphen and a series of dot separated identifiers.
- Example: `1.0.1-alpha.1`, `1.0.1-beta`

## Branching Strategy

We use a simplified **Trunk-Based Development** model.

- **`main`**: The primary branch. It should always be buildable.
- **Feature Branches**: Developers work on short-lived branches created from `main` (e.g., `feat/login-ui`, `fix/db-path`).
- **Release Tags**: Releases are defined by Git Tags on the `main` branch.

## Release Process

The release process is fully automated via GitHub Actions.

1.  **Preparation**:
    - Update the version number in `wails.json` (and `package.json` if applicable).
    - Update `CHANGELOG.md` (unless automated).
    - Commit these changes: `git commit -m "chore: bump version to x.y.z"`

2.  **Tagging**:
    - Create a git tag matching the version:
      ```bash
      git tag v1.0.0
      git push origin v1.0.0
      ```

3.  **Automation (CI/CD)**:
    - The GitHub Action `release.yml` triggers automatically on tags starting with `v*`.
    - It builds the application for Windows, Linux, and macOS.
    - It creates a GitHub Release draft.
    - It uploads the binaries (artifacts) to the release.

4.  **Publication**:
    - Review the Draft Release on GitHub.
    - Publish the release.

## CI/CD Pipeline

- **CI (`ci.yml`)**: Runs on every Push and Pull Request to `main`.
    - Lints Go and JavaScript code.
    - Runs Unit Tests.
    - verifies `wails build` (dry run).

- **CD (`release.yml`)**: Runs on `v*` tags.
    - Builds production binaries for all platforms.
    - Generates checksums.
    - Uploads assets to GitHub Releases.
