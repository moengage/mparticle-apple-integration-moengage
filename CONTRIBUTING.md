# Contributing Guidelines

Thank you for your interest in contributing to the **mParticle-MoEngage** integration! This is the
MoEngage kit for the [mParticle Apple SDK](https://github.com/mParticle/mparticle-apple-sdk). It
wraps the MoEngage native iOS SDK so mParticle customers can forward data to MoEngage.

## Table of Contents

- [Branching Strategy](#branching-strategy)
- [Repo Structure](#repo-structure)
- [Running the Sample App](#running-the-sample-app)
- [Building and Testing](#building-and-testing)
- [General Guidelines](#general-guidelines)
- [Changelog](#changelog)
  - [Header](#header)
- [Raising a Pull Request](#raising-a-pull-request)

## Branching Strategy

Create your branch from an up-to-date `development` branch. Only if your change depends on another
in-flight change should you branch off that branch instead.

Branch names follow the standard MoEngage
[branching guidelines](https://moengagetrial.atlassian.net/wiki/spaces/EN/pages/5919277067/Branching+StrategyReleaseProcess):
a prefix, the Jira ticket id, then a short readable description separated by an underscore.

Example - `feature/MOEN-1234_mparticle-kit-registration`

All pull requests are raised against `development`.

## Repo Structure

### Examples

Contains a sub-folder per sample app for testing, along with the [Tuist](https://github.com/tuist/tuist)
configuration files, the Xcode workspace, and the Podfile.

### Sources

Source code and resources for each module, in separate sub-folders:

- **mParticle-MoEngage** — the mParticle API implementation for MoEngage.
- **mParticle-MoEngageObjC** — mParticle kit registration code specific to the Obj-C runtime.

### Tests

Unit tests for the integration.

### Utilities

Helper scripts for build, testing, and release automation (mostly Ruby).

The integration ships both as a Swift package ([Package.swift](Package.swift)) and a CocoaPod
([mParticle-MoEngage.podspec](mParticle-MoEngage.podspec)); prebuilt binaries live under
[XCFramework/](XCFramework/).

## Running the Sample App

After cloning the repo (or switching branch), run the following at the repository root:

```sh
rake setup
```

This installs [Tuist](https://github.com/tuist/tuist) if needed and generates the workspace. Open the
workspace under [Examples/](Examples/) to run the sample app.

> [!NOTE]
> You might have to grant [Tuist](https://github.com/tuist/tuist) permission to run on your machine.

> [!TIP]
> Run `rake -D setup` for supported environment variables and configuration options, and `rake -D`
> for all available tasks.

## Building and Testing

- Build the XCFrameworks with `rake xcframework`.
- Run the SPM tests with `rake test:spm`.
- Run the CocoaPods tests with `rake test:pods`.

Verify your change against both integration modes (SPM and CocoaPods) since the integration is
distributed through both.

## General Guidelines

- **Keep dependencies minimal.** This integration should depend only on the mParticle Apple SDK and
  the MoEngage native iOS SDK. Do not add unrelated third-party dependencies.
- **Respect the two-module split.** Keep Obj-C runtime kit-registration code in
  `mParticle-MoEngageObjC` and the API implementation in `mParticle-MoEngage`.
- **Match the native SDK's conventions.** Types and public APIs use the `MoEngage` prefix, file names
  match the primary type, and code uses `// MARK: -` sections and consistent indentation. Use `@objc`
  where the API is exposed to the Obj-C runtime.
- **Deprecations:** if any public or client-facing API is deprecated or removed, mark it with
  `@available(*, deprecated, message: ...)` and note it in the [changelog](#changelog) with the new
  API equivalent.
- **Copyright header:** add the standard MoEngage copyright header to the top of every new file.
- **Guard against runtime failures.** Handle errors with `do`/`try`/`catch`; never let an exception
  from the integration crash the host app.

## Changelog

Every change adds an entry to the root [CHANGELOG.md](CHANGELOG.md). The version is tracked in
[package.json](package.json) (`frameworks[].version`).

> You do not need to fill in the release date or version manually — the release pipeline replaces the
> placeholder header with the actual date and version at release time (producing entries like
> `# 29-06-2026` / `## 2.7.0`). Your job is to add the entry bullet under the unreleased header.

### Header

Below is the header you need to add to the changelog file if it is not present already. If the header
is already present, do not add it again — just add your bullet under it.

```
# Release Date

## Release Version

```

Add your entry as a bullet under this header:

```
- <customer-readable description of the change>
- Updated MoEngage-iOS-SDK to <version>   # when the native SDK dependency is bumped
```

Most releases of this integration are native-SDK dependency bumps; describe any behavioural change to
the mParticle kit itself in its own bullet.

## Raising a Pull Request

Before raising a pull request, verify the following:

- The workspace generates cleanly (`rake setup`).
- The integration builds (`rake xcframework`).
- SPM tests pass (`rake test:spm`).
- CocoaPods tests pass (`rake test:pods`).
- [CHANGELOG.md](CHANGELOG.md) is updated under the unreleased header.

Raise the PR against `development` with a detailed description. The PR title should be
`MOEN-<TICKET_NUMBER> : <short description of the change>`.
