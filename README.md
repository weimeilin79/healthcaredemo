FIS Healthcare DEMO
======================================

Healthcare information system are complex and problem comes from dealing with specific formats in healthcare industry it is highly complex, with multiple hierarchy and meanings,
and that's not all there are more then one formats around. 
Beside the data format issue, the number of entities or system in healthcare are enormous, how do we make sure our HIS stays agile, lean, but at the same time integrating with all the necessary parties 
and ensures security, modularity of services and flexibility. 
Here is an example demo that shows how to achieve this with JBoss Fuse on OpenShift. 

In this demo, we will be simulating Four different departments that are typically in hospital. 

- Registration
- Clinic
- Laboratory
- Radiology 

And a party that is very common outside the hospital itself, 

- Pharmacy

You will get to see 
	- how to build microservice for each departments, 
	- how to handle HL7, FHIR dataformat, 
	- how to build a robust architecture,
	- how to talk in different protocol 
Through a normal medical visit in the demo.  



Installation
----------------------------------
Make sure you have installed Vagrant and Virtual box. run init.sh to setup CDK and web services
    
    $ ./init.sh

Under project directory ./projects/healthcaredemo
                                                                      
    $ mvn -Pf8-local-deploy


After projects are depolyed, go back to the demo root directory (where the init.sh is) we want to create two extra services

    $ oc create -f support/clinichl7service.json                      
    $ oc create -f support/labrestservice.json

Also expose a new route for the Lab Rest API Service                 

    $ oc create -f support/labrestapi.json                            
    

Install GUI page and frontend for healthcare install 
	
		$ oc new-app --image-stream=openshift/php:5.5 --name=healthcareweb --code=https://github.com/weimeilin79/healthcareweb.git

Install GUI page and frontend for healthcare install
		
		$ oc create -f support/healthwebroute.json                       

Login to OpenShift console with USERNAME/PWD admin/admin             

    https://10.1.2.2:8443/console/                                    


Finally, start playing with the demo by registering your info        

    http://healthcareweb-demo.rhel-cdk.10.1.2.2.xip.io/health.html
    
 
Running the demo
----------------------------------
Now, imagine you are working in a clinic or a hospital, you work in registration, a patient comes in, so first thing you will have to do is to register this patient, 
So type in patients' family name and first name, then enter an unqiue HIS number. 

This registration information will then pass on and notify all departments in the medical center, there are two things here, 
we need to kwon where to send the registration information and since the registration system only generates HL7 data, we need some how to interpret it.  

Supporting Articles
