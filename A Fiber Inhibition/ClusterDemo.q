#!/bin/tcsh
#
#$ -S /bin/tcsh -cwd
#$ -o ClusterDemo.out -j y
#$ -l mem_free=1G

cp ~/Aguilar_Melnick_Mod_Files_T_True/x86_64/special ~/Singlenodal_Model_Overhaul_S1/WeightTest_SGT_NoA/Run$SGE_TASK_ID

cd ~/Singlenodal_Model_Overhaul_S1/WeightTest_SGT_NoA/Run$SGE_TASK_ID

chmod +x special

setenv LD_LIBRARY_PATH /opt/intel/Compiler/11.1/072/lib/intel64:/opt/apps/lib
./special Overlord_Cluster.hoc
