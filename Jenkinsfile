#!groovy

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


node {
   try {
     // Clang chokes on %2f in the directory, set manually in the workspace.
     ws(getWorkspace()) {
       wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm', 'defaultFg': 1, 'defaultBg': 2]) {
         workspace = pwd()

         // Wipe the workspace so we are building completely clean
         wipeWorkspace(workspace) 

           stage: ‘Best Place’
	        sh ‘echo $path’
	       
       }
    }
  } catch (e) {
    throw e
  }
}
