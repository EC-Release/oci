#!/bin/bash
pwd; ls -al; cat env.list.sample
eval "sed -i -e 's#{{EC_PRVT_PWD}}#${EC_PRVT_PWD}#g' env.list.sample"
