#!/bin/bash
git config user.email "EC.Bot@ge.com"
git config user.name "EC Bot"
git add k8s/pkg/.
git commit -m 'helm package update [skip ci]'
git push https://${GITHUB_TOKEN}@github.com/Enterprise-connect/oci.git HEAD:v1.1beta_helm_pkg
