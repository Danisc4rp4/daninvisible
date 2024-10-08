# daninvisible

## Requirements

Create a GCP account with a project called "cicd", and an environment in Githubactions with the same name. Set the GOOGLE_PROJECT_ID as a variable in the Github Actions environment cicd. Create 2 Buckets in your GCP account, "$GOOGLE_PROJECT_ID-tfstate" and "$GOOGLE_PROJECT_ID-infra".

Create a Service Account called "githubactions" with roles:
Compute Security Admin
Create Service Accounts
Delete Service Accounts
Githubactions Custom
Instance Group Manager Service Agent
Kubernetes Engine Admin
Kubernetes Engine Cluster Admin
Role Administrator
Service Account User
Storage Admin
Storage Object Admin

Create a new "cicd" role to attach to the gothubactions SA, with the following permissions:
compute.instanceGroupManagers.get
container.customResourceDefinitions.create
container.customResourceDefinitions.update
resourcemanager.projects.setIamPolicy

Create a new key, select JSON type. Copy the downloaded file, and paste it into Gitlab Settings Actions Secrets.

Create a Personal access Token on Github. Click on your user icon, then Settings, then Developer settings, Personal Access Tokens. Add the token as a secret into the env cicd of Github Actions GITHUB_TOKEN variable.

Set the env vars GOOGLE_PROJECT_ID, PRIMARY_IP_CIDR, 

Create a second environment called daninvisible.me. This environment will deploy a second cluster without flux in a second project, daninvisible-me. The Service Account githubactions creation is needed also here. The cicd cluster will deploy into daninvisible.me (production cluster).




## Flux Deployment

The new repository called Danisc4rp4/flux is created. This is going to be the content of the main cluster. Modify this repo to add resources to Kubernetes.

It is enough to work on the flux repo to deploy resources into all clusters. Please note that flux is the repo that this cluster uses to update and deploy itself but also other clusters (i.e. [daninvisible.me](https://github.com/Danisc4rp4/daninvisible.me)).


