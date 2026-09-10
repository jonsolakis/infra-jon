set dotenv-load := true

tofu_dir := "tofu"
helmfile_dir := "helmfile"
environment := "hobby"

default:
  @just --list

check-tools:
  @command -v tofu >/dev/null || { echo "missing: tofu"; exit 1; }
  @command -v helm >/dev/null || { echo "missing: helm"; exit 1; }
  @command -v helmfile >/dev/null || { echo "missing: helmfile"; exit 1; }
  @command -v kubectl >/dev/null || { echo "missing: kubectl"; exit 1; }
  @command -v doctl >/dev/null || { echo "missing: doctl"; exit 1; }
  @command -v sops >/dev/null || { echo "missing: sops"; exit 1; }
  @command -v age >/dev/null || { echo "missing: age"; exit 1; }
  @command -v flux >/dev/null || { echo "missing: flux"; exit 1; }

fmt:
  tofu -chdir={{tofu_dir}} fmt -recursive

fmt-check:
  tofu -chdir={{tofu_dir}} fmt -check -recursive

tofu-init:
  tofu -chdir={{tofu_dir}} init

tofu-validate: tofu-init
  tofu -chdir={{tofu_dir}} validate

tofu-plan: tofu-init
  tofu -chdir={{tofu_dir}} plan

tofu-apply: tofu-init
  tofu -chdir={{tofu_dir}} apply

kubeconfig:
  doctl kubernetes cluster kubeconfig save "$(tofu -chdir={{tofu_dir}} output -raw cluster_id)"

registry-login:
  doctl registries login "$(tofu -chdir={{tofu_dir}} output -raw container_registry_name)"

registry-integrate:
  doctl kubernetes cluster registry add "$(tofu -chdir={{tofu_dir}} output -raw cluster_id)"

helm-diff:
  cd {{helmfile_dir}} && helmfile --environment {{environment}} diff

helm-apply:
  cd {{helmfile_dir}} && helmfile --environment {{environment}} apply

helm-template:
  cd {{helmfile_dir}} && helmfile --environment {{environment}} template

flux-check:
  flux check

flux-status:
  flux get all --all-namespaces

flux-reconcile:
  flux reconcile kustomization fantasy-hockey --with-source

gitops-template:
  kubectl kustomize apps/fantasy-hockey >/dev/null
  kubectl kustomize clusters/hobby >/dev/null

validate: check-tools fmt-check tofu-validate gitops-template
