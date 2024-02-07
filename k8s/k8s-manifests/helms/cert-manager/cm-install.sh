kubectl apply -f cert-manager.yaml


# Create secret with your CA certificate
kubectl create secret tls p90s-ca-keypair --cert=ca.crt --key=ca.key -n cert-manager

openssl genrsa -out proxy-sa.key 2048
