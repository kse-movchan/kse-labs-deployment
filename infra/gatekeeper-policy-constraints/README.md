# Gatekeeper Constraints

`Constraint` instances that parameterize the templates in
`../gatekeeper-policy-templates/`. Each constraint sets `match` rules,
`parameters`, and `enforcementAction` (`dryrun`, `warn`, or `deny`).

Constraints are lab-specific -- edit freely. Upgrades to the underlying
template do not usually require changes here.

This directory is deployed by ArgoCD as its own Application
(`infra-gatekeeper-policy-constraints`). It must sync **after**
`infra-gatekeeper-policy-templates` because each Constraint references a
CRD that Gatekeeper generates from its ConstraintTemplate. ArgoCD will
retry failed syncs until the CRD exists -- typically the Application goes
`OutOfSync` -> `Progressing` -> `Healthy` within two retry cycles.

## Current constraints

| File | Kind | Name | Enforcement |
|---|---|---|---|
| `read-only-root-fs.yaml` | `K8sPSPReadOnlyRootFilesystem` | `pods-must-use-read-only-root-fs` | `dryrun` |

## Workflow

1. **dryrun first.** Apply with `enforcementAction: dryrun`. Audit runs
   and violations land in `kubectl get <kind> <name> -o jsonpath='{.status.violations}'`.
2. **Fix or exempt** the reported violations: either patch the workloads
   or add image prefixes to `parameters.exemptImages` / namespaces to
   `match.excludedNamespaces`.
3. **Flip to `deny`** once the audit is clean. The webhook will then
   block new non-compliant workloads at admission.
