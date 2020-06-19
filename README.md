### Installing **Terraform** on Mac

`brew install terraform`

Test the installation by typing `terraform`

#### Create a Github account repo and then clone it into a terraform directory
[See this github link](www.github.com)

> While creating a github repo, ensure you choose _gitignore_ and **an apache license** from the dropdowns just before you click submit to create the repo.

`git clone git@github.com:Nanuim/tackling_terraform.git`

### Running on Azure

1. Update the application by adding 2 files: 
    > * resources.tf
    > * connections.tf
                                                 
1. Update the `resources.tf` file with the list of resources to be managed
1. Update the `connection.tf` with the list of providers

    ` provider "azurerm" {  
        subscription_id = "1"    
        client_id = "2"  
        client_secret = "3"  
        tenant_id = "4"  
      }`
      
1. Run `terraform init` for terraform to download the necessary files

    `resource "azurerm_resource_group" "my_example"{  
       name = "nan_resource_example"  
       location = "East US"  
     }`
1. Do an `az login` to see details of subscription
1. Run `az account list` to see the different accounts under your profile
1. Run `az account set --subscription="xxxxx"` to set the right subscription you need to use
1. Run `az ad sp create-for-rbac --role="Contributor" --scopes /subscriptions/"xxxxxxx"`
    > Fetch the values for appId, password, tenant to be configured in the bashprofiles file.
1. Update the .bash_profiles file with the details below
    >export TF_VAR_subscription_id="id for Subscription"  
    export TF_VAR_client_id="appId"  
    export TF_VAR_client_secret="password"  
    export TF_VAR_tenant_id="tenant"
1. Update the `connections.tf` with the following info
    > provider "azurerm" {
        subscription_id = var.subscription_id  
        client_id = var.client_id  
        client_secret = var.client_secret  
        tenant_id = var.tenant_id  
      }
      
     > variable subscription_id {}  
      variable client_id {}  
      variable client_secret {}  
      variable tenant_id {}  
1. Runthe following when appropriate:
    >`terraform plan` to check that everything is set correctly  
      `terraform apply` to set up the infrastructure
      `terraform destroy` to pull down all the infrastructure
                                                                              