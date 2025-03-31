Deployment Overview:

Deployment with GCP Serverless Firestore Project:
gcp-serverless-firestore/
├── apps/
│   ├── app1/                    # BJJ Game Builder
│   │   ├── src/                 # Source files (version 1.1.004)
│   │   │   ├── index.html       # Main HTML
│   │   │   ├── styles.css       # CSS
│   │   │   └── app.js           # JavaScript
│   │   ├── main.tf             # App-specific Terraform
│   │   ├── variables.tf         # App-specific variables
│   │   └── outputs.tf           # App-specific outputs
│   └── app2/                    # New app (placeholder)
│       ├── src/                 # Source files for app2
│       │   ├── index.html       # Placeholder HTML
│       │   ├── styles.css       # Placeholder CSS
│       │   └── app.js           # Placeholder JS
│       ├── main.tf             # App-specific Terraform
│       ├── variables.tf         # App-specific variables
│       └── outputs.tf           # App-specific outputs
├── terraform/
│   ├── provider.tf              # Root GCP provider (your file)
│   ├── variables.tf             # Root variables (your file)
│   ├── outputs.tf               # Root outputs (your file)
│   ├── main.tf                  # Root-level resources (e.g., VPC)
│   └── terraform.tfvars         # Root variable values
├── docs/
│   └── README.md                # Project overview
└── test/
    └── test_bjj_data_1.1.004.json # Test data for app1



* Step 1: Set Up Your Local Environment

# Universal Deployment Steps for gcp-serverless-firestore

## Prerequisites
1. **Install Tools**:
   - Terraform: `terraform -v`
   - gcloud CLI: `gcloud --version`
   - Docker: `docker --version`

2. **Authenticate gcloud**:
   ```bash
   gcloud init
   gcloud auth application-default login


    Install Terraform:
        Verify with terraform -v. Install from terraform.io if needed.
    Authenticate with GCP:
        Run gcloud auth application-default login 
        OR use a service account key (e.g., export GOOGLE_APPLICATION_CREDENTIALS=~/gcp-credentials.json).
    Gather Organization Details:
        In GCP Console, get your Organization ID (IAM & Admin > Settings) and Billing Account ID (Billing).
    Clone the Deployment Repo:
      git clone git@github.com:rorys32/gcp-serverless-firestore.git
      cd gcp-serverless-firestore
      mkdir -p apps/app1 terraform docs test


# GCP obtain Organization ID organization_id and billing_account_id
# GCP Establish Project
# GCP Get Project ID
# Update variables.tf global config

# gcloud init
# gcloud config list

## Universal Deployment Steps for gcp-serverless-firestore

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
       - Install Docker Desktop via Homebrew:
         ```bash
         brew install --cask docker

# Start Docker Desktop
open -a Docker

# Authenticate with Google Container Registry
gcloud auth configure-docker

Linux Ubuntu/Debian Install Docker:
sudo apt update
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Add Docker to group to run without SUDO
sudo usermod -aG docker $USER
# Log out and back in



