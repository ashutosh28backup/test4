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
	
	def Jenkinsbuildpath = "C:\\Windows\\System32\\config\\systemprofile\\AppData\\Local\\Jenkins\\.jenkins\\workspace\\jenkinsdev_\\force-app\\main\\default\\classes"
	def Reportfile = "C:\\Windows\\System32\\config\\systemprofile\\AppData\\Local\\Jenkins\\.jenkins\\workspace\\pmdreports\\report1.html"
	def apexrule = "category/apex/design.xml"
	
	println(SFDC_HOST)
	println(Reportfile)
	println(Jenkinsbuildpath)
	println(apexrule)

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
	
	
	withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
        stage('Deploye Code') {
            if (isUnix()) {
		//    export SFDX_USE_GENERIC_UNIX_KEYCHAIN=true
		k1=sh returnStatus: true, script: "export SFDX_USE_GENERIC_UNIX_KEYCHAIN=true"
		println ('k1=')	
		println k1
                rc = sh returnStatus: true, script: "${toolbelt} force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"

            }else{
                 rc = bat returnStatus: true, script: "\"${toolbelt}\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile \"${jwt_key_file}\" --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
            }
            if (rc != 0) { error 'hub org authorization failed' }

//	Doing Static code analysis		
	stage('Static Code Analysis') {
	SCA=bat returnStatus: true, script: "\"${toolbelt}\" sfdx scanner:run --target=.\force-app --outfile=sfdxscanner1.html --format=html"
	println('SCA=')
	println(SCA)
		
	if (SCA != 0) { error 'Issues found in code scan' }
	else{
		println ('No major issues found in code scan')
	    }
	
	}	


		
//	deployment validation running on Windows machine
	stage('deployment validation') {
	dv = bat returnStatus: true, script: "\"${toolbelt}\" force:source:deploy -u ${HUB_ORG} -m ApexClass -l RunAllTestsInOrg -c"
	println('dv=')
	println(dv)
	if (dv != 0) { error 'Deployment Validation failed' }
	else{
		println ('Deployment validtaion succeeded')}

	}

		
		
		
// 	Doing deployment on Windows machine
			if (isUnix()) {
				rmsg = sh returnStdout: true, script: "${toolbelt} force:source:deploy -u ${HUB_ORG} -p force-app -w 60"
			}else{
				println ('in Win')
			        rmsg = bat returnStatus: true, script: "\"${toolbelt}\" force:source:deploy -u ${HUB_ORG} -x manifest/package.xml -w 60"
							
				
			}
			  
            println ( 'rmsg=')
            //println('Hello from a Job DSL script!')
            println(rmsg)
        }
    }
}
