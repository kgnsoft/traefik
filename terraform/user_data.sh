#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail


#Join AD domain 
join_domain.sh ${domain_name} ${dir_username} ${dir_password} ${dir_domain_name}

