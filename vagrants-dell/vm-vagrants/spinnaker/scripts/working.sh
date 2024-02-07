https://medium.com/@jaskirat8/netflix-spinnaker-on-azure-and-bare-metal-a7a924879e0

hal config provider kubernetes enable

hal config version

hal config version edit --version $VERSION

# this will update Spinnaker
hal deploy apply

hal config provider kubernetes account add spin-kube-account \
--provider-version v2 \
--context $(kubectl config current-context)

hal config deploy edit --type distributed --account-name spin-kube-account

# hal config deploy edit --type localdebian

cd /usr/local/bin
sudo wget https://dl.minio.io/server/minio/release/linux-amd64/minio
sudo chmod +x minio


export MINIO_ACCESS_KEY=spinnaker
export MINIO_SECRET_KEY=spinnaker@123
minio server --address=:9001 "~/minio-files" >> ~/minio.log 2>&1 &


hal config storage s3 edit \
--endpoint http://192.168.1.136:9001 \
--access-key-id spinnaker \
--secret-access-key spinnaker@123 \
--path-style-access true 



hal config storage edit --type s3


hal config version edit --version 1.26.7


hal config version

hal deploy apply


minio server --address=:9001 "~/minio-files" >> ~/minio.log 2>&1 &

hal config storage s3 edit --path-style-access=true


helm install minio --namespace minio \
--create-namespace \
 --set accessKey="spinnaker" \
 --set secretKey="spinnaker" \
 --set persistence.enabled=false \
 --set resources.requests.memory=256Mi \
 --set replicas=2 \
 minio/minio


helm upgrade --install minio --namespace minio \
--create-namespace \
minio-chart/

minio-service
minio-service

hal config storage s3 edit \
--endpoint http://minio-svc.minio:9000 \
--access-key-id minio \
--secret-access-key minio123 \
--path-style-access true 

kubectl api-resources --verbs=list --namespaced -o name \
  | xargs -n 1 kubectl get --show-kind --ignore-not-found -n spinnaker

 helm upgrade --install minio --namespace minio \
--create-namespace \
minio-chart/

hal deploy connect

hal deploy clean


kubectl -n spinnaker port-forward service/spin-deck 9000:9000
kubectl -n spinnaker port-forward service/spin-gate 8084:8084

#minio console http://localhost:9001
kubectl port-forward minio-deployment-8849b85cf-57wrj 9001 --namespace minio


echo '{"id":"2b5615cf-13bf-4c4e-bfe9-e77d49386460","metadata":{"description":"A pipeline template derived from pipeline \"rtr-job-01\" in application \"rtrspinapp\"","name":"polite-snake-93","owner":"rupeshr78@gmail.com","scopes":["global"]},"pipeline":{"keepWaitingPipelines":false,"lastModifiedBy":"anonymous","limitConcurrent":true,"spelEvaluator":"v4","stages":[{"account":"spin-kube-account","alias":"runJob","application":"rtrspinapp","cloudProvider":"kubernetes","credentials":"spin-kube-account","manifest":{"apiVersion":"batch/v1","kind":"Job","metadata":{"name":"pi-with-ttl","namespace":"default"},"spec":{"template":{"spec":{"containers":[{"command":["perl","-Mbignum=bpi","-wle","print bpi(2000)"],"image":"perl:5.34.0","name":"pi"}],"restartPolicy":"Never"}},"ttlSecondsAfterFinished":100}},"name":"Run Job (Manifest)","refId":"1","requisiteStageRefIds":[],"source":"text","type":"runJobManifest"}],"triggers":[],"updateTs":"1658966012000"},"protect":false,"schema":"v2","variables":[]}' | 
spin pipeline-templates save