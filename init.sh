#!/bin/sh 
DEMO="FIS Healthcare Demo"
AUTHORS="Christina Lin, Andrew Block, Eric D. Schabell"
PROJECT="git@github.com:eschabell/cdk-install-demo.git"
PRODUCT="JBoss Fuse, Container Development Kit, OpenShift"
CDK_HOME=./target
SRC_DIR=./installs
SUPPORT_DIR=./support
PRJ_DIR=./projects
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
echo "##  Setting up the ${DEMO}                          ##"
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
echo "##  brought to you by ${AUTHORS}         ##"
echo "##                                                                       ##"   
echo "##  ${PROJECT}            ##"
echo "##                                                                       ##"   
echo "###########################################################################"
echo

# Ensure Vagrant avaiable.
#
command -v vagrant -v >/dev/null 2>&1 || { echo >&2 "Vagrant is required but not installed yet... download here: https://www.vagrantup.com/downloads.html"; exit 1; }
echo "Vagrant is installed..."
echo 

# Ensure VirtualBox available.
#
command -v VirtualBox -h >/dev/null 2>&1 || { echo >&2 "VirtualBox is required but not installed yet... downlaod here: https://www.virtualbox.org/wiki/Downloads"; exit 1; }
echo "VirtualBox is installed..."
echo

# Ensure CDK downloaded.
#
if [[ -r $SRC_DIR/$CDK ]] || [[ -L $SRC_DIR/$CDK ]]; then
	echo Product sources are present...
	echo
else
	echo Need to download $CDK package from the Customer Portal 
	echo and place it in the $SRC_DIR directory to proceed...
	echo
	exit
fi

# Ensure correct Vagrant box downloaded.
#
if [[ `uname` == 'Darwin' ]]; then
	# OSX Vagrant box.
	if [[ -r $SRC_DIR/$OSX_BOX ]] || [[ -L $SRC_DIR/$OSX_BOX ]]; then
		echo OSX Vagrant box present...
	  echo
  else
	  echo Need to download $OSX_BOX from the Customer Portal 
	  echo and place it in the $SRC_DIR directory to proceed...
	  echo
	  exit
  fi
else
	# Linux Vagrant box.
	if [[ -r $SRC_DIR/$LINUX_BOX ]] || [[ -L $SRC_DIR/$LINUX_BOX ]]; then
		echo Linux Vagrant box present...
	  echo
  else
	  echo Need to download $LINUX_BOX from the Customer Portal 
	  echo and place it in the $SRC_DIR directory to proceed...
	  echo
	  exit
  fi
fi

# Remove the old insallation, if it exists.
#
if [[ -x $CDK_HOME ]]; then
	echo "  - removing existing installation..."
	echo
	rm -rf $CDK_HOME
fi

# Run installation.
#
echo "Setting up installation now..."
echo
mkdir $CDK_HOME
unzip -q $SRC_DIR/$CDK -d $CDK_HOME

# Add memory adjusted Vagrantfile for OSE image.
#
echo "Copying over VagrantFile with rhel-ose larger memory settings..."
echo
cp $SUPPORT_DIR/$VAGRANTFILE $CDK_HOME/cdk/components/rhel/rhel-ose/Vagrantfile

echo "Installing some Vagrant plugins..."
echo
cd $CDK_PLUGINS_DIR
vagrant plugin install vagrant-registration vagrant-service-manager

echo
echo "Checking that plugins installed, looking for:"
echo 
echo "  -> vagrant-registration"
echo "  -> vagrant-service-manager"
echo
vagrant plugin list

# determine which Vagrant box to add.
#
cd ../../../
if [[ `uname` == 'Darwin' ]]; then
	# OSX Vagrant box.
	echo
  echo "Adding the RHEL Vagrant box..."
  echo
  vagrant box add --name $CDK_BOX_VERSION $SRC_DIR/$OSX_BOX
else 
	# Linux Vagrant box.
	#
	echo
  echo "Adding the libvirt Vagrant box..."
  echo
  vagrant box add --name $CDK_BOX_VERSION $SRC_DIR/$LINUX_BOX
fi

if [ $? -ne 0 ]; then
  echo
  echo "Detected a previous installation of this demo..."
  echo
	echo "Cleaning out previous Vagrant box $CDK_BOX_VERSION entry..."
	echo
	vagrant box remove $CDK_BOX_VERSION

	echo 
  echo "Cleanup done, re-trying the installation."
  echo
	if [[ `uname` == 'Darwin' ]]; then
		# OSX Vagrant box.
	  echo
    echo "Adding the RHEL Vagrant box..."
    echo
    vagrant box add --name $CDK_BOX_VERSION $SRC_DIR/$OSX_BOX
  else 
	  # Linux Vagrant box.
	  echo
    echo "Adding the libvirt Vagrant box..."
    echo
    vagrant box add --name $CDK_BOX_VERSION $SRC_DIR/$LINUX_BOX
  fi
fi

echo
echo "Checking that $CDK_BOX_VERSION is listed..."
echo
vagrant box list


echo 
echo "Start up OpenShift"
echo
cd $CDK_HOME/cdk/components/rhel/rhel-ose
vagrant up

# Start adding application related projects
cd ../../../../..

echo
echo "Login to OpenShfit"
echo
oc login -u admin -p admin

echo
echo "Creating new project called demo"
echo
oc new-project demo

echo
echo "Add AMQ template"
echo
oc create -f https://raw.githubusercontent.com/jboss-openshift/application-templates/master/amq/amq62-basic.json


echo
echo "Install AMQ"
echo
oc create -f $SUPPORT_DIR/amq.json

echo
echo "Install Healthcare web php application"
echo 
oc new-app --image-stream=openshift/php:latest --name=heathcareweb --code=https://github.com/weimeilin79/healthcareweb.git

echo
echo "========================================================================="
echo "=                                                                       ="
echo "=  Now you can start build and deploy JBoss Fuse Camel services         ="
echo "=  Under project directory ./projects/healthcaredemo                    ="
echo "=                                                                       ="
echo "=     $ mvn -Pf8-local-deploy                                           ="
echo "=                                                                       ="
echo "=  After projects are depolyed, we want to create two extra services    ="
echo "=                                                                       ="
echo "=     $ oc create -f support/clinichl7service.json                      ="
echo "=     $ oc create -f support/labrestservice.json                        ="
echo "=                                                                       ="
echo "=  Also expose a new route for the Lab Rest API Service                 ="
echo "=                                                                       ="
echo "=     $ oc create -f support/labrestapi.json                            ="
echo "=                                                                       ="
echo "=  Login to OpenShift console with USERNAME/PWD admin/admin             ="
echo "=                                                                       ="
echo "=     https://10.1.2.2:8443/console/                                    ="
echo "=                                                                       ="
echo "=                                                                       ="
echo "=  Finally, start playing with the demo by registering your info        ="
echo "=                                                                       ="
echo "=     http://healthcareweb-demo.rhel-cdk.10.1.2.2.xip.io/health.html    ="
echo "=                                                                       ="
echo "=  This completes the $DEMO setup.                           ="
echo "=                                                                       ="
echo "========================================================================="
echo                                                                    

