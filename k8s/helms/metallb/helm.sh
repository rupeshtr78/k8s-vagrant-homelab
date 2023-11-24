#!/bin/bash
helm repo add metallb https://metallb.github.io/metallb
helm repo update

helm install metallb metallb/metallb --namespace metallb \
--create-namespace \
--set configInline.address-pools[0].name=default \
--set configInline.address-pools[0].protocol=layer2 \
--set configInline.address-pools[0].addresses[0]=192.168.2.50-192.168.2.100
