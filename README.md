# Azure Front Door with Multiple Application Gateways
This project uses Terraform to deploy and configure an Azure Front Door (Standard/Premium SKU) to route traffic to multiple Application Gateways. This solution is designed for scenarios where you need a single global entry point for multiple applications, each hosted behind its own Application Gateway.
The project is structured into two main parts: a reusable module for the Front Door configuration and a deployment folder to provision the resources in a specific environment.
---
## Folder Structure
The project has a clear and modular structure:

.
├── deployment/
│   ├── main.tf                 # Calls the frontdoor module.
│   ├── variables.tf            # Declares variables for the deployment.
│   └── terraform.tfvars        # Provides values for all deployment variables.
└── frontdoor-module/
├── main.tf                 # Defines the Azure Front Door resources.
├── variables.tf            # Declares variables for the module.
├── outputs.tf              # Defines the module's outputs.
└── versions.tf             # Sets Terraform and provider versions.
---
## Features
* **Centralized Traffic Management:** Deploys a single Azure Front Door to manage multiple custom domains.
* **Backend Routing:** Routes traffic to distinct Application Gateways based on the incoming hostname.
* **Custom Domain Support:** Configures custom domains with HTTPS via Azure Key Vault integration.
* **Health Probes & Load Balancing:** Configures health probes and load balancing for backend Application Gateways.
* **Scalable and Reusable:** The core logic is encapsulated in a module, making it easy to reuse for other deployments.
---
## How to Use
### 1. Update Configuration
Before deploying, you must update the `deployment/terraform.tfvars` file with your specific details.
- **`resource_group_name`**: The name of your resource group.
- **`location`**: The Azure region for the deployment.
- **`frontdoor_name`**: A globally unique name for your Front Door profile.
- **`backends`**: Define your Application Gateways. The `host_header` must be a DNS name that resolves to your Application Gateway's public IP.
- **`backend_pool_settings`**: Define health probe and load balancing settings for each backend pool.
- **`frontend_endpoints`**: Define your custom domains and link them to Key Vault secrets for SSL certificates.
- **`routing_rules`**: This is the core mapping. It connects your `frontend_endpoints` to your `backend_pool_settings`.
### 2. Deployment
From the `deployment/` directory, run the following commands in order:
1.  **Initialize Terraform:** This command downloads the necessary provider and module.
   ```bash
   terraform init
   ```
2.  **Validate the Configuration:** (Optional, but recommended) This checks for any syntax errors.
   ```bash
   terraform validate
   ```
3.  **Generate a Plan:** This command shows you which resources will be created, updated, or destroyed.
   ```bash
   terraform plan
   ```
4.  **Apply the Configuration:** This command applies the plan and provisions the Azure resources.
   ```bash
   terraform apply
   ```
---
## Inputs
The following are the key variables defined in `deployment/terraform.tfvars`:
| Variable Name             | Description                                     | Type                       |
| ------------------------- | ----------------------------------------------- | -------------------------- |
| `resource_group_name`     | The name of the resource group.                 | `string`                   |
| `location`                | The Azure region.                               | `string`                   |
| `frontdoor_name`          | A globally unique name for the Front Door profile. | `string`                   |
| `backends`                | Map of Application Gateway details.             | `map(object)`              |
| `backend_pool_settings`   | Map of backend pool configurations.             | `map(object)`              |
| `frontend_endpoints`      | Map of custom domain settings.                  | `map(object)`              |
| `routing_rules`           | Map to define how frontends route to backends.  | `map(object)`              |
---
## Outputs
The module exports the following outputs:
| Output Name           | Description                                        |
| --------------------- | -------------------------------------------------- |
| `frontdoor_id`        | The ID of the deployed Azure Front Door Profile.   |
| `frontdoor_host_name` | The default hostname of the Front Door endpoint.   |