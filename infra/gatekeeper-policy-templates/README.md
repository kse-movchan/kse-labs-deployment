# Gatekeeper ConstraintTemplates

Vendored `ConstraintTemplate` resources. Upstream source:
https://github.com/open-policy-agent/gatekeeper-library/tree/master/library

Each file corresponds to one template and is kept **verbatim** so upstream
bumps are a clean diff. Parameterization happens in
`../gatekeeper-policy-constraints/` via the Constraint instances.

This directory is deployed by ArgoCD as its own Application
(`infra-gatekeeper-policy-templates`). It must sync before
`infra-gatekeeper-policy-constraints` -- Gatekeeper generates one CRD per
template, and the constraints reference those CRDs.

## Current templates

| File | Kind |
|---|---|
| `read-only-root-fs.yaml` | `K8sPSPReadOnlyRootFilesystem` |
