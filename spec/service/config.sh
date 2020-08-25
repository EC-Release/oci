#/bin/sh

function getProperty {
    PROP_KEY=$1
    PROP_VALUE=`printenv | grep "$PROP_KEY" | cut -d'=' -f2`
    echo $PROP_VALUE
}

#converting the env vars to simple params
port=$(getProperty "conf.port")
pvtkey=$(getProperty "conf.pvtkey")
pubkey=$(getProperty "conf.pubkey")

sed -i "s|{EC_PORT}|$port|g" ~/config.yaml
sed -i "s|{EC_PVTKEY}|$pvtkey|g" ~/config.yaml
sed -i "s|{EC_PUBKEY}|$pubkey|g" ~/config.yaml

cat ./config.yaml
./agent -cfg config.yaml
