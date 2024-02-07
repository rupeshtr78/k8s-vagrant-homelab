flux bootstrap github \
  --token-auth \
  --owner=rupeshtr78@gmail.com
  --repository=p90s-k8s-flux \
  --branch=main \
  --path=clusters/p90s-k8s \
  --personal


  flux bootstrap github \
  --token-auth \
  --owner=rupeshtr78 \
  --repository=p90s-k8s-flux \
  --branch=main \
  --path=clusters/p90s-k8s \
  --personal
► connecting to github.com
✔ repository "https://github.com/rupeshtr78/p90s-k8s-flux" created
► cloning branch "main" from Git repository "https://github.com/rupeshtr78/p90s-k8s-flux.git"
✔ cloned repository
► generating component manifests
✔ generated component manifests
✔ committed component manifests to "main" ("e045f95ef89a3cc79623d271a55cc3744861d889")
► pushing component manifests to "https://github.com/rupeshtr78/p90s-k8s-flux.git"
► installing components in "flux-system" namespace
✔ installed components
✔ reconciled components
► determining if source secret "flux-system/flux-system" exists
► generating source secret
► applying source secret "flux-system/flux-system"
✔ reconciled source secret
► generating sync manifests
✔ generated sync manifests
✔ committed sync manifests to "main" ("24926ec4e4606cb1d00b9e6acdef046481719ca8")
► pushing sync manifests to "https://github.com/rupeshtr78/p90s-k8s-flux.git"
► applying sync manifests
✔ reconciled sync configuration
◎ waiting for GitRepository "flux-system/flux-system" to be reconciled
✔ GitRepository reconciled successfully
◎ waiting for Kustomization "flux-system/flux-system" to be reconciled
✔ Kustomization reconciled successfully
► confirming components are healthy
✔ helm-controller: deployment ready
✔ kustomize-controller: deployment ready
✔ notification-controller: deployment ready
✔ source-controller: deployment ready
✔ all components are healthy

