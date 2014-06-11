export PATH=$[emake_install_path]/bin:$[emake_install_path]/unsupported:$PATH
password=`ectool getFullCredential cm_admin --value password`
cmtool --cm training-cm login admin $password
cmtool --cm training-cm changeAgentsEnabled false
cmtool --cm training-cm getAgents > cm_get_agents.log