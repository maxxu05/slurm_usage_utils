
usage_by_lab() {
    {
        sacctmgr -nop show assoc format=account,user,grptres | grep -v 'root' | grep -v 'test-lab';
        squeue -O "UserName,StateCompact,QOS,tres-alloc:1000,Account,Partition" -h | tr -s " " | awk '$0="G> "$0' | grep gpu | sort;
    } | awk  -v labfilter="$2" -f $1 -
}

usage_by_node() {
    { sinfo -o '%n %G %O %e %a %C %T' -S '-O'; squeue -o "G> %N %P [%t] %b %q %C" -h | grep "\[R\]"; } | awk -f $1 -
}

usage_by_node_type() {
    { sinfo -o '%f %n' -S '-f';
      squeue -O "UserName,StateCompact,QOS,tres-alloc:1000,Account,Partition,tres-per-node,NodeList" -h | tr -s " " | awk '$0="G> "$0' | grep gpu | sort;
    } | awk -f $1 -
}


gpus_users() {
    if [[ $1 == "-q" ]]; then
        usage_by_lab ~/slurm_usage_utils/lab_usage_qos.awk $2
    elif [[ $1 == "-v" ]]; then
        usage_by_lab ~/slurm_usage_utils/lab_usage_verbose.awk $2
    else
        usage_by_lab ~/slurm_usage_utils/lab_usage.awk $1
    fi
}

node_usage() {
    if [ $# -eq 1 ]; then
        if [[ $1 == "-q" ]]; then
            usage_by_node ~/slurm_usage_utils/node_usage.awk
        elif [[ $1 == "-v" ]]; then
            usage_by_node ~/slurm_usage_utils/node_usage.awk
        fi
    else
        usage_by_node ~/slurm_usage_utils/node_usage.awk
    fi
}

gpu_types_users() {
    if [ $# -eq 1 ]; then
        if [[ $1 == "-v" ]]; then
            usage_by_node_type ~/slurm_usage_utils/gpu_types_usage_verbose.awk
        fi
    else
        usage_by_node_type ~/slurm_usage_utils/gpu_types_usage.awk
    fi
}
