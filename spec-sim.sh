#!/bin/bash

yq() {
  docker run --rm -i -v "${PWD}":/workdir mikefarah/yq yq "$@"
}

kubectl cluster-info
helm version
echo $(pwd)

printf "\n\n\n*** update the pkg chart params \n\n"
eval "sed -i -e 's#<AGENT_HELPER_CHART_REV>#${AGENT_HELPER_CHART_REV}#g' k8s/agent+helper/Chart.yaml"
eval "sed -i -e 's#<AGENT_CHART_REV>#${AGENT_CHART_REV}#g' k8s/agent/Chart.yaml"
eval "sed -i -e 's#<AGENT_HELPER_CHART_REV>#${AGENT_HELPER_CHART_REV}#g' k8s/agent/Chart.yaml"
eval "sed -i -e 's#<AGENT_PLG_CHART_REV>#${AGENT_PLG_CHART_REV}#g' k8s/agent+plg/Chart.yaml"
eval "sed -i -e 's#<AGENT_HELPER_CHART_REV>#${AGENT_HELPER_CHART_REV}#g' k8s/agent+plg/Chart.yaml"
eval "sed -i -e 's#<AGENT_HELPER_CHART_REV>#${AGENT_HELPER_CHART_REV}#g' k8s/example/Chart.yaml"
eval "sed -i -e 's#<AGENT_PLG_CHART_REV>#${AGENT_PLG_CHART_REV}#g' k8s/example/Chart.yaml"
eval "sed -i -e 's#<AGENT_CHART_REV>#${AGENT_CHART_REV}#g' k8s/example/Chart.yaml"
cat k8s/agent+helper/Chart.yaml k8s/agent/Chart.yaml k8s/agent+plg/Chart.yaml k8s/example/Chart.yaml

printf "\n\n\n*** update server+tls.env \n\n"
eval "sed -i -e 's#{{EC_TEST_OA2}}#${EC_TEST_OA2}#g' k8s/example/server+tls.env"
eval "sed -i -e 's#{{EC_TEST_AID}}#${EC_TEST_AID}#g' k8s/example/server+tls.env"
eval "sed -i -e 's#{{EC_TEST_TKN}}#${EC_TEST_TKN}#g' k8s/example/server+tls.env"
eval "sed -i -e 's#{{EC_TEST_SST}}#${EC_TEST_SST}#g' k8s/example/server+tls.env"
eval "sed -i -e 's#{{EC_TEST_HST}}#${EC_TEST_HST}#g' k8s/example/server+tls.env"
eval "sed -i -e 's#{{EC_TEST_ZON}}#${EC_TEST_ZON}#g' k8s/example/server+tls.env"
eval "sed -i -e 's#{{EC_TEST_GRP}}#${EC_TEST_GRP}#g' k8s/example/server+tls.env"
eval "sed -i -e 's#{{EC_TEST_CID}}#${EC_TEST_CID}#g' k8s/example/server+tls.env"
eval "sed -i -e 's#{{EC_TEST_CSC}}#${EC_TEST_CSC}#g' k8s/example/server+tls.env"

printf "\n\n\n*** update client+vln.env \n\n"
eval "sed -i -e 's#{{EC_TEST_OA2}}#${EC_TEST_OA2}#g' k8s/example/client+vln.env"
eval "sed -i -e 's#{{EC_TEST_ZON}}#${EC_TEST_ZON}#g' k8s/example/client+vln.env"
eval "sed -i -e 's#{{EC_TEST_GRP}}#${EC_TEST_GRP}#g' k8s/example/client+vln.env"
eval "sed -i -e 's#{{EC_TEST_CID}}#${EC_TEST_CID}#g' k8s/example/client+vln.env"
eval "sed -i -e 's#{{EC_TEST_CSC}}#${EC_TEST_CSC}#g' k8s/example/client+vln.env"

printf "\n\n\n*** update gateway.env \n\n"
eval "sed -i -e 's#{{EC_TEST_ZON}}#${EC_TEST_ZON}#g' k8s/example/gateway.env"
eval "sed -i -e 's#{{EC_TEST_GRP}}#${EC_TEST_GRP}#g' k8s/example/gateway.env"
eval "sed -i -e 's#{{EC_TEST_SST}}#${EC_TEST_SST}#g' k8s/example/gateway.env"
eval "sed -i -e 's#{{EC_TEST_TKN}}#${EC_TEST_TKN}#g' k8s/example/gateway.env"

printf "\n\n\n*** packaging w/ dependencies \n\n"
mkdir -p k8s/pkg/agent/$AGENT_CHART_REV k8s/pkg/agent+helper/$AGENT_HELPER_CHART_REV k8s/pkg/agent+plg/$AGENT_PLG_CHART_REV
ls -la k8s/pkg
helm package k8s/agent+helper -d k8s/pkg/agent+helper/$AGENT_HELPER_CHART_REV
helm dependency update k8s/agent
helm dependency update k8s/agent+plg
helm package k8s/agent -d k8s/pkg/agent/$AGENT_CHART_REV
helm package k8s/agent+plg -d k8s/pkg/agent+plg/$AGENT_PLG_CHART_REV

printf "update dependencies in example chart for test"
helm dependency update k8s/example

printf "\n\n\n*** test server with tls template\n\n"
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.tls.enabled true
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.vln.enabled false
helm template k8s/example --debug --set-file global.agtConfig=k8s/example/server+tls.env

printf "\n\n\n*** test client with local vln template\n\n"
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.tls.enabled false
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.vln.enabled true
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.vln.remote false
helm template k8s/example --debug --set-file global.agtConfig=k8s/example/client+vln.env

printf "\n\n\n*** test client with remote vln template\n\n"
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.tls.enabled false
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.vln.enabled true
yq w -i k8s/example/values.yaml global.agtK8Config.withPlugins.vln.remote true
helm template k8s/example --debug --set-file global.agtConfig=k8s/example/client+vln.env

printf "\n\n\n*** test gateway agt template\n\n"
helm template k8s/example --debug --set-file global.agtConfig=k8s/example/gateway.env

printf "\n\n\n*** pkg indexing\n\n"
helm repo index k8s/pkg/agent/$AGENT_CHART_REV --url https://ec-release.github.io/oci/agent/$AGENT_CHART_REV
helm repo index k8s/pkg/agent+helper/$AGENT_HELPER_CHART_REV --url https://ec-release.github.io/oci/agent+helper/$AGENT_HELPER_CHART_REV
helm repo index k8s/pkg/agent+plg/$AGENT_PLG_CHART_REV --url https://ec-release.github.io/oci/agent+plg/$AGENT_PLG_CHART_REV
