#!/bin/csh -f

cd /nchudata/account/nuivtrain/Desktop/2023-IC-Design-Contest

#This ENV is used to avoid overriding current script in next vcselab run 
setenv SNPS_VCSELAB_SCRIPT_NO_OVERRIDE  1

/usr/cad/synopsys/vcs/2022.06/linux/bin/vcselab $* \
    -o \
    simv \
    -nobanner \

cd -

