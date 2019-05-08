# Update process
In order to execute the update process
1. 'cd' into this directory
1. run `./update.sh`: this will first pull a new version of the ODK; then it will run the seed-via-docker.sh script which has two subparts (1) Copying all the new ODK files into a new subdirectory called 'target/wbphenotype' (2) Trying to run a first release. **Since we do not need (2) you can interrupt the process (Ctrl+C) once it says 
```RUNNING: cd target/wbphenotype/src/ontology && make && git commit -m 'initial commit' -a && make prepare_initial_release && git commit -m 'first release'```
1. run syncfiles.sh
