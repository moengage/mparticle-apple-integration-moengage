# Contributing

## Repo strucure

### Examples

Contains separate sub-folders for each sample app available for testing. It also contains [tuist](https://github.com/tuist/tuist) configuration files, XCode workspace and Podfile.

### Sources

Contains source code and resources for each module contained in separate sub-folders.

- **mParticle-MoEngage**: Contains mParticle API implementation for MoEngage.
- **mParticle-MoEngageObjC**: Contains mParticle kit registration code specific to objC runtime.

### Tests

Contains tests.

### Utilities

Contains helper scripts for build, testing and release automation, most scripts are written in ruby.

## Running sample app

After cloning the repo/switching branch to run the sample app, execute following command at the repository root:

```sh
rake setup
```

This command will install [tuist](https://github.com/tuist/tuist) if not installed already and setup the workspace to open with XCode.

Post the above command completion, workspace file in [Examples](#examples folder) can be opened to run sample app.

> [!NOTE]
> You might have to give [tuist](https://github.com/tuist/tuist) permission to run on your machine.

> [!TIP]
> Run `rake -D setup` to know supported environment variables and configuration options. See [additional tasks](#additional-tasks) section for more detailed setup guide.

## Additional tasks

Supported additional tasks and detailed documentation can be found by running the following command at repository root:

```sh
rake -D
```
