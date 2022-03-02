#!/bin/bash

 if [ "$#" -gt 0 ]; then
    for arg in "$@"
       do
# if [ $=2 ]; then
         CPUS_PER_NODE=$arg
# fi
       done
 else
    CPUS_PER_NODE=`echo $SLURM_JOB_CPUS_PER_NODE | awk -F "(" '{print $1}'`
 fi

CURDIR=$PWD
#VASP=/home-yw/users/nscc1034_LHHYW/bin/vasp5.3
WIEN2k_run="/vol-th/home/gscomp-lhh/WIEN2k/run_lapw -i 40 -cc 0.0001"
# source /lsfhome/env/intel-12.1.sh
# source  /vol-th/opt/intel/composer_xe_2013.0.079/bin/compilervars.sh intel64
#source /opt/intel/composer_xe_2013.0.079/bin/compilervars.sh intel64
# source /lsfhome/env/openmpi-1.6.5-intel.sh


cd $CURDIR
# for a in 1 2 3
 # do 
 #rm CHG CHGCAR
 # cp INCAR.$a INCAR
 # cp CONTCAR POSCAR
  sleep 10
  
  #start creating .nodelist
#  rm -rf $CURDIR/nodelist >& /dev/null
  cat > $CURDIR/.machines << EOF
# This is a valid .machines file
#
granularity:1
EOF

#start creating .nodelist
#  rm -rf $CURDIR/nodelist >& /dev/null
if [ "$SLURM_JOB_NUM_NODES" = 1 ]; then
        echo "1:"$SLURM_JOB_NODELIST":"$CPUS_PER_NODE>> $CURDIR/.machines
else
       node_pre=`echo $SLURM_JOB_NODELIST | awk -F "[" '{print $1}'`
       nodelist=`echo $SLURM_JOB_NODELIST | awk -F "[" '{print $2}' | awk -F "]" '{print $1}' `
       nodelist_split=`echo $nodelist | sed 's/,/\ /g'`
       for i in $nodelist_split
        do 
           num=`echo $i | awk -F "-" '{print NF}'`
           if [ "$num" = 1 ]; then
                 nodelist_i=$node_pre$i
                 echo "1:"$nodelist_i":"$CPUS_PER_NODE>> $CURDIR/.machines
           else
                 nodelist_0=`echo $i | awk -F "-" '{print int($1)}'`
                 nodelist_N=`echo $i | awk -F "-" '{print int($2)}'`
                 for ((j=$nodelist_0; j<=$nodelist_N; ++j))
                  do
                       nodelist_i=$node_pre$j
                       echo "1:"$nodelist_i":"$CPUS_PER_NODE>> $CURDIR/.machines
                  done
           fi
        done
fi

  echo "lapw0:"$HOSTNAME":"$CPUS_PER_NODE>> $CURDIR/.machines
  echo "extrafine:1" >> $CURDIR/.machines

 # nodelist=$(cat $CURDIR/nodelist | uniq | awk '{print $1}' | tr '\n' ',')

  #
  echo -n "start time  " > time
  date >> time
#  mpirun -np $NP -machinefile $CURDIR/nodelist $VASP  &> vasp.out
  $WIEN2k_run -p &> WIEN2k.out 
  echo -n "end   time  " >> time 
  date >> time
  cat time >> WIEN2k.out

# done

 exit 0
