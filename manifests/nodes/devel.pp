class includeAllThingsForA_Developer {
    notify { "node/elexisDev.pp includeAllThingsForA_Developer": }
    include etckeeper
    include elexis::client
    include elexis::mysql_server
    include elexis::devel

#   uncomment next line to add Jenkins & Jubula test for 2.1.7
#    elexis::jenkins_elexis{'2.1.7': } 

#   uncomment next three lines to add Juno
#    elexis::download_eclipse_version{'eclipse-rcp-juno': }
    
    x2go::client {"x2go-client": } 
    x2go::server {"x2go-server": }
    
    include elexis::praxis_wiki
    class {['kde']: stage => last; } # I want the interesting things to load first!
}

node 'devel' {
  include includeAllThingsForA_Developer
}
