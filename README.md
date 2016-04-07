FIS Healthcare DEMO
======================================




Installation
----------------------------------
Under project directory ./projects/healthcaredemo
                                                                      
    $ mvn -Pf8-local-deploy

After projects are depolyed, we want to create two extra services

    $ oc create -f support/clinichl7service.json                      
    $ oc create -f support/labrestservice.json

Also expose a new route for the Lab Rest API Service                 

    $ oc create -f support/labrestapi.json                            

Login to OpenShift console with USERNAME/PWD admin/admin             

    https://10.1.2.2:8443/console/                                    


Finally, start playing with the demo by registering your info        

    http://healthcareweb-demo.rhel-cdk.10.1.2.2.xip.io/health.html
    
 

Supporting Articles
