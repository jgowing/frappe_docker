#!/bin/bash
export APPS_JSON_BASE64=$(base64 -w 0 ./apps.json)
VER=$(wget -q -O - https://api.github.com/repos/frappe/hrms/releases/latest | jq -r .name | cut -c2-)
REL_TAG=opb/frappe-hrms:$VER
REPO=docker://docker-push.sandbox.opb

echo "building $REL_TAG"
podman build \
  --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
  --build-arg=FRAPPE_BRANCH=version-15 \
  --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
  --tag=$REL_TAG \
  --file=images/custom/Containerfile .

echo "pushing image to $REPO"
podman push $REL_TAG $REPO/$REL_TAG
