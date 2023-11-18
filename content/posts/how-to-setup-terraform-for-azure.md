---
title: "How to setup terraform for Azure"
date: 2023-11-18
author: Erik Heaney
draft: true
---
{{< toc >}}
To setup terraform for Azure, you need to define the terraform and provider resources:
{{< highlight terraform >}}
terraform {
  required_version = ">= 1.4.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}
 
provider "azurerm" {
  subscription_id = var.subscription_id
  skip_provider_registration = true
  features {}
}
{{< /highlight >}}

Setting the skip_provider_registration to true in the Azure provider means that the user must authenticate into Azure beforehand. This works for running terraform plan/applies manually from our local machines. When we want to run terraform plan/applies automatically in a CI server (e.g. with jenkins and atlantis) we will want to look into using a Service Principal or Managed Service Identity.

Next you will want to login to Azure with the Azure CLI tool. You can install it via brew:
{{< highlight azure-cli >}}
brew update && brew install azure-cli
{{< /highlight >}}

And login with the following:
{{< highlight login >}}
az login
{{< /highlight >}}

This will open a window in your web browser like below:
{{< figure src="/posts/how-to-setup-terraform-for-azure/azure-login.png" align="center" style="border-radius: 8px;" >}}

Select your account and you should be logged in. You will see an output like this:
{{< highlight output >}}
[
  {
    "cloudName": "AzureCloud",
    "id": "00000000-0000-0000-0000-000000000000",
    "isDefault": true,
    "name": "PAYG Subscription",
    "state": "Enabled",
    "tenantId": "00000000-0000-0000-0000-000000000000",
    "user": {
      "name": "user@example.com",
      "type": "user"
    }
  }
]
{{< /highlight >}}

You can see a list of subscriptions you have access to by running:
{{< highlight account-list >}}
az account list
{{< /highlight >}}

If you have access to multiple subscriptions, select which one you want to authenticate into with:
{{< highlight set-account >}}
az account set --subscription="SUBSCRIPTION_ID"
{{< /highlight >}}

