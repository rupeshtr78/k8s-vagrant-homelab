for i in $(seq 1 3); do

oc create -f - <<PV
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv0$i
spec:
  accessModes:
  - ReadWriteOnce
  - ReadWriteMany
  - ReadOnlyMany
  capacity:
    storage: 2Gi
  hostPath:
    path: /var/lib/minishift/pv/pv0$i
  persistentVolumeReclaimPolicy: Recycle
PV

done