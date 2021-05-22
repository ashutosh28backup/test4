#!groovy
import groovy.json.JsonSlurperClassic
node {

    def BUILD_NUMBER=env.BUILD_NUMBER
    def RUN_ARTIFACT_DIR="tests/${BUILD_NUMBER}"
    def SFDC_USERNAME

    def HUB_ORG=env.HUB_ORG_DH
    def SFDC_HOST = env.SFDC_HOST_DH
    def JWT_KEY_CRED_ID = env.JWT_CRED_ID_DH
    def CONNECTED_APP_CONSUMER_KEY=env.CONNECTED_APP_CONSUMER_KEY_DH
	
	
    println 'KEY IS' 
    println JWT_KEY_CRED_ID
    println HUB_ORG
    println SFDC_HOST
    println CONNECTED_APP_CONSUMER_KEY
    def toolbelt = tool 'toolbelt'

    stage('checkout source') {
        // when running in multi-branch job, one must issue this command
        checkout scm
    }
	

//	Static code analysis		
	stage('Static Code Analysis') {
	SCA=bat returnStatus: true, script: "\"${toolbelt}\" scanner:run --target=\"C:\\WINDOWS\system32\\config\\systemprofile\\AppData\\Local\\Jenkins\\.jenkins\\workspace\\ashu3_\\force-app\" --outfile=sfdxscanner1.html --format=html"
	
	println('SCA=')
	println(SCA)
		
	if (SCA != 0) { error 'Issues found in code scan' }
	else{
		println ('No major issues found in code scan')
	    }
	
	}
	
//	Authorizing SFDX for the environment	
	withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
        stage('Authorization') {
                 rc = bat returnStatus: true, script: "\"${toolbelt}\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile \"${jwt_key_file}\" --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
            
            if (rc != 0) { error 'hub org authorization failed' }
		else{ println('Environment Authorized successfully')}
	}
	}

		
//	deployment validation running on Windows machine
	stage('deployment validation') {
	dv = bat returnStatus: true, script: "\"${toolbelt}\" force:source:deploy -u ${HUB_ORG} -m ApexClass -l RunAllTestsInOrg -c"
	if (dv != 0) { error 'Deployment Validation failed' }
	else{
		println ('Deployment validtaion succeeded')}

	}

		
		
// 	Doing deployment from Windows machine
	stage('deployment to Environment') {

	rmsg = bat returnStatus: true, script: "\"${toolbelt}\" force:source:deploy -u ${HUB_ORG} -x manifest/package.xml -w 60"
	if (rmsg != 0) { error 'Deployment Validation failed' }
	else{
		println ('Deployment succeeded')}
			}
        }

