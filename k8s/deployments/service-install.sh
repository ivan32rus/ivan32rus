#!/bin/bash

if [ "$1" == "apply" ]
  then
    kubectl create -f namespaces.yml
    kubectl apply -f ./DB -n dev
    kubectl apply -f ./UI -n dev
    kubectl apply -f ./CRAWLER -n dev
    kubectl apply -f ./log_monitor -n monitoring
    echo 'End started !'

elif [ "$1" == "delete" ]
  then
    kubectl delete -f ./DB -n dev --force
    kubectl delete -f ./UI -n dev --force
    kubectl delete -f ./CRAWLER -n dev --force
    kubectl delete -f ./log_monitor -n dev --force
    kubectl delete -f ./gitlab -n dev --force
    kubectl delete --all deployments -n dev
    kubectl delete --all deployments -n monitoring
    kubectl delete --all service -n dev 
    kubectl delete --all service -n monitoring
    kubectl get pods --all-namespaces -o json | jq '.items[] | select(.status.reason!=null) | select(.status.reason | contains("Evicted")) | "kubectl delete pods \(.metadata.name) -n \(.metadata.namespace)"' | xargs -n 1 bash -c
    kubectl get pods --all-namespaces | egrep -i  'Evicted|Terminated|CrashLoopBackOff' | awk '{print $2 " --namespace=" $1}' | xargs kubectl delete pod --force=true --wait=false --grace-period=0
    kubectl delete -f namespaces.yml

else
    echo 'No name commands'

fi
