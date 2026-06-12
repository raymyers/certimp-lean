# AGENTS.md

Guidance for AI coding agents working in this repository.

## What this is

CertIMP is a [Lean 4](https://lean-lang.org/) development of IMP, a simple imperative
language from programming-language theory. Its headline contribution is a *verified
compiler* from IMP to a stack-machine ISA, proved by semantics preservation, plus a
verified constant-folding optimization pass. It adapts the first five chapters of
*Software Foundations Vol. 2*. See `README.md` for the full tour.

## Environment & build

- Toolchain is pinned in `lean-toolchain` (currently `leanprover/lean4:v4.28.0`).
  Dependencies are declared in `lakefile.toml`; the project depends on `Mathlib`.
- Build with `lake build`. **Before the first build**, run `lake exe cache get` to
  download Mathlib's prebuilt `.olean` cache — building Mathlib from source takes hours.
- Nix users: `nix develop` provides a dev shell with `elan` (which installs the pinned
  toolchain and bundles `lake`). Then `lake exe cache get` and `lake build` as usual.

## Validating changes

- **A successful `lake build` is the proof check.** Lean elaborates and verifies every
  proof during the build; if it completes, the proofs are valid. Always run `lake build`
  after editing any `.lean` file.
- There is no separate test suite — correctness is the type-checked proofs themselves.
- CI runs the same build via `.github/workflows/lean_action_ci.yml`.
- Never close a goal with `sorry`, `admit`, or `native_decide` to "make it build". An
  incomplete proof must be left as a visible `sorry` and called out, not hidden.

## Project layout

- `CertIMP.lean` / `CertIMP/Basic.lean` — root, re-exporting the submodules below.
- `CertIMP/Syntax/` — IMP AST and the metaprogramming-based parser/notation.
- `CertIMP/Eval/` — big-step operational semantics and program state.
- `CertIMP/Equiv/` — program equivalence.
- `CertIMP/Hoare/` — Hoare logic (soundness, completeness), the VCG tactic, and total
  correctness / weakest-precondition material.
- `CertIMP/StackMachine/` — the idealized machine, its ISA and semantics, the compiler
  (`Compile.lean`), and the semantics-preservation proof (`SemanticsPreservation.lean`).
- `CertIMP/Transformation/` — code transformations, including constant folding.
- Most directories pair a `Def.lean` (definitions) with an `Exercises.lean` (proofs).

## Conventions

- Match the surrounding Lean style: existing naming, `Mathlib` lemmas and tactics, and
  the `pp.unicode.fun` setting (`fun a ↦ b`) configured in `lakefile.toml`.
- `relaxedAutoImplicit = false` is set — declare implicit binders explicitly.
- Keep proofs in the established `Def` / `Exercises` split where a module uses it.
