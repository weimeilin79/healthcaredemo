#!/bin/sh 
DEMO="FIS Healthcare Demo"
AUTHORS="Christina Lin, Andrew Block, Eric D. Schabell"
PROJECT="git@github.com:eschabell/cdk-install-demo.git"
PRODUCT="JBoss Fuse, Container Development Kit, OpenShift"
CDK_HOME=./target
SRC_DIR=./installs
SUPPORT_DIR=./support
PRJ_DIR=./projects/healthcaredemo
CDK_PLUGINS_DIR=$CDK_HOME/cdk/plugins
CDK=cdk-2.0.0-beta5.zip
OSX_BOX=rhel-cdk-kubernetes-7.2-21.x86_64.vagrant-virtualbox.box
LINUX_BOX=rhel-cdk-kubernetes-7.2-21.x86_64.vagrant-libvirt.box
VAGRANTFILE=VagrantFile-rhel-ose
CDK_BOX_VERSION=cdkv2
VERSION=2.0.0-beta5

# wipe screen.
clear 

echo
echo "###########################################################################"
echo "##                                                                       ##"   
echo "##  Uninstalling     ${DEMO}                            ##"
echo "##                                                                       ##"   
echo "##                                                                       ##"   
echo "##   ##### #   # ##### #####                                             ##"
echo "##   #     #   # #     #                                                 ##"
echo "##   ##### #   # # # # #####                                             ##"
echo "##   #     #   #     # #                                                 ##"
echo "##   #      ###  ##### #####                                             ##"
echo "##                                                                       ##"   
echo "##   ##### #   # ##### ##### ##### ##### ##### ##### ##### ##### #   #   ##"
echo "##     #   ##  #   #   #     #     #   # #   #   #     #   #   # ##  #   ##"
echo "##     #   # # #   #   ##### #  ## ##### #####   #     #   #   # # # #   ##"
echo "##     #   #  ##   #   #     #   # #  #  #   #   #     #   #   # #  ##   ##"
echo "##   ##### #   #   #   ##### ##### #   # #   #   #   ##### ##### #   #   ##"   
echo "##                                                                       ##"   
echo "##   ##### ##### ##### #   # ##### ##### #####                           ##"
echo "##   #     #     #   # #   #   #   #     #                               ##"
echo "##   # # # ##### ##### #   #   #   #     #####                           ##"
echo "##       # #     #  #   # #    #   #     #                               ##"
echo "##   ##### ##### #   #   #   ##### ##### #####                           ##"
echo "##                                                                       ##"
echo "###########################################################################"
echo

echo 
echo "Shutting down OpenShift"
echo
cd $CDK_HOME/cdk/components/rhel/rhel-ose
vagrant destroy 

# Start adding application related projects
cd ../../../../..

echo "Removing the CDK installation..."
echo
rm -rf $CDK_HOME

echo 
echo "Removing the generated projects .."
echo

echo "Removing clinicservice project .."
echo
rm -rf $PRJ_DIR/clinicservice/target

echo "Removing fhiresb project .."
echo
rm -rf $PRJ_DIR/fhiresb/target

echo "Removing hisesb project .."
echo
rm -rf $PRJ_DIR/hisesb/target

echo "Removing laboratoryservice project .."
echo
rm -rf $PRJ_DIR/laboratoryservice/target

echo "Removing radiologyservice project .."
echo
rm -rf $PRJ_DIR/radiologyservice/target

echo "Removing registryservice project .."
echo
rm -rf $PRJ_DIR/registryservice/target

echo "Removing webconsoleservice project .."
echo
rm -rf $PRJ_DIR/webconsoleservice/target

echo 
echo "Removing OpenShift Client installation .."
echo
rm -rf mnt