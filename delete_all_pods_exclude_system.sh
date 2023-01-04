#!/usr/bin/env bash

# Delete all pods exclude kube-system namespace
# Reference: https://serverfault.com/questions/1076435/how-to-delete-all-namespaces-except-the-kube-system-in-k3s-cluster

die () 
{ 
    echo "$@" 1>&2
    exit 1
}

usage () 
{ 
    echo "usage: $0 [-h] [-v namespace_to_ignore] " 1>&2
    exit 0
}

inarray () 
{ 
    local n=$1 h
    shift
    for h in "$@"
    do
        [[ $n = "$h" ]] && return
    done
    return 1
}

while getopts ":v:h" opt; do
    case $opt in 
        h)
            usage
        ;;
        v)
            case $OPTARG in 
                '' | *[0-9]*)
                    die "Digits not allowed $OPTARG"
                ;;
                *)
                    val=$OPTARG
                ;;
            esac
        ;;
        :)
            die "argument needed to -$OPTARG"
        ;;
        *)
            die "invalid switch -$OPTARG"
        ;;
    esac
done

shift $((OPTIND - 1))

while IFS='/' read -r _ ns; do
    a+=("$ns")
done < <(kubectl get namespaces --no-headers -o name)

if inarray "$val" "${a[@]}"; then
    unset 'a'
    { 
        while IFS='/' read -r _ ns; do
            a+=("$ns")
            for i in "${!a[@]}"
            do
                if [[ ${a[i]} == $val ]]; then
                    unset 'a[i]'
                fi
            done
        done
    } < <(kubectl get namespaces --no-headers -o name)

    printf '%s\n\n' "Excluding ... $val"
    for namespace in "${a[@]}"
    do
        printf '🗑️  Deleting ... %s\n' "$namespace"
        kubectl delete namespace "$namespace"
    done
else
    die "No namespace found"
fi