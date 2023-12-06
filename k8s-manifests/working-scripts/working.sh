https://particule.io/en/blog/k8s-no-cloud/


cilium service list
cilium policy list
cilium endpoint list
cilium node list
cilium status
cilium bpf lb list
cilium monitor

kubectl -n kube-system exec ds/cilium -- cilium service list
kubectl -n kube-system exec ds/cilium -- cilium status --verbose

curl -H "Host: play.192.168.2.58.nip.io" --head http://192.168.2.76/apple explain

