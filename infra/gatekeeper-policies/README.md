# Gatekeeper Policies

Lab OPA Gatekeeper policies sourced from the community library
(https://github.com/open-policy-agent/gatekeeper-library).

Each policy is a pair of files:

- `template-<name>.yaml` -- the `ConstraintTemplate` (policy class, Rego +
  CEL). Vendored **verbatim** from upstream so upgrades are a straight diff.
- `constraint-<name>.yaml` -- our `Constraint` instance (match rules, parameters,
  `enforcementAction`). Edit freely.

## Current policies

| Policy | Template | Constraint | Enforcement |
|---|---|---|---|
| Read-only root filesystem | `K8sPSPReadOnlyRootFilesystem` | `pods-must-use-read-only-root-fs` | `dryrun` |

## Workflow

1. **dryrun first.** Apply the constraint with `enforcementAction: dryrun`.
   Audit runs and violations land in `kubectl get <kind> <name> -o jsonpath='{.status.violations}'`.
2. **Fix or exempt** the reported violations: either patch the workloads
   or add image prefixes to `parameters.exemptImages` / namespaces to
   `match.excludedNamespaces`.
3. **Flip to `deny`** once the audit is clean. The webhook will then block
   new non-compliant workloads at admission.

## Sync ordering

ArgoCD applies the ConstraintTemplate first (default wave 0) and the
Constraint second (wave 1). The Constraint needs the CRD that Gatekeeper
generates from the ConstraintTemplate -- without the wave, the first sync
attempt fails and ArgoCD retries.
