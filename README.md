# daninvisible

## Requirements

Create a GCP account with a project called "cicd". Set the GOOGLE_PROJECT_ID in the Github Actions Variables. Create 2 Buckets in your GCP account, "$GOOGLE_PROJECT_ID-tfstate" and "$GOOGLE_PROJECT_ID-infra".

Create a Service Account called "githubactions" with roles "Storage Admin", "Storage Object Admin", "Service Account User", "Compute Network Admin", "Compute Security Admin".
Create a new "cicd" role to attach to the gothubactions SA, with the following permissions.

compute.instanceGroupManagers.get
container.customResourceDefinitions.create
container.customResourceDefinitions.update
resourcemanager.projects.setIamPolicy

Create a new key, select JSON type. Copy the downloaded file, and paste it into Gitlab Settings Actions Secrets.

Create a Personal access Token on Github. Click on your user icon, then Settings, then Developer settings, Perspnal Access Tokens. Save the value in GCP Secrets Manager as "github".


## Flux Deployment

The new repository called Danisc4rp4/flux is created. This is going to be the content of the main cluster. Modify this repo to add resources to Kubernetes.

It is enough to work on the flux repo to deploy resources into all clusters. Please note that flux is the repo that this cluster uses to update and deploy itself but also other clusters (i.e. [daninvisible.me](https://github.com/Danisc4rp4/daninvisible.me))
