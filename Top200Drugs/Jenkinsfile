#!groovy

env.PATH = '/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/Server.app/Contents/ServerRoot/usr/bin:/Applications/Server.app/Contents/ServerRoot/usr/sbin:$PATH’
env.HOME = '/Users/build'
env.USER = 'build’

// backwards compat with old branch variable
env.GIT_BRANCH = env.BRANCH_NAME


// Jenkins by default will attempt to escape any slashes by replacing them with %2f, confusing build tools
// we get around this by replacing any slash that is used with an underscore.   (source Matt Hamilton, 
def getWorkspace() {
    pwd().replace("%2F", "_")
}

// Just in case of any failed builds, or compat issues we wipe the workspace to start anew.

def wipeWorkspace(String workspace) {
    if (workspace) {
        sh "find ${workspace} -mindepth 4 -depth -delete"
    }
}

// TODO - Release builds treated differently than Alpha and Prod

def isRelease() {
    if (env.RELEASE == "true") {
      return true
    }
}


node(‘macJenkins-1’) {
   try {
     // Clang chokes on %2f in the directory, set manually in the workspace.
     ws(getWorkspace()) {
       wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm', 'defaultFg': 1, 'defaultBg': 2]) {
         workspace = pwd()

         // Wipe the workspace so we are building completely clean
         wipeWorkspace(workspace) 

         stage 'Checkout'
         // Checkout code from repository
         checkout scm

         // Mark the cocoapods 'stage'....

         stage 'Cocoapods Install'
	  sh ‘make bootstrap’
		sh ‘bundle exec fastlane’
         // Mark the code unit tests 'stage'....

         stage 'Tests'

         // reset the simulators before running tests
         sh "killall Simulator || true"
         sh "SNAPSHOT_FORCE_DELETE=yes snapshot reset_simulators"
         sh "fastlane ios test”   

         step([$class: 'JUnitResultArchiver', testResults: 'build/reports/*.xml'])

         // Mark the code build 'stage'....
         stage 'Build'
         sh "security list-keychains -s ~/Library/Keychains/iosbuilds.keychain"
         sh "security unlock-keychain -p ${env.KEYCHAIN_PASSWORD} /Users/iosbuilds/Library/Keychains/iosbuilds.keychain"
         if (isRelease()) {
           sh "fastlane build_release"
         } else {
           sh "fastlane build_alpha"
         }

         // Mark the code deploy 'stage'....
         stage 'Deploy'
         if (isRelease()) {
           slackSend channel: '#ios', color: 'warning', message: "${env.JOB_NAME} (${env.BUILD_NUMBER}) waiting for confirmation to upload to Testflight.\n${env.BUILD_URL}"
           input 'Please confirm OK to deploy to Testflight?'
           sh "fastlane deploy_release"
         } else {
           sh "fastlane deploy_alpha"
         }
      }
    }
  } catch (e) {
    slackSend channel: '#ios', color: 'danger', message: ":dizzy_face: Build failed ${env.JOB_NAME} (${env.BUILD_NUMBER})\n${env.BUILD_URL}"
    throw e
  }
}
