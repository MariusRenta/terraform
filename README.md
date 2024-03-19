# terraform
Repository for Terraform Infrastructure Deployment of Virtual Machines in Azure

Terraform Azure Virtual Machine Deployment
This project utilizes Terraform to deploy virtual machines in Azure. The solution consists of several key files that work together to automate the deployment process.

#Solution Overview
1. main.tf
The main.tf file contains the main Terraform configuration code. It defines the Azure resources to be provisioned, including virtual machines, networks, and other necessary components. In this file, you'll find resource definitions, such as azurerm_virtual_machine, azurerm_network_interface, and azurerm_resource_group.

2. variables.tf
The variables.tf file defines input variables used in the Terraform configuration. These variables allow for customization and flexibility in the deployment process. Key variables include:

vm_count: Specifies the number of virtual machines to create. It's of type number and allows you to control the scale of your infrastructure by adjusting the count of virtual machines.

vm_flavor: Represents the type or configuration of the virtual machines to be created. It's of type string and allows you to specify the desired characteristics or size of the virtual machines, such as CPU, memory, and disk specifications.

admin_username: Defines the admin username for the virtual machines. It's of type string and provides the default value "myadminuser" for convenience, which you can change as needed. This username is typically used for administrative access to the virtual machines.

3. terraform.tfvars
The terraform.tfvars file contains the actual values for the input variables defined in variables.tf. Users provide values for these variables to customize the deployment according to their requirements. Example values include:

vm_count = 2
admin_username = "myadminuser"

In the image below are the resources created in Azure after running `terraform apply`.

![image](https://github.com/MariusRenta/terraform/assets/40556232/78e9f203-c94d-417a-bc11-2bed4c3959cd)



4. output.tf
The output.tf file defines the output values to be displayed after the Terraform apply operation. This may include important information such as IP addresses of the provisioned virtual machines. An example output definition is:


output "ping_results" {
  value = azurerm_virtual_machine.renta_vm.*.private_ip_address
}


![image](https://github.com/MariusRenta/terraform/assets/40556232/8982f3ec-c73b-4f3e-b2f1-894fe1c35ba7)

I acknowledge the need for the virtual machines to communicate with each other. However, due to time constraints, I haven't had the opportunity to explore the process of creating a provisioning script to execute the ping command between them after they are created.
