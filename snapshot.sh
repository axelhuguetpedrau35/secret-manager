#!/bin/bash

POD_NAME="openbao-vault-0"
NAMESPACE="openbao"
SNAPSHOT_DIR="/home/openbao/openbao-snapshots"
SNAPSHOT_FILE="openbao-$(date +%F_%H-%M-%S).snap"
VAULT_TOKEN="fake_token"

echo "[INFO] Création du snapshot depuis le pod $POD_NAME..."

kubectl exec -n "$NAMESPACE" "$POD_NAME" -- \
  sh -c "VAULT_ADDR=http://127.0.0.1:8500 VAULT_TOKEN=$VAULT_TOKEN vault operator raft snapshot save /tmp/snap.snap"

if [ $? -eq 0 ]; then
  kubectl cp "$NAMESPACE/$POD_NAME:/tmp/snap.snap" "$SNAPSHOT_DIR/$SNAPSHOT_FILE"
  echo "Snapshot sauvegardé dans : $SNAPSHOT_DIR/$SNAPSHOT_FILE"
else
  echo "Échec lors de la création du snapshot !"
  exit 2
fi
