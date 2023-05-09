![](https://lh4.googleusercontent.com/18oAPNp1uzZ6qY6bJxg2fWYWUEV-pQzNa_dSAqSp2lEjdg4hlEyLlQYc1OAowXxSqrp5Bk9iXRYOu-mECiqSr-gzo56d8QAh97VrfTbwX4uYN2ABB8BKM9XZK2mSzSXDN3qeHzp8xRsNHmALdeNEPiw)

![](https://lh3.googleusercontent.com/_-_DS9VDmI1QhI68JOiMchoWH7Bo1fqYn0qbD9Y24KH1T1zAG272HQy7cetrLxw3buJYbJEcj7TMjxv0CeWt-z1p4a3hl1FrNKPMROVo6L42XLIWFkjw_yPGlVTzhcPz1v2IB2JCUXMrAl4p2n9kbnY) 
<br/><br/>

- [1. Palo Alto Networks Professional Service Flex Licensing Migration Lab](#1-palo-alto-networks-professional-service-flex-licensing-migration-lab)
  - [1.1 Overview](#11-overview)
  - [1.2 Covered Secaniros](#12-covered-secaniros)
- [2 Deploy Panorama in Microsoft Azure](#2-deploy-panorama-in-microsoft-azure)
  - [2.1 Deploy Azure Resource Group](#21-deploy-azure-resource-group)
  - [2.2 Deploy Panorama in Azure](#22-deploy-panorama-in-azure)
- [3. Customer Support Portal](#3-customer-support-portal)
  - [3.1 Login To Customer Support Portal](#31-login-to-customer-support-portal)
  - [3.2 Create Fixed Deployment Profiles](#32-create-fixed-deployment-profiles)
    - [3.2.1 Azure Deployment Profile](#321-azure-deployment-profile)
  - [3.3 License Panorama](#33-license-panorama)
    - [3.3.1 Provision Panorama Serialnumber](#331-provision-panorama-serialnumber)
    - [3.3.2 License Panorama / Create Device Group and Template](#332-license-panorama--create-device-group-and-template)
- [4. Deploy Firewalls](#4-deploy-firewalls)
  - [4.2. Validate Deployment](#42-validate-deployment)


# 1. Palo Alto Networks Professional Service Flex Licensing Migration Lab

<br/><br/>

## 1.1 Overview

The Following Lab guide will help you to understand how to migrate Non-Flex licensed Software Firewalls from Non-Flex license model (ELA, etc) to the new Flex License Model. It will also cover how to create Deployment profiles in the Customer Suport Portal (CSP) to cover several secanrios. The Lab will only cover Migration use cases as listed below
1. Standalone Firewall with Access to the CSP
2. Standalone Firewall, No Access to the CSP
3. Panorama-Managed Firewalls with Access to the CSP
4. Panorama-Managed Firewalls, No Access to the CSP

Private Cloud and other Public Cloud Providers will not be covered in the Lab.  The deployed firewall are running in PanOS 9.1, 10.0.3, 10.2

<br/><br/>

## 1.2 Covered Secaniros
The following Secanrios and Lab activies are covered

1. Deploy a new Lab Panorama to fullfill the Migration process
2. Configure Panorama to perform the Lab activities
3. Setup the Customer support Portal (CSP)
   1. Creating several Deployment Profiles
4. Deploy Software Firewalls and License them with an ELA License
   1. 2 Firewalls in PanOS 9.1.13-h3
   2. 2 Firewalls in PanOS 10.0.9
   3. 2 Firewalls in PanOS 10.2.3
5. Migrate Software Firewalls from NON-Flex License Model to Flex-License Model
   1. NON-Flex to Flex-License (Fixed Deployment Profile)
   2. Flex-License to Flex-License (Flexible Deployment Profile)
6. How to update the Deployment Profile
   1. Enable/Disable CDSS
   2. Increase/Decrease vCPU count
7. Troubleshooting

<br/>

# 2 Deploy Panorama in Microsoft Azure
For this workshop you will create a first a Panorama before we deploy the Software Firewall in other Public Cloud Providers. The Panorama will have direct internet access. the Panorama is not connected to any other internal Ressource in Azure.
<br/>

## 2.1 Deploy Azure Resource Group
1. Login in to Azure Portal (https://portal.azure.com). As Login use your Palo Alto Networks Credentials 
![AzurePortal](https://user-images.githubusercontent.com/30934288/233334030-b7fb093a-5cec-4083-9779-3bf817b0c3ef.png)
1. Open Azure Cloud Shell
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/AzureCLI.png)
1. In Cloud Shell execute the following command but change before the values [StudentRGName] and [Location]
   Available Regions are: **North Europe, East US, UK South, UAE North, Australia Central**
   ```
   az group create --name [StudentRGName] --location [Location]
   ```
2. The Output should looks like the following
![Screenshot 2023-04-26 at 16 34 21](https://user-images.githubusercontent.com/30934288/234610062-a2b082b9-22b8-430b-949e-26ac35bc28bf.png)

## 2.2 Deploy Panorama in Azure
As next we will create the Panorama from a pre-staged image, after successfully creating the Resource Group.

1. Please go back to the Azure Cloud Shell
2. In the following command updat the following variables with yours:
   1. [StudentRGName] #Use the same same of the previous created Resource Group in the Chapter [Deploy new Resource Group in Azure](#32-deploy-new-resource-group-in-azure)
   2. [VM-Name]
   3. [YourPassword] 

Don't change any other variables

```
az vm create -g [StudentRGName] -n [VM-Name] --authentication-type password --admin-password [YourPassword] --image /subscriptions/d47f1af8-9795-4e86-bbce-da72cfd0f8ec/resourceGroups/ImageRG/providers/Microsoft.Compute/galleries/PsLab/images/psazurelab/versions/1.0.0 --specialized --public-ip-sku Standard  --plan-name byol --plan-publisher paloaltonetworks --plan-product panorama --size Standard_D4_v2
```
4. After you made the changes, execute the command in Azure Cloud Shell
5. The Output should looks like the following
![Screenshot 2023-04-26 at 16 49 00](https://user-images.githubusercontent.com/30934288/234614674-e175355c-7f8a-4b09-9844-483cc08c5b8f.png)
6. Check your Ressource Group in Aure if the Deployment is completed
   ![Screenshot 2023-04-26 at 17 03 30](https://user-images.githubusercontent.com/30934288/234620953-dab08ee5-a158-49c2-926a-ff088b4e32a9.png)
7. In the Ressource Group select your NSG
   ![Screenshot 2023-04-26 at 17 04 28](https://user-images.githubusercontent.com/30934288/234620991-cf7531ea-f5cd-485b-a2b8-adbc51f66ef9.png)
8. Now create an Inbound Security Rule to allow HTTPS traffic to your newly created Panorama
   ![Screenshot 2023-04-26 at 17 05 09](https://user-images.githubusercontent.com/30934288/234621018-b2cb1e53-d67f-40aa-8412-119b59ed3ba4.png)
9. Login to your Panorama via the Public IP associated to it. The Instructor will provide you the Usernam and Password.
   1.  https://[Public-IP]
   ![Screenshot 2023-04-26 at 17 08 58](https://user-images.githubusercontent.com/30934288/234621053-6a3c2eb5-fc13-4af5-b40a-67a679aae773.png)

Congratulations!! You have succesfully deploye a Panorama in Microsoft Azure.
<br/>

# 3. Customer Support Portal
In the following Lab section we will go to the Customer support portal (CSP) to create several Deployment Profiles to perform the Migration from NON-Flex license model Flex License Model

## 3.1 Login To Customer Support Portal
1. Login with your PANW Credentials at the Customer Support Portal https://support.paloaltonetworks.com/
2. In the Support Portal Change the Account Seletor to 132205 - Palo Alto Networks - Professional Services
   ![Screenshot 2023-04-28 at 10 27 55](https://user-images.githubusercontent.com/30934288/235103488-dec40a3b-8b52-4e86-b47f-63a5ea94399e.png)
3. On the Support Portal Page on the left side go to Assets -> Software NGFW Credits

## 3.2 Create Fixed Deployment Profiles
Now you will create several Deployment Profiles in the Customer Support Portal to cover the migration process from NON-Flex to Flex (Fixed Deployment Profile).

### 3.2.1 Azure Deployment Profile
1. On the Prisma NFGW Credits Pool click on Create Deployment Profile
   ![Screenshot 2023-04-28 at 10 34 00](https://user-images.githubusercontent.com/30934288/235103582-e0457306-91e1-41f7-9810-89e2e684e9df.png)
2. Select the following as shown on the picture below and click Next<br/>
   ![Screenshot 2023-04-28 at 10 35 37](https://user-images.githubusercontent.com/30934288/235103668-d6dca65f-7ad0-420f-89dc-4fdb0adadc14.png)
3. In the Deployment Profile use the following and replace Instructor-Lab under "Profile Name" with "Azure-Fixed-[StudentName]"
   ![Screenshot 2023-04-28 at 10 37 12](https://user-images.githubusercontent.com/30934288/235103752-1f1c0959-87a5-4654-bb76-03d472fad2b6.png)
4. Click "Create Deployment Profile"
5. Verify that your Deployment Profile is successfully created
   ![Screenshot 2023-04-28 at 10 40 09](https://user-images.githubusercontent.com/30934288/235103850-9cd1b2d9-f585-436a-bb9a-97c1d21a9b39.png)
<br/>

## 3.3 License Panorama
In the next steps you will create a Serialnumber for your previous created Panorama with the Flex License Credits

### 3.3.1 Provision Panorama Serialnumber

1. Login with your PANW Credentials at the Customer Support Portal https://support.paloaltonetworks.com/
2. On the Support Portal Page on the left side go to Assets -> Software NGFW Credits -> Details
   ![Screenshot 2023-05-08 at 13 57 29](https://user-images.githubusercontent.com/30934288/236821175-3277edbc-d472-4e9f-b428-1831ba25b73b.png)
3. Now Search for your previous created Azure Deployment Profile [here](#321-azure-deployment-profile)
4. Click on the 3 dots and on **Provision Panorama**
   ![Screenshot 2023-05-08 at 14 01 29](https://user-images.githubusercontent.com/30934288/236821233-4bd1203c-dfb7-4c7f-8a7b-6c332d5da645.png)
5. In the new window click on **Provision** <br/>
   ![Screenshot 2023-05-08 at 14 03 38](https://user-images.githubusercontent.com/30934288/236821269-23c45ffb-645d-4c3f-937a-22dff931cd8f.png)
6. Once the window is closed repeat the steps from step 3
   ![Screenshot 2023-05-08 at 14 01 29](https://user-images.githubusercontent.com/30934288/236821410-0e3495d1-2245-41ff-804c-6604ed03abe5.png)
7. Now you can see a Serialnumber in the Window. Copy and Paste the Serialnumber
   ![Screenshot 2023-05-08 at 14 06 13](https://user-images.githubusercontent.com/30934288/236821362-29f37909-874f-44ce-8f5a-8976f2d6c735.png)
8. You can close the window by clicking **Cancel**

### 3.3.2 License Panorama / Create Device Group and Template
As next we will License your Panorama with the Serialnumber you created above and create a new Decive Group and Template inside your new Panorama.

1. Login to your Panorama https://[Public-IP]
2. Copy the the Serialnummber you create on the CSP Portal and enter it under the Panorama Tab -> Setup -> Management -> General Settings
   ![Screenshot 2023-05-03 at 10 40 41](https://user-images.githubusercontent.com/30934288/235870102-b21ae1db-3df3-451e-b97d-177fb0aac110.png)
3. Hit OK and reload the UI. Check if a pending commit on the Panorama is needed. If yes, commit to Panorama.
4. In the Panorama check if you can see a Serialnummber is associated to it
   ![Screenshot 2023-04-28 at 10 42 49](https://user-images.githubusercontent.com/30934288/235103168-d62230df-38c1-43e4-862d-7fb8c52a9d1a.png)
5. As next Create a Device Group, Template, and Template Stack. See the picture below as example
   ![Screenshot 2023-04-28 at 10 44 34](https://user-images.githubusercontent.com/30934288/235103331-a855e378-c39d-473a-8a74-3e3b51f60fec.png)
   ![Screenshot 2023-04-28 at 10 44 48](https://user-images.githubusercontent.com/30934288/235103377-2ab1e849-4f35-4208-a429-628d6516bd13.png)
6. Once you done it commit your changes to the Panorama

# 4. Deploy Firewalls
In the following chapter you will deploy several Software Firewalls in different PanOS version. The Software Firewalls will automatically join your previous created Panorama

- Login to Azure Portal (https://portal.azure.com) and login with your Credentials
- Download Terraform Code from GitHub
- Modify Terraform Code
- Execute Terraform Code
- Validate Deployment in Azure Portal and Panorama

1. Login in to Azure Portal (https://portal.azure.com) 
![AzurePortal](https://user-images.githubusercontent.com/30934288/233334030-b7fb093a-5cec-4083-9779-3bf817b0c3ef.png)
2. Open Azure Cloud Shell
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/AzureCLI.png)
3. click on Create storage. In some case it will not create a Storage Account. In that case click in "Show advanced settings" and create your own storage account.
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/storagecli.png)
4. Once the creation of the storage is completed you will see the following
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/cloudshell.png)
5. Download Terraform Code from GitHub
   1. in the Cloud shell execute the following command
    ```
    git clone https://github.com/PaloAltoNetworks/flex-license-migration-lab.git
    ```
    2. As output you will see the following
    ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/clonerepo.png)
6. Now browse to the deployment folder folder
   ```
   cd cd flex-license-migration-lab/azure/single\ firewall\ deployment/
   ```
7. Rename the ```terraform.tfvars.example``` to ```terraform.tfvars``` mv ./example.tfvars terraform.tfvars
   <details>
    <summary style="color:black">Expand For Details</summary>

      **Command:**
      ``` mv ./terraform.tfvars.example terraform.tfvars```
  </details>
8. Modify the ```terraform.tfvars``` inside Cloud shell with the ```vi``` command
   1. Modify the following variables in the File.
   
   ```
   resource_group_name     = "migration-[Studenname]" #replace [Studentname] with your Name
   password                = "SecurePassWord12!!" #change the password. Use a complex password
   storage_account_name    = "pantfstorage[Studenname]" #replace [Studentname] with your name in small letters without space
   storage_share_name      = "bootstrapshare[Studenname]" #replace [Studentname] with your name in small letters without space

   ```

   ![Screenshot 2023-05-09 at 18 34 28](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/32b6cf09-c1db-45c8-a897-59cf25a9ef79)

9.  Save your changes by pressing ```ESC``` and type ```:wq!``` and ENTER
10. As next switch to the folder ```files``` and rename the ```init-cfg.sample.txt``` to ```init-cfg.txt``` using the ```mv``` command
11. Modify the ```init-cfg.txt``` inside Cloud shell with the ```vi``` command. Make sure you added the same name of the Device Group and Template Stack you created in your Panorama.
The value for the varibles ```tplname``` and ```dgname``` can be found in the section [3.3.2 License Panorama / Create Device Group and Template](#332-license-panorama--create-device-group-and-template)    
  ```
   type=dhcp-client
   vm-auth-key=123456789012345   #Follow the fLink below to create/show the key
   panorama-server=10.1.2.3      #change it to the Public IP of your Panorama
   tplname=my-stack              #change it to the Template Stack inside your Panorama Section [3.3.2]
   dgname=my-device-group        #change it to the Device Group inside your Panorama Section [3.3.2]
   dhcp-send-hostname=yes
   dhcp-send-client-id=yes
   dhcp-accept-server-hostname=yes
   dhcp-accept-server-domain=yes
  ```
 [LINK to Guide for the Key creation](https://docs.paloaltonetworks.com/vm-series/9-1/vm-series-deployment/bootstrap-the-vm-series-firewall/generate-the-vm-auth-key-on-panorama) 

12. As next in folder ```files``` and rename the ```authcodes.sample``` to ```authcodes``` using the ```mv``` command
13. Modify the ```authcodes``` files with the ```vi``` command.
   ```
   XXXXXXX # Instructor will provide you the Key via Slack
   ```

14.  Save your changes by pressing ```ESC``` and type ```:wq!``` and ENTER
15.  Move back to the ```single\ firewall\ deployment``` folder with the command ```cd..```
16.  Once you made all your changes execute the Terraform code with following commands:
    1.  ```terraform init```.
    2.  ```terraform plan```.
    3.  ```terraform apply``` once you get the prompet type ```yes```

**Important!** The complete deployment will take up to 10 Minutes after the completing the Terraform Apply. It is a good time for a break

<details>
  <summary style="color:black">Expand For Details</summary>

  **Terraform Init**
  ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/init.png)

  **Terraform Plan**
  ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/plan.png)

  **Terraform Apply**
  ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/apply.png)

</details>
<br/>

17.  Once the ```terraform apply``` is completed you will see the following output<br/>
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/Complete.png)

## 4.2. Validate Deployment

- Login into Panorama
- Validate Deployment

1.  Login into Panorama Public IP
2.  Once you logged into the Panorama Navigate to the **Panorama** tab validate you can see your newly deployed Firewalls **(The deployment and bootstrapping process can take up to 10-15 minutes)**. If the Deployment was succesful you will see the following output in **Panorama -> Managed Devices -> Summary**
   
![Screenshot 2023-05-09 at 18 27 15](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/cf1f83d9-dd78-476f-a672-c879e00b9dfc)

3. You succesfull deployed your Environment if you can see the above output
