# gcp-serverless-firestore Deployment Framework

## Overview

The `gcp-serverless-firestore` Terraform framework is a modular, reusable infrastructure-as-code solution designed to deploy serverless applications to Google Cloud Platform (GCP) with Firestore as a backend. Its primary goal is to simplify the deployment of any app—whether static sites, Node.js/Express servers, or other serverless workloads—by providing a standardized structure that’s loosely coupled and adaptable to diverse project needs. 

### Key Features
- **Loosely Coupled Design**: The framework separates root-level infrastructure (e.g., project setup, APIs) from app-specific configurations, allowing independent app deployments under a shared Terraform root. Apps reside in the `apps/` directory, each with its own `main.tf`, `variables.tf`, and `outputs.tf`, enabling flexibility and scalability.
- **Deployment Goals**: 
  - Deploy apps to Cloud Run for serverless execution.
  - Integrate Firestore for lightweight, scalable data storage.
  - Support public or restricted access with configurable IAM policies.
  - Minimize manual GCP configuration through automation.
- **Universal Applicability**: Suitable for static sites (e.g., Nginx-based) or dynamic apps (e.g., Node.js/Express), with extensibility for future enhancements like API endpoints or additional services.

### Project Structure
```
gcp-serverless-firestore/
├── apps/
│   ├── app1/                    # Example app (e.g., BJJ Game Builder)
│   │   ├── src/                 # Source files
│   │   │   ├── index.html       # Main HTML
│   │   │   ├── styles.css       # CSS stylesheet
│   │   │   └── app.js           # JavaScript
│   │   ├── main.tf             # App-specific Terraform configuration
│   │   ├── variables.tf         # App-specific variables
│   │   └── outputs.tf           # App-specific outputs (e.g., service URL)
│   └── app2/                    # Placeholder for another app
│       ├── src/                 # Source files
│       │   ├── index.html       # Placeholder HTML
│       │   ├── styles.css       # Placeholder CSS
│       │   └── app.js           # Placeholder JS
│       ├── main.tf             # App-specific Terraform
│       ├── variables.tf         # App-specific variables
│       └── outputs.tf           # App-specific outputs
├── terraform/
│   ├── provider.tf              # GCP provider configuration
│   ├── variables.tf             # Root-level variables (e.g., project ID)
│   ├── outputs.tf               # Root-level outputs
│   ├── main.tf                  # Root-level resources (e.g., APIs, dummy bucket)
│   └── terraform.tfvars         # Root variable values (e.g., billing account)
├── docs/
│   └── README.md                # This documentation
└── test/
    └── test_data.json           # Example test data (e.g., for app1)
```

---

## Prerequisites

1. **Install Tools**:
   - **Terraform**:
     - Verify: `terraform -v`
     - Install: Download from [terraform.io](https://www.terraform.io/downloads.html) and follow OS-specific instructions.
   - **gcloud CLI**:
     - Verify: `gcloud --version`
     - Install: Follow [Google Cloud SDK instructions](https://cloud.google.com/sdk/docs/install).
   - **Docker**:
     - **macOS**:
       - Remove CLI-only install if present: `brew uninstall docker`
       - Install Docker Desktop: `brew install --cask docker`
       - Start: `open -a Docker` (wait for green icon in menu bar)
       - Verify: `docker ps`
       - Authenticate: `gcloud auth configure-docker`
     - **Linux (Ubuntu/Debian - apt)**:
       - Install: 
         ```bash
         sudo apt update
         sudo apt install -y docker.io
         sudo systemctl start docker
         sudo systemctl enable docker
         ```
       - Add user to docker group (optional): `sudo usermod -aG docker $USER` (log out/in)
       - Verify: `docker ps`
       - Authenticate: `gcloud auth configure-docker`
     - **Linux (CentOS/RHEL - yum)**:
       - Install:
         ```bash
         sudo yum install -y yum-utils
         sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
         sudo yum install -y docker-ce docker-ce-cli containerd.io
         sudo systemctl start docker
         sudo systemctl enable docker
         ```
       - Add user to docker group (optional): `sudo usermod -aG docker $USER` (log out/in)
       - Verify: `docker ps`
       - Authenticate: `gcloud auth configure-docker`

2. **Authenticate gcloud**:
   - Initialize: `gcloud init` (set project, region, account)
   - Authenticate ADC: `gcloud auth application-default login`
   - Alternative: Use a service account key (`export GOOGLE_APPLICATION_CREDENTIALS=~/gcp-credentials.json`).

3. **Gather GCP Details**:
   - In GCP Console:
     - Organization ID: IAM & Admin > Settings (optional if standalone project).
     - Billing Account ID: Billing.
     - Project ID: Create or select a project in the Console.

---

## Deployment Steps

1. **Clone the Deployment Repository**:
   ```bash
   git clone <repository-url>
   cd gcp-serverless-firestore
   mkdir -p apps/<app-name> terraform docs test
   ```
   - Replace `<repository-url>` with your repo (e.g., `git@github.com:user/gcp-serverless-firestore.git`).
   - Creates directories for app-specific configs and root Terraform.

2. **Set Up Root Terraform**:
   - **Configure Variables**: Update `terraform/variables.tf` and `terraform/terraform.tfvars` with your project ID, region, and billing account.
   - **Initialize and Apply**:
     ```bash
     cd terraform
     terraform init
     terraform apply
     ```
   - Enables required APIs (Storage, Cloud Run, Container Registry, Firestore) and sets up a dummy bucket for provider context.

3. **Configure App Deployment**:
   - **Structure App Directory**: Under `apps/<app-name>/`, place:
     - `src/`: App source files (e.g., `index.html`, `styles.css`, `app.js` for static; or `server.js`, `package.json`, `public/` for Node.js).
     - `main.tf`, `variables.tf`, `outputs.tf`: App-specific Terraform configs.
   - **Set `app_source_path`**: In `variables.tf`, define the path to `src/` (e.g., `default = "../../../<app-name>"`).
   - **Dockerfile**: Match app type:
     - Static: `FROM nginx:alpine`, `COPY . /usr/share/nginx/html`.
     - Node.js: `FROM node:16`, `COPY package*.json ./`, `RUN npm install`, `COPY . .`, `CMD ["npm", "start"]`.

4. **Deploy the App**:
   ```bash
   cd apps/<app-name>
   terraform init  # Run or re-run if context changes (e.g., org to standalone)
   terraform apply
   ```
   - **Troubleshooting**:
     - **Path Errors**: Verify `app_source_path` with `ls <path>`; adjust or use `-var "app_source_path=/absolute/path"`.
     - **Docker Issues**: Ensure daemon runs (`docker ps`), authenticate (`gcloud auth configure-docker`).
     - **IAM Errors**: Check policies (`gcloud resource-manager org-policies list --project=<project-id>`), re-run `terraform init` if context shifts, or manually set IAM in Console (Cloud Run > Permissions > Add `allUsers` as `Cloud Run Invoker`).

5. **Verify**:
   - Output URL: `terraform output service_url`
   - Test in a browser (use incognito for public access).

---

## Cleanup
```bash
cd apps/<app-name>
terraform destroy
cd ../../terraform
terraform destroy
```
- Removes app-specific and root-level resources.

---

## Running List of gcloud CLI Commands
1. `gcloud init`
   - **Purpose**: Initializes gcloud configuration, setting project, region, and account.

2. `gcloud auth application-default login`
   - **Purpose**: Authenticates Application Default Credentials for Terraform.

3. `gcloud config list`
   - **Purpose**: Displays current gcloud configuration (project, region, account).

4. `gcloud config set project <project-id>`
   - **Purpose**: Sets the active project explicitly (e.g., `cs-poc-tp17yolgfvyfmwfyqilqcnq`).

5. `gcloud config set compute/region us-central1`
   - **Purpose**: Sets the default compute region (prompts to enable Compute API if needed).

6. `gcloud auth application-default revoke`
   - **Purpose**: Revokes existing ADC to clear stale credentials.

7. `gcloud auth application-default print-access-token`
   - **Purpose**: Prints the ADC access token to verify authentication.

8. `gcloud projects get-iam-policy <project-id>`
   - **Purpose**: Retrieves IAM policy for the project to check user roles (e.g., `cs-poc-tp17yolgfvyfmwfyqilqcnq`).

9. `gcloud services list --project <project-id>`
   - **Purpose**: Lists enabled APIs in the project.

10. `gcloud services enable storage.googleapis.com --project <project-id>`
    - **Purpose**: Enables Cloud Storage API manually.

11. `gcloud services enable run.googleapis.com --project <project-id>`
    - **Purpose**: Enables Cloud Run API manually.

12. `gcloud services enable containerregistry.googleapis.com --project <project-id>`
    - **Purpose**: Enables Container Registry API manually.

13. `gcloud services enable firestore.googleapis.com --project <project-id>`
    - **Purpose**: Enables Firestore API manually.

14. `gcloud org-policies list --organization=<org-id> --filter="constraint:iam.allowedPolicyMemberDomains"`
    - **Purpose**: Lists organization policies to check `iam.allowedPolicyMemberDomains` (e.g., `502508248195`).

15. `gcloud organizations list`
    - **Purpose**: Lists organizations to retrieve `DIRECTORY_CUSTOMER_ID` (e.g., `C038i6cbc`).

16. `gcloud org-policies set-policy <policy-file>.yaml`
    - **Purpose**: Applies an organization policy (e.g., conditional `allUsers` with tags).

17. `gcloud auth configure-docker`
    - **Purpose**: Authenticates Docker with Google Container Registry.

18. `gcloud organizations get-iam-policy <org-id> --filter="bindings.members:<user-email>"`
    - **Purpose**: Checks IAM policy at the organization level for user roles (e.g., `502508248195`, `rory@optcl.ai`).

19. `gcloud resource-manager tags keys create public-access --parent=organizations/<org-id> --description="Allow public access to tagged resources"`
    - **Purpose**: Creates a tag key for conditional public access policy (e.g., `502508248195`).

20. `gcloud resource-manager tags values create true --parent=tagKeys/public-access --description="True value for public access"`
    - **Purpose**: Creates a tag value under the `public-access` key.

21. `gcloud resource-manager tags bindings create --tag-value=<org-id>/public-access/true --parent=//run.googleapis.com/projects/<project-id>/locations/us-central1/services/<app-name> --location=us-central1`
    - **Purpose**: Tags a Cloud Run service to allow public access (e.g., `<project-id>`=`cs-poc-tp17yolgfvyfmwfyqilqcnq`, `<app-name>`=`app1`).

22. `gcloud organizations add-iam-policy-binding <org-id> --member="user:<user-email>" --role="roles/resourcemanager.tagAdmin"`
    - **Purpose**: Grants `tagAdmin` role to create tags at the org level (e.g., `502508248195`, `rory@optcl.ai`).

23. `gcloud org-policies describe iam.allowedPolicyMemberDomains --organization=<org-id>`
    - **Purpose**: Retrieves detailed `iam.allowedPolicyMemberDomains` policy for an organization (e.g., `502508248195`).

24. `gcloud org-policies list --organization=<org-id>`
    - **Purpose**: Lists all organization policies to identify constraints (e.g., `502508248195`).

25. `gcloud resource-manager org-policies list --project=<project-id>`
    - **Purpose**: Lists project-level organization policies to check for standalone constraints (e.g., `cs-poc-tp17yolgfvyfmwfyqilqcnq`).

26. `gcloud resource-manager org-policies set-policy project-policy.yaml`
    - **Purpose**: Sets a project-level policy to allow all IAM members temporarily.

27. `gcloud resource-manager org-policies describe iam.allowedPolicyMemberDomains --project=<project-id>`
    - **Purpose**: Retrieves detailed project-level `iam.allowedPolicyMemberDomains` policy to confirm settings (e.g., `cs-poc-tp17yolgfvyfmwfyqilqcnq`).

28. `gcloud projects describe <project-id>`
    - **Purpose**: Describes project details to check for parent resources (e.g., folder/org) (e.g., `cs-poc-tp17yolgfvyfmwfyqilqcnq`).
```

---

## Future Tasks
- **Enhance Root Outputs**: Add API statuses or additional metadata for better automation.
- **Node.js/Express Enhancements**: Extend apps with API endpoints or Firestore integration post-deployment.

---

### Commentary and Lessons Learned
- **Context Refresh**: Use `terraform init` when switching between organization-managed and standalone projects to update provider state.
- **Policy Propagation**: Allow 5-15 minutes for IAM or org policy changes to take effect; verify with `gcloud` commands.
- **Standalone Projects**: Check project parentage (`gcloud projects describe`) and policies (`gcloud resource-manager org-policies list`) early to avoid org-related assumptions.
- **Console Fallback**: Use the GCP Console for IAM or policy updates if CLI permissions stall, ensuring Terraform aligns with manual changes via `apply`.

This framework empowers rapid, repeatable serverless deployments—adapt `apps/<app-name>/` for your next project and go!
