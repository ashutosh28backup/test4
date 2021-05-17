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

//    def SFDX_USE_GENERIC_UNIX_KEYCHAIN = true
	
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
	
//	
    withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
        stage('Deploye Code') {
            if (isUnix()) {
		//    export SFDX_USE_GENERIC_UNIX_KEYCHAIN=true
		k1=sh returnStatus: true, script: "export SFDX_USE_GENERIC_UNIX_KEYCHAIN=true"
		println ('k1=')	
		println k1
                rc = sh returnStatus: true, script: "${toolbelt} force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
//		    rc = sh returnStatus: true, script: "${toolbelt} force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile /home/ec2-user/keys_2/server.key --instanceurl ${SFDC_HOST}"
            }else{
                 rc = bat returnStatus: true, script: "\"${toolbelt}\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile \"${jwt_key_file}\" --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
            }
            if (rc != 0) { error 'hub org authorization failed' }

		println ('Ashutosh')	
		println rc
			
// deployment validation for windows only
//	stage('deployment validation') {
	dv = bat returnStdout: true, script: "\"${toolbelt}\" force:source:deploy -u ${HUB_ORG} -x manifest/package.xml -c"

	if (dv != 0) { error 'Deployment Validation failed' }

//	}

		
		
		
			// need to pull out assigned username
			if (isUnix()) {
				rmsg = sh returnStdout: true, script: "${toolbelt} force:source:deploy -u ${HUB_ORG} -p force-app -w 60"
			}else{
				println ('in Win')
			   //rmsg = bat returnStdout: true, script: "\"${toolbelt}\" force:source:deploy -u ${HUB_ORG} -p force-app -w 60"
				//rmsg = bat returnStdout: true, script: "\"${toolbelt}\" force:source:deploy -u ${HUB_ORG} -p force-app/main -w 60"
				rmsg = bat returnStdout: true, script: "\"${toolbelt}\" force:source:deploy -u ${HUB_ORG} -x manifest/package.xml -w 60"
			}
			  
            printf rmsg
            println('Hello from a Job DSL script!')
            println(rmsg)
        }
    }
}
