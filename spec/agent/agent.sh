#/bin/sh

function getProperty {
    PROP_KEY=$1
    PROP_VALUE=`printenv | grep "$PROP_KEY" | cut -d'=' -f2`
    echo $PROP_VALUE
}

#converting the env vars to simple params
mod=$(getProperty "conf.mod")
aid=$(getProperty "conf.aid")
tid=$(getProperty "conf.tid")
cid=$(getProperty "conf.cid")
csc=$(getProperty "conf.csc")
oa2=$(getProperty "conf.oa2")
dur=$(getProperty "conf.dur")
dbg=$(getProperty "conf.dbg")
zon=$(getProperty "conf.zon")
grp=$(getProperty "conf.grp")
cps=$(getProperty "conf.cps")
lpt=$(getProperty "conf.lpt")
gpt=$(getProperty "conf.gpt")
rpt=$(getProperty "conf.rpt")
rht=$(getProperty "conf.rht")
hst=$(getProperty "conf.hst")
sst=$(getProperty "conf.sst")
tkn=$(getProperty "conf.tkn")
pxy=$(getProperty "conf.pxy")
plg=$(getProperty "conf.plg")
hca=$(getProperty "conf.hca")

sed -i 's@{EC_AID}@'"$aid"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_TID}@'"$tid"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_CID}@'"$cid"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_CSC}@'"$csc"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_OA2}@'"$oa2"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_DUR}@'"$dur"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_DBG}@'"$dbg"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_ZON}@'"$zon"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_GRP}@'"$grp"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_CPS}@'"$cps"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_LPT}@'"$lpt"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_GPT}@'"$gpt"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_RPT}@'"$rpt"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_RHT}@'"$rht"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_HST}@'"$hst"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_SST}@'"$sst"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_TKN}@'"$tkn"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_PXY}@'"$pxy"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_PLG}@'"$plg"'@g' ~/${conf.mod}.yml
sed -i 's@{EC_HCA}@'"$hca"'@g' ~/${conf.mod}.yml
cat ./${mod}.yml
./agent -cfg ${mod}.yml
