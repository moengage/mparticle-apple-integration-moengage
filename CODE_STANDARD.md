# mParticle-MoEngage — Code Standards

Conventions for the **mParticle-MoEngage** integration. This is a thin wrapper that bridges the
[mParticle Apple SDK](https://github.com/mParticle/mparticle-apple-sdk) to the MoEngage native iOS
SDK, so it follows the MoEngage native SDK's conventions where they apply, and mParticle's kit
conventions at the integration boundary. Where a rule conflicts with habit, this document wins.

## Table of Contents

1. [Grammar and Spelling](#1-grammar-and-spelling)
2. [Naming](#2-naming)
3. [Module Split](#3-module-split)
4. [API Visibility and Obj-C Interop](#4-api-visibility-and-obj-c-interop)
5. [Optionals and Safety](#5-optionals-and-safety)
6. [Dependencies](#6-dependencies)
7. [Testing](#7-testing)
8. [Formatting](#8-formatting)

---

## 1. Grammar and Spelling

- Spell every word correctly; a misspelled public name is a permanent, breaking-to-fix scar. Run a
  spell-check pass before a PR.
- Use **US spelling** (`initialization`, `behavior`, `color`).
- Boolean names read as a predicate: `is`, `has`, `can`, `should`, `was`.
- Follow Swift's initialism casing — acronyms are uniformly cased (`SDK`, `URL`, `ID`, `JSON`), not
  `Sdk`/`Json`.

## 2. Naming

- **Public MoEngage-facing types use the `MoEngage` prefix** and match the native SDK's style
  (e.g. `MoEngageConfigurator`). File names match the primary type.
- At the mParticle boundary, follow mParticle's kit conventions rather than renaming them.
- Methods are `camelCase` verb phrases; prefer clear call sites per the
  [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/). Do not
  prefix simple accessors with `get`.
- Group members with `// MARK: -` sections.

## 3. Module Split

Keep the two-module boundary clean:

- **`mParticle-MoEngage`** — the Swift API implementation for MoEngage.
- **`mParticle-MoEngageObjC`** — mParticle kit-registration code specific to the Obj-C runtime.

Runtime kit-registration glue belongs in `mParticle-MoEngageObjC`; keep the Swift API implementation
in `mParticle-MoEngage`. Don't leak Obj-C-runtime-only concerns into the Swift module.

## 4. API Visibility and Obj-C Interop

- Give every declaration an explicit access level; prefer the **most restrictive** that works. Keep
  the public surface as small as the mParticle kit contract requires.
- Use `@objc` / `@objc(...)` where the type or member must be discoverable from the Obj-C runtime
  (kit registration), and only there.
- Use `public internal(set)` for properties that integrators read but only the integration mutates.

## 5. Optionals and Safety

- Prefer `guard let … else { return }` early exits over nested `if let`.
- Prefer optional chaining (`?.`) and nil-coalescing (`??`) over `x != nil` checks.
- **Do not force-unwrap (`!`) or `as!`** in new code; if unavoidable, comment why it cannot be nil.
- Never let an error from the integration crash the host app — handle failures with `do`/`try`/`catch`
  and fail safe.

## 6. Dependencies

- Depend **only** on the mParticle Apple SDK and the MoEngage native iOS SDK. Do not add unrelated
  third-party dependencies.
- The compatible native SDK range is declared in [package.json](package.json) (`sdkVerMin` /
  `sdkVerMax`) and mirrored in [Package.swift](Package.swift) and
  [mParticle-MoEngage.podspec](mParticle-MoEngage.podspec); keep all three in sync when bumping.

## 7. Testing

- Tests live under [Tests/](Tests/) and use **Swift Testing** (`import Testing`, `@Suite`, `@Test`,
  `#expect`, `#require`) — do not add new `XCTestCase` subclasses.
- `@Test` display strings describe the scenario in plain English; function names are `camelCase` and
  read as `subjectConditionExpectation`.
- Run the suites with `rake test:spm` and `rake test:pods`, and verify against both distribution modes
  (SPM and CocoaPods) per [CONTRIBUTING.md](CONTRIBUTING.md#building-and-testing).

## 8. Formatting

- There is no SwiftLint config in this repo — follow the existing style: `MoEngage`-prefixed public
  types, `// MARK: -` sections, and consistent indentation matching the surrounding code.
- Add a file header to new files; prefer the standard MoEngage copyright header:

  ```swift
  //
  //  <FileName>.swift
  //  mParticle-MoEngage
  //
  //  Created by <Author> on <dd/MM/yy>.
  //  Copyright © <Year> MoEngage. All rights reserved.
  //
  ```

- Comment only when the **why** isn't obvious from the code (an mParticle kit quirk, an ordering
  constraint). Don't restate what the code does or reference Jira tickets in comments.
