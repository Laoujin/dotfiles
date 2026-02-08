---
stepsCompleted: [1, 2, 3, 4]
inputDocuments: []
session_topic: 'Dotfiles organization and cross-machine synchronization on Windows'
session_goals: 'Improve symlink/junction approach, solve program settings pain, find Windows config solution'
selected_approach: 'ai-recommended'
techniques_used: ['Morphological Analysis', 'Cross-Pollination', 'Constraint Mapping']
ideas_generated: 26
context_file: ''
session_active: false
workflow_completed: true
---

# Brainstorming Session Results

**Facilitator:** Wouter
**Date:** 2026-02-08

## Session Overview

**Topic:** Dotfiles organization and cross-machine synchronization across 2-4 Windows machines
**Goals:** Improve existing symlink/junction system, solve painful manual JSON/YAML program settings sync, establish a system for Windows-specific configuration

### Session Setup

- Git-based sync mechanism (already in use)
- Currently using junctions/symlinks for PowerShell, git, and other dotfiles
- Program/app settings sync is manual and tedious (JSON/YAML files)
- No current system for Windows-specific configuration
- 2-4 target machines
- Boxstarter handles machine bootstrapping (installs, fonts) before dotfiles run
- Deliberate sync philosophy: user commits manually when a change is worth keeping

## Technique Selection

**Approach:** AI-Recommended Techniques
**Analysis Context:** Dotfiles organization with focus on improving sync, solving program settings pain, and Windows config management

**Recommended Techniques:**

- **Morphological Analysis:** Systematically decompose dotfile management into parameters (config types, sync methods, automation levels) and explore all combinations to map the full solution space
- **Cross-Pollination:** Transfer solutions from Linux dotfile managers, infrastructure-as-code, package managers, and other domains to discover novel approaches for the Windows/git context
- **Constraint Mapping:** Identify all real vs. imagined constraints (Windows limitations, git compatibility, maintenance overhead) to filter ideas into the most practical and elegant solutions

**AI Rationale:** The challenge has three layers (improving known systems, solving specific pain points, exploring uncharted territory) requiring systematic deconstruction followed by creative cross-domain exploration and practical filtering

## Technique Execution Results

### Morphological Analysis

**Interactive Focus:** Decomposed dotfiles management into 4 key dimensions: what to sync, how to sync, automation level, and repo structure. Systematically explored each dimension with the user's real-world context.

**Key Dimensions Mapped:**

- **What to sync:** Shell configs, git config, package lists (working), program settings (painful), Windows config (missing)
- **How to sync:** Symlink/junction (current), copy-on-deploy (rejected - not bidirectional), filtered sync (promising), registry export (needed)
- **Automation level:** Bootstrap script (core), declarative manifest (for registry), idempotent runner (yes), drift detection (yes), dry-run (yes)
- **Repo structure:** Co-located app modules, engine/config separation

**Ideas Generated:** #1-#13

### Cross-Pollination

**Building on Previous:** Used the dimensional framework to evaluate solutions from Linux (GNU Stow, chezmoi, Nix), DevOps (Ansible, DSC), game save managers, VS Code plugin architecture, and Rails conventions.

**Key Cross-Domain Insights:**

- GNU Stow's philosophy directly maps to the co-located module pattern
- Chezmoi's diff/apply model inspired the WhatIf mode
- DSC's Get/Test/Set pattern provides idempotency without DSC's weight
- Game save manager databases inspired the known-apps config path library
- VS Code extension model inspired the plugin lifecycle hooks
- Rails convention-over-configuration inspired auto-discovery by folder name

**Ideas Generated:** #14-#23

### Constraint Mapping

**Constraints Tested:**

| Constraint | Verdict |
|---|---|
| Windows symlink permissions | Paper tiger - non-issue |
| Git + symlinks on Windows | Paper tiger - stable |
| App config file locking | Paper tiger - sync at specific times |
| Admin for registry | Soft wall - bootstrap runs elevated when needed |
| PowerShell 7+ required | Hard wall (acceptable) - simplifies code |
| No maintenance after setup | **Hard design constraint** - drives all decisions |
| Big-bang migration | Decision - clean break, no legacy compat |
| Denylist filter breakage on app updates | Accepted risk - noisy diffs = self-diagnosing |
| Developer audience (for now) | Scope constraint |

**Ideas Generated:** #24-#26

### Creative Facilitation Narrative

The session evolved from systematic decomposition (Morphological Analysis revealing the full solution space) through creative cross-domain raiding (Cross-Pollination connecting Linux tools, DevOps patterns, and plugin architectures) into practical filtering (Constraint Mapping proving most technical concerns were paper tigers). The user's strongest creative instinct was consistently pushing toward reducing manual work and making systems self-documenting. The "no maintenance after setup" constraint became the key design driver that shaped all solutions.

## Complete Idea Inventory

### Theme 1: Plugin Architecture & Repo Structure

- **#7 Co-located Manifests** [v1] - Manifest + config + gitattributes all live together in one app folder. Adding/removing a program = adding/removing one folder.
- **#13 Engine/Config Separation** [v1] - Split the repo into reusable engine (scripts, module runners) and personal config (settings, profiles). Makes the project open-sourceable.
- **#20 Lifecycle Hooks** [v2] - Each plugin gets standardized hooks: `pre-deploy.ps1`, `post-deploy.ps1`, `clean-filter.ps1`, `test.ps1`. Engine discovers and runs them automatically.
- **#21 Convention-over-Config Discovery** [v1] - Engine scans `config/Programs/*/manifest.json` automatically. Folder name = chocolatey/winget package name. Zero central registration.
- **#23 Engine/Config Sibling Repos** [v1] - `dotfiles-engine` (reusable) + `dotfiles-config` (personal). `bootstrap.ps1 -ConfigPath ..\dotfiles-config`.

### Theme 2: Smart Bootstrap & Drift Detection

- **#3 Pre-Deploy Backup Snapshots** [v1] - Before overwriting any config, snapshot current state. Git tracks your settings history; backups track "what was there before."
- **#5 Idempotent Bootstrap with Drift Report** [v1] - Every operation checks current state first. Triple-duty: initial setup, re-sync, and health check. Summary report at end.
- **#6 Dry-Run / WhatIf Mode** [v1] - `-WhatIf` flag shows what would change without touching anything. Pure drift detection on demand.
- **#12 Missing Config Detection** [v1] - Cross-reference package manifest against `config/Programs/` folders. Flags installed apps without dotfiles config.
- **#15 DSC-Inspired Get/Test/Set Pattern** [v2] - Lightweight PowerShell functions following DSC's idempotent pattern (Get-AppConfig, Test-AppConfig, Set-AppConfig) without DSC's infrastructure.

### Theme 3: Git Commit Hygiene

- **#1 Per-App Git Clean Filters** [v1] - Directory-level `.gitattributes` with clean filter scripts stripping transient fields. Modular, per-app, self-documenting.
- **#24 Denylist Filters with Fail-Loud** [v2] - Refined denylist approach where unexpected noisy diffs self-diagnose that the filter needs updating.

### Theme 4: App Discovery & Onboarding

- **#8 Interactive Scaffold Wizard** [v2] - `Add-DotfilesProgram "Greenshot"` interactively generates manifest + folder structure.
- **#9 Before/After Diffing** [v1] - `Capture-Before`, change a setting, `Capture-After`. Tool diffs filesystem + registry to show exactly what changed. Auto-generates manifest.
- **#17 Community Config Path Database** [v2] - Curated database mapping popular apps to their config locations, noisy fields, and registry keys.
- **#18 Auto-Detect + Cross-Reference** [v1] - Scan installed apps via chocolatey/winget, cross-reference against managed configs, present interactive onboarding menu.
- **#19 Layered Discovery (Known + Discovered)** [v2] - Library for known apps + before/after diffing for unknowns, feeding discoveries back into the library.

### Theme 5: Package Management

- **#10 Unified Package Manifest** [v1] - Single source-of-truth file replacing `chocolatey.txt` and boxstarter gist. Bootstrap reads this directly.
- **#11 Dual Package Manager Support** [v2] - Manifest supports both chocolatey and winget per package with fallback logic.

### Theme 6: Windows Configuration

- **#2 Registry Export Snapshots** [v2] - PowerShell scripts exporting specific registry paths to .reg files in the repo.
- **#4 Declarative Registry State Files** [v2] - YAML/JSON manifests describing desired registry state, applied idempotently with backup.
- **#14 DSC for Windows Layer Only** [v2] - Rejected as too heavy; concepts absorbed into #15 and existing `windows.json` pattern.

### Theme 7: Visual Tooling (MAUI)

- **#25 MAUI Onboarding App** [v2] - Visual app for scanning installed software, cross-referencing database, generating manifests with live preview.
- **#26 MAUI Drift Dashboard** [v2] - Dashboard showing sync status of all managed configs with one-click fixes.

## Prioritization Results

### v1 - Core Framework (12 ideas)

| # | Idea | Theme |
|---|---|---|
| #13/#23 | Engine/Config sibling repos | Architecture |
| #7 | Co-located manifests | Architecture |
| #21 | Convention-over-config discovery (folder name = package name) | Architecture |
| #5 | Idempotent bootstrap with drift report | Bootstrap |
| #6 | Dry-run / WhatIf mode | Bootstrap |
| #3 | Pre-deploy backup snapshots | Bootstrap |
| #12 | Missing config detection | Bootstrap |
| #1 | Per-app git clean filters | Git hygiene |
| #9 | Before/after diffing for settings discovery | Discovery |
| #18 | Auto-detect installed apps + cross-reference | Discovery |
| #10 | Unified package manifest (replace chocolatey.txt + gist) | Packages |

### v2 - Extensions & Polish (14 ideas)

Lifecycle hooks (#20), Get/Test/Set pattern (#15), denylist refinement (#24), scaffold wizard (#8), known-apps database (#17), self-improving library (#19), winget support (#11), all Windows/registry config (#2, #4, #14), and all MAUI tooling (#25, #26).

## v1 Action Plan

### Step 1: Repo Restructure (#13, #23, #7, #21)

- Create `dotfiles-engine` repo (scripts, module runner, bootstrap logic)
- Create `dotfiles-config` repo (personal settings)
- Restructure `config/Programs/` so each folder = package name, containing `manifest.json` + actual config files
- Engine auto-discovers `*/manifest.json` - no central registration
- Purge legacy apps (VS2013, VS2015, BeyondCompare3, WampServer, etc.)
- **Success metric:** `bootstrap.ps1 -ConfigPath ..\dotfiles-config` works on clean machine

### Step 2: Smart Bootstrap (#5, #6, #3)

- Rewrite bootstrap to check current state before every operation
- Add `-WhatIf` flag for dry-run output
- Add pre-deploy backup: snapshot existing files/symlinks before overwriting
- Print summary report at end: created/skipped/drifted/backed-up
- **Success metric:** Running bootstrap twice in a row produces "everything up to date" with zero changes

### Step 3: Package Manifest (#10)

- Create single `packages.yaml` (or `.json`) replacing `chocolatey.txt` and the boxstarter gist
- Bootstrap reads this file for installs
- **Success metric:** One file is the source of truth, boxstarter gist is retired

### Step 4: Git Clean Filters (#1)

- Add per-app `.gitattributes` + filter scripts for noisy configs
- Register filters during bootstrap
- **Success metric:** `git diff` only shows meaningful settings changes

### Step 5: Discovery & Detection (#9, #18, #12)

- Build before/after diff tool (`Capture-Before` / `Capture-After`)
- Build installed-app scanner (reads package manifest, scans `config/Programs/`)
- Drift report includes: "These installed apps have no config folder yet"
- **Success metric:** After changing a setting in an app, the tool tells you exactly what files/registry keys changed

### Quick Wins (start this week)

- Purge old app configs from the repo
- Restructure one app (e.g., Greenshot) into the new co-located format as proof of concept
- Create the two-repo skeleton

## Session Summary and Insights

**Key Achievements:**

- 26 ideas generated across 7 themes using 3 brainstorming techniques
- Clear v1/v2 prioritization with 12 ideas in v1 core framework
- 5-step implementation plan with concrete success metrics
- Identified that the "noisy config" problem is really a git commit hygiene problem, not a sync problem
- Discovered the plugin architecture pattern as the unifying design principle

**Breakthrough Moments:**

- The "deliberate sync philosophy" realization - the user is the curator, not a machine. This ruled out auto-sync approaches and validated symlinks as the core mechanism.
- The "folder name = package name" convention that eliminates central registration entirely
- The before/after diffing concept for settings discovery - letting apps tell you where their settings live
- Engine/config separation making the project open-sourceable while keeping personal settings private

**Hard Constraints That Shaped Everything:**

- No maintenance after initial setup - drove all design toward set-and-forget patterns
- Big-bang migration acceptable - enables clean break from legacy structure
- PowerShell 7+ only - simplifies codebase, modern features available
- Developer audience - CLI-first approach, visual tooling deferred to v2
