# daninvisible

## Requirements

Create a GCP account with a project called "cicd". Set the GOOGLE_PROJECT_ID in the Github Actions Variables. Create 2 Buckets in your GCP account, "$GOOGLE_PROJECT_ID-tfstate" and "$GOOGLE_PROJECT_ID-infra".
Create a Service Account called "githubactions" with roles "Storage Admin", "Storage Object Admin", "Service Account User", "Compute Network Admin". Create a new key, select JSON type. Copy the downloaded file, and paste it into Gitlab Settings Actions Secrets.

## Local

Execute these commands on a Macbook (sorry!)

export GOOGLE_CREDENTIALS="$(cat ~/Downloads/GOOGLE_PROJECT_ID-xxxxxx.json)"
echo $(sed -e "s/GOOGLE_PROJECT_ID/${GOOGLE_PROJECT_ID}/g" providers.tf)
sed -e "s/GOOGLE_PROJECT_ID/${GOOGLE_PROJECT_ID}/g" terraform.tfvars
terraform init


BE CAREFUL HERE!!!
I am discarding the changes that we made to the files. Do not be silly :D

git restore providers.tf terraform.tfvars


