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
    - [3.3.2 Configure Panorama](#332-configure-panorama)
      - [3.3.2.1 License Panorama](#3321-license-panorama)
      - [3.3.2.2 Create Device Group and Device Template](#3322-create-device-group-and-device-template)
      - [3.3.2.3 Base config of the Device Template](#3323-base-config-of-the-device-template)
- [4. Deploy Firewalls in Azure](#4-deploy-firewalls-in-azure)
  - [4.1 What you will do?](#41-what-you-will-do)
  - [4.2 Deployment](#42-deployment)
  - [4.3 Validate Deployment](#43-validate-deployment)
- [5 License Migration](#5-license-migration)
  - [5.1 Covered Secanrios in Detail](#51-covered-secanrios-in-detail)
  - [5.2 Migrate Software Firewalls](#52-migrate-software-firewalls)
    - [5.2.1 Initial Migration](#521-initial-migration)
    - [5.2.2 Migrate PanOS 10.0.9 to Flexible Deployment Profile](#522-migrate-panos-1009-to-flexible-deployment-profile)
    - [5.2.3 Migrate PanOS 10.2.3 to Flexible Deployment Profile](#523-migrate-panos-1023-to-flexible-deployment-profile)
  - [5.3 Change vCPU on PanOS 10.2.3 Firewall](#53-change-vcpu-on-panos-1023-firewall)
  - [5.4 Change/Update Deployment Profiles](#54-changeupdate-deployment-profiles)
    - [5.4.1 Add Security Subscriptions](#541-add-security-subscriptions)


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
   az group create --name [StudentRGName] --location [Location] --tags Owner=Workshop-DeleteMe
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
8. Now create an Inbound Security Rule to allow **any** traffic to your newly created Panorama
   ![Screenshot 2023-05-10 at 09 31 41](https://github.com/PaloAltoNetworks/Azure_Training/assets/30934288/ee4c137e-df36-4e19-b7de-7d0d82ffb50c)
9. Login to your Panorama via the Public IP associated to it. The Instructor will provide you the Usernam and Password.
   1.  https://[Public-IP]
   ![Screenshot 2023-04-26 at 17 08 58](https://user-images.githubusercontent.com/30934288/234621053-6a3c2eb5-fc13-4af5-b40a-67a679aae773.png)

Congratulations!! You have succesfully deploye a Panorama in Microsoft Azure.
<br/>

# 3. Customer Support Portal
In the following Lab section we will go to the Customer support portal (CSP) to create your first Deployment Profiles. This is needed for the intial Migration and generating a Serialnumber for the Panorama

## 3.1 Login To Customer Support Portal
1. Login with your PANW Credentials at the Customer Support Portal https://support.paloaltonetworks.com/
2. In the Support Portal Change the Account Seletor to 132205 - Palo Alto Networks - Professional Services
   ![Screenshot 2023-04-28 at 10 27 55](https://user-images.githubusercontent.com/30934288/235103488-dec40a3b-8b52-4e86-b47f-63a5ea94399e.png)
3. On the Support Portal Page on the left side go to Assets -> Software NGFW Credits

## 3.2 Create Fixed Deployment Profiles
Now you will create one Deployment Profile in the Customer Support Portal.

### 3.2.1 Azure Deployment Profile
1. On the Prisma NFGW Credits Pool click on Create Deployment Profile
   ![Screenshot 2023-04-28 at 10 34 00](https://user-images.githubusercontent.com/30934288/235103582-e0457306-91e1-41f7-9810-89e2e684e9df.png)
2. Select the following as shown on the picture below and click Next<br/>
   ![Screenshot 2023-04-28 at 10 35 37](https://user-images.githubusercontent.com/30934288/235103668-d6dca65f-7ad0-420f-89dc-4fdb0adadc14.png)
3. In the Deployment Profile use the following and replace Instructor-Lab under "Profile Name" with **"Migration-Lab-Fixed-[StudentName]"**
   ![Screenshot 2023-05-10 at 08 41 39](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/65eef85b-a8d6-4f33-9a4c-647df9195397)
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

### 3.3.2 Configure Panorama
As next we will License your Panorama with the Serialnumber you created above and create a new Decive Group and Template inside your new Panorama and do some basic configuration in your Device Template

#### 3.3.2.1 License Panorama
1. Login to your Panorama https://[Public-IP]
2. Copy the the Serialnummber you create on the CSP Portal and enter it under the Panorama Tab -> Setup -> Management -> General Settings
   ![Screenshot 2023-05-03 at 10 40 41](https://user-images.githubusercontent.com/30934288/235870102-b21ae1db-3df3-451e-b97d-177fb0aac110.png)
3. Hit OK and reload the UI. Check if a pending commit on the Panorama is needed. If yes, commit to Panorama.
4. In the Panorama check if you can see a Serialnummber is associated to it
   ![Screenshot 2023-04-28 at 10 42 49](https://user-images.githubusercontent.com/30934288/235103168-d62230df-38c1-43e4-862d-7fb8c52a9d1a.png)

#### 3.3.2.2 Create Device Group and Device Template
1. As next Create a Device Group, Template, and Template Stack. See the picture below as example
   ![Screenshot 2023-04-28 at 10 44 34](https://user-images.githubusercontent.com/30934288/235103331-a855e378-c39d-473a-8a74-3e3b51f60fec.png)
   ![Screenshot 2023-04-28 at 10 44 48](https://user-images.githubusercontent.com/30934288/235103377-2ab1e849-4f35-4208-a429-628d6516bd13.png)
2. Once you done it commit your changes to the Panorama

#### 3.3.2.3 Base config of the Device Template
1. In the Panorama navigate to **Device** and select under Template your previous create Template (my example Stundent-TP)
   ![Screenshot 2023-05-10 at 14 50 48](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/7959a7f0-74a6-4ec4-8690-ace440b101f8)
2. In your Template click on **Select -> Service** and click on the wheel.
![Screenshot 2023-05-10 at 14 52 55](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/b66eaecf-1712-455b-8500-f31fe78b63bb)
3. In the Services tab type 8.8.8.8 under Primary DNS Server
![Screenshot 2023-05-10 at 14 53 57](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/e96d8204-d429-4797-8b5b-93f5ce0735ea)
4. As next click on the NTP tab and provide an NTP server from your region (my example 0.de.pool.ntp.org)
![Screenshot 2023-05-10 at 14 40 09](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/7da1da9e-90ea-489a-9e39-d718d4b49426)
5. Click Ok once you entert it
6. As next click on the left panel on **Dynamic Updates**
7. Change the settings as shown in the picture below
![Screenshot 2023-05-10 at 14 29 05](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/b071dd6b-9042-4ac4-be68-0b36ceb9ac33)
8. At the end commit your changes to the Panorama
![Screenshot 2023-05-10 at 14 47 15](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/64afd8a0-d08d-40cd-82cc-fe0de3fe0787)

# 4. Deploy Firewalls in Azure 
In the following chapter you will deploy several Software Firewalls in different PanOS version. The Software Firewalls will automatically join your previous created Panorama

## 4.1 What you will do?
- Login to Azure Portal (https://portal.azure.com) and login with your Credentials
- Download Terraform Code from GitHub
- Modify Terraform Code
- Execute Terraform Code
- Validate Deployment in Azure Portal and Panorama

## 4.2 Deployment

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

![Screenshot 2023-05-09 at 18 34 28](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/e5adbe2e-5b65-4f3c-a67a-50f48b6c7b36)

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

17. **Important!** The complete deployment will take up to 10 Minutes after the completing the Terraform Apply. It is a good time for a break

18. **Terraform Init**<br/>
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/init.png)

19. **Terraform Plan** <br/>
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/plan.png)

20. **Terraform Apply** <br/>
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/apply.png)

21. Once the ```terraform apply``` is completed you will see the following output<br/>
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/Complete.png)

## 4.3 Validate Deployment

- Login into Panorama
- Validate Deployment

1.  Login into Panorama Public IP
2.  Once you logged into the Panorama Navigate to the **Panorama** tab validate you can see your newly deployed Firewalls **(The deployment and bootstrapping process can take up to 10-15 minutes)**. If the Deployment was succesful you will see the following output in **Panorama -> Managed Devices -> Summary**
   
![Screenshot 2023-05-09 at 18 27 15](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/af39f08f-f237-45dd-a8d8-58751e1ee5f9)

3. You succesfull deployed your Environment if you can see the above output

**Congratulations you succesfully deployed several VM-Series Firewalls in different PanOS Version and bootstrapped them.**

# 5 License Migration

In the following steps you will migrate the previous created from a NON-Flex License model to the Flex-License model. You will do several migrations and create/update some Deployment profiles to fulfill the activities.

## 5.1 Covered Secanrios in Detail

1.  Migrate all Software Firewall to Flex License model (Fixed Deployment Profile) via Panorama
2.  Migrate one (1) Firewall with PanOS 9.1.13-h3 to Fixed License via Panorama
3.  Migrate one (1) Firewall with PanOS 10.0.9 to Fixed License via Panorama
4.  Migrate one (1) Firewall with PanOS 10.0.9 from Fixed License to Flex via Panorama
5.  Migrate one (1) Firewall with PanOS 10.2.3 to Fixed License via Panorama
6.  Migrate one (1) Firewall with PanOS 10.2.3 from Fixed License to Flex via Panorama
7.  Migrate one (1) Firewall with PanOS 10.2.3 from Flex to Flex with increasing the vCPU via Panorama


## 5.2 Migrate Software Firewalls
In the following section we will migrate now all Software Firewall from the NON-Flex license model to the Flex license model. For that we will use the Deployment profile fou created in the section [3.2 Create Fixed Deployment Profiles](#32-create-fixed-deployment-profiles).

### 5.2.1 Initial Migration
In the following section you migrate all Software Firewalls from NON-Flex Licensing to Flex Licensing.

1. Login with your PANW Credentials at the Customer Support Portal https://support.paloaltonetworks.com/
2. In the Support Portal Change the Account Seletor to 132205 - Palo Alto Networks - Professional Services
   ![Screenshot 2023-04-28 at 10 27 55](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/0de4e869-00cf-4510-b1f7-bd648604b044)
3.  On the Support Portal Page on the left side go to Assets -> Software NGFW Credits -> Details
   ![Screenshot 2023-05-08 at 13 57 29](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/f77f90d9-cad1-4e9b-b46d-1bcbf1f8063c)
4. Now Search for your previous created Azure Deployment Profile [Here](#32-create-fixed-deployment-profiles)
5. Now Copy the Auth Code of your Profile.
  ![Screenshot 2023-05-10 at 08 55 41](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/b9ac5d40-27d6-4ed4-87cc-35cfaafff550)
6. As next Login in to your Panorama **https://[Public-IP]**
7. **In Your Panorama navigate to Panorama -> Device Deployment -> Licenses**
![Screenshot 2023-05-10 at 08 58 44](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/8f1bc08f-1b78-40de-b396-fe2650c7ed64)
8. In the License window click at the bottom Activate
![Screenshot 2023-05-10 at 09 01 09](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/be7bba7e-1efd-4b9a-9b25-134ffd93af8c)
9. In the opened Window select now all available Firewalls and type in **AUTH CODE** field the auth code and click **Activate**
![Screenshot 2023-05-10 at 09 04 13](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/d4cea55e-36b6-4ab6-87d4-a49c4391de15)
10. The Migration process will now take several minutes. 
11. Once Migration is completed you will see the following outcome
![Screenshot 2023-05-10 at 09 07 12](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/dd623b84-a7dc-425f-a2e5-9c39d55d6d2c)
12. As next check on the CSP if your credits got consumed from your deployment profile. You should see the below outcome
![Screenshot 2023-05-10 at 09 10 04](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/bbee137d-b328-433c-b7f1-3475434d619a)

**Congratulations!!! You Migrated successful all your Software Firewalls from a NON-Flex license model to Flex License model (Fixed Deployment Profile) via Panorama**

### 5.2.2 Migrate PanOS 10.0.9 to Flexible Deployment Profile
In the following section we will create a new Deployment Profile to migrate the Software Firewalls from a Fixed Deployment Profile to a Flexible Deployment Profile

1. Login with your PANW Credentials at the Customer Support Portal https://support.paloaltonetworks.com/
2. In the Support Portal Change the Account Seletor to 132205 - Palo Alto Networks - Professional Services
   ![Screenshot 2023-04-28 at 10 27 55](https://user-images.githubusercontent.com/30934288/235103488-dec40a3b-8b52-4e86-b47f-63a5ea94399e.png)
3. On the Support Portal Page on the left side go to Assets -> Software NGFW Credits
4. On the Prisma NFGW Credits Pool click on Create Deployment Profile
   ![Screenshot 2023-04-28 at 10 34 00](https://user-images.githubusercontent.com/30934288/235103582-e0457306-91e1-41f7-9810-89e2e684e9df.png)
5. Select the following as shown on the picture below and click Next<br/>
![Screenshot 2023-05-10 at 11 00 39](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/5d87a3a2-8ec7-4b82-865c-1bd6a34f5571)
6. In the Deployment Profile use the following and use the NAME under "Profile Name" with **"Migration-Lab-Flex-[StudentName]"**
![Screenshot 2023-05-11 at 09 29 57](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/ce900d6d-d414-49ce-ac4d-a96d41486525)
7. Click "Create Deployment Profile"
8. Verify that your Deployment Profile is successfully created
![Screenshot 2023-05-10 at 11 06 15](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/c186ff26-3d67-4b52-83ab-f6a2c6197abd)
9. Now Copy the Auth Code of the newly created Deployment Profile
10. As next Login in to your Panorama **https://[Public-IP]**
11. **In Your Panorama navigate to Panorama -> Device Deployment -> Licenses**
![Screenshot 2023-05-10 at 08 58 44](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/7bafaf76-c150-4ec3-b304-f86999438207)
12. In the License window click at the bottom Activate
![Screenshot 2023-05-10 at 09 01 09](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/65383526-90e9-4094-a9b1-57b14af315fe)
13. Select now Firewall 3 and 4 or as in shown in the Picture the firewalls with the name "PA-VM". You can verify the Name of the firewalls in the Summary tab. Now type in **AUTH CODE** field the auth code and click **Activate**
![Screenshot 2023-05-10 at 14 08 34](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/77a96993-e7e2-4b89-804e-b18a0aa15780)
14. Are the upgrade is working? If no, Why?
    <details>
     <summary style="color:black">Expand For Details</summary>
      The Upgrade is not working because you chaning the VM capacity. You can only upgrade the Software Firewalls to the Flex Deployment profile when activating it directly on the VM and using the "Upgrade VM capacity" <br/>
      
      ![Screenshot 2023-05-10 at 13 01 11](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/cece0010-4ed4-4bbf-b27e-ad82f72f1ea4)
    </details>
<br/>

15. Before you can perform the License Key upgrade you have to install on the firewalls the License API Key. Follow the [instructions](https://docs.paloaltonetworks.com/vm-series/10-2/vm-series-deployment/license-the-vm-series-firewall/vm-series-models/install-a-license-deactivation-api-key) to perform the task. Repeat that 
16. Repeat that step for Firewalls 3-6 
17. Once you added the API go in your Panorama and switch the context to Firewall 3 or 4 (or PA-VM)
![Screenshot 2023-05-10 at 13 02 30](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/1067a8ae-248d-491c-994b-c397c67c5454)
18. In the Firewall navigate **Device -> License** and click on **Upgrade VM capacity**
![Screenshot 2023-05-10 at 13 04 55](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/0f59af49-5d9c-47dd-b432-8ceab28ee9a2)
19. In the window add under Authorization Code your atuh code and click Continue
![Screenshot 2023-05-10 at 13 05 53](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/15043178-5001-4c05-8072-f1ca6a6ccb86)
20. You will see the below outcome once it completed. Click close and refresh the UI
![Screenshot 2023-05-10 at 13 18 38](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/101058af-6897-42ea-8f20-5bf6893b5879)
21. In the Firewall switch to the Dashboard and you can see the VM License changed to VM-FLEX-4
![Screenshot 2023-05-10 at 13 18 47](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/42cb3810-1e08-45e1-8cec-e716efefc618)
22. Repeat the same steps for the second firewall.
23. When you know go to the Support Portal and check your profiles, you can see that the count of the Fixed prile is reduced by 2 firewalls and 8 vcpus and the Flex profile increased.
![Screenshot 2023-05-10 at 13 24 11](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/2e01b3f4-0cf3-46e6-8a9c-07e3db8302fe)

**Congratulations!!! You successful migrated 2 Firewalls from a Fixed License Deployment Profile to an Flexible Deployment profile and implemented the API License Key on the Firewalls**

### 5.2.3 Migrate PanOS 10.2.3 to Flexible Deployment Profile
In the following section we will create a new Deployment Profile to migrate the Software Firewalls from a Fixed Deployment Profile to a Flexible Deployment Profile

1. Login with your PANW Credentials at the Customer Support Portal https://support.paloaltonetworks.com/
2. In the Support Portal Change the Account Seletor to 132205 - Palo Alto Networks - Professional Services
![Screenshot 2023-04-28 at 10 27 55](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/fce312fd-44a3-4eac-ba39-e21c7a1387ba)
3. On the Support Portal Page on the left side go to Assets -> Software NGFW Credits
4. On the Prisma NFGW Credits Pool click on Create Deployment Profile
![Screenshot 2023-04-28 at 10 34 00](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/4d2a4572-d374-4c70-a014-5eda836b02b1)
5. Select the following as shown on the picture below and click Next<br/>
![Screenshot 2023-05-10 at 11 00 39](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/3004ee1b-9861-48bd-98bf-ec546b4ee632)
6. In the Deployment Profile use the following and use the NAME under "Profile Name" with **"Migration-Lab-Flex-10.2-[StudentName]"**
![Screenshot 2023-05-10 at 14 05 47](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/54ac21f9-2645-4cb6-ae09-e9795e23e92d)
7. Click "Create Deployment Profile"
8. Verify that your Deployment Profile is successfully created
![Screenshot 2023-05-10 at 14 06 25](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/02e29ade-a09e-4f4d-a0c0-798d43f6410a)
9. Now Copy the Auth Code of the newly created Deployment Profile
10. As next Login in to your Panorama **https://[Public-IP]**
11. **In Your Panorama navigate to Panorama -> Device Deployment -> Licenses**
![Screenshot 2023-05-10 at 08 58 44](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/14fd4221-d1cf-459a-8c98-de94dc47b6c9)
12. In the License window click at the bottom Activate
![Screenshot 2023-05-10 at 09 01 09](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/8683d515-db29-47a3-993a-79455cf84972)
13. Select now Firewall 5 and 6 or as in shown in the Picture. You can verify the Name of the firewalls in the Summary tab. Now type in **AUTH CODE** field the auth code and click **Activate**
![Screenshot 2023-05-10 at 14 17 35](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/d9c8cd41-8306-4219-ac08-a8278ec35b6f)
14. It will fail too because of the same issue you already faced above. Please follow the same instructions from the previous chapter to migrate the firewalls to Flexible Deployment profile.

## 5.3 Change vCPU on PanOS 10.2.3 Firewall
In the following section we will create a new Deployment Profile to change the vCPU on the already licensed Software Firewall

1. Login with your PANW Credentials at the Customer Support Portal https://support.paloaltonetworks.com/
2. In the Support Portal Change the Account Seletor to 132205 - Palo Alto Networks - Professional Services
![Screenshot 2023-04-28 at 10 27 55](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/fce312fd-44a3-4eac-ba39-e21c7a1387ba)
3. On the Support Portal Page on the left side go to Assets -> Software NGFW Credits
4. On the Prisma NFGW Credits Pool click on Create Deployment Profile
![Screenshot 2023-04-28 at 10 34 00](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/4d2a4572-d374-4c70-a014-5eda836b02b1)
5. Select the following as shown on the picture below and click Next <br/>
![Screenshot 2023-05-10 at 11 00 39](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/3004ee1b-9861-48bd-98bf-ec546b4ee632)
6. In the Deployment Profile use the following and use the NAME under "Profile Name" with **"Migration-Lab-Flex-10.2-3vcpu-[StudentName]"** <br/>
<img width="589" alt="Screenshot 2023-05-16 at 11 02 58" src="https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/e176f5d4-b38c-49b4-a035-318ca2996fdb">

7. Click "Create Deployment Profile"

8. Verify that your Deployment Profile is successfully created
<img width="883" alt="Screenshot 2023-05-16 at 11 08 43" src="https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/5068f1cd-0f88-41b2-9f0a-932843dc8edb">

9. Verify at first that both software Firewalls (5 and 6) are migrated to the new Flexible Deployment Profile. Check the Firewall Dashboard if you can see (VM-Series-4) <br/>
<img width="470" alt="Screenshot 2023-05-16 at 11 22 52" src="https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/8632f9a7-bceb-4687-bd13-c1d9db533376">

10.  As next login to Firewall 5 or 6 via ssh. In my Example i migrate Firewall 6 <br/>
    ```ssh -oHostKeyAlgorithms=+ssh-rsa USERNAME@FIREWALL IP```

11.  In the CLI type the following command to set the Core value to 3 <br/>
    ```request plugins vm_series set-cores cores 3``` <br/>
<img width="874" alt="Screenshot 2023-05-16 at 11 28 34" src="https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/031eb1b2-3b46-4c0b-8cf0-fda8ba3f228b">

12.  The requires a reboot. Type the following command to rebbot the Firewall <br/>
    ```request restart system``` <br/>
<img width="682" alt="Screenshot 2023-05-16 at 11 31 33" src="https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/eee63a0d-dc19-4ae5-a9d9-86e0a91b1ede"> <br/>

13.  The Reboot of the firewall will take now around ~ 5 Minutes <br/>
14.  Once the Firewall is back online and function login to the Firewall via  Panorama or directly to the Firewall
15.  In the Firewall navigate **Device -> License** and click on **Upgrade VM capacity**
![Screenshot 2023-05-10 at 13 04 55](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/0f59af49-5d9c-47dd-b432-8ceab28ee9a2)
16.   In the window add under Authorization Code your auth code (3 vCPU) and click Continue
![Screenshot 2023-05-10 at 13 05 53](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/15043178-5001-4c05-8072-f1ca6a6ccb86)
17.   You will see the below outcome once it completed. Click close and refresh the UI
![Screenshot 2023-05-16 at 12 54 19](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/dea24352-b34d-4a92-8748-b63a31d4359e)
18.    In the Firewall go to the Dashboard and you can see the VM License changed to **VM-FLEX-3** <br/>
![Screenshot 2023-05-16 at 13 04 32](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/e5fe26c1-98e8-430e-b77e-4f9599f521ae)

<br/>

**Congratulations!!! You successful migrated 1 Software Firewalls from Flexible Deployment Profile with 4 vCPU's to a Flexible Deployment Profile and changed the Cores count via CLI**

## 5.4 Change/Update Deployment Profiles
In the following section you will now update your Deployment Profile (**"Migration-Lab-Flex-10.2-[StudentName]"**) too remove some Subscription and enable subscriptions

### 5.4.1 Add Security Subscriptions
1. Login with your PANW Credentials at the Customer Support Portal https://support.paloaltonetworks.com/
2. In the Support Portal Change the Account Seletor to 132205 - Palo Alto Networks - Professional Services
![Screenshot 2023-04-28 at 10 27 55](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/fce312fd-44a3-4eac-ba39-e21c7a1387ba)
3. On the Support Portal Page on the left side go to Assets -> Software NGFW Credits
4. Go to youe Deployment Profile **"Migration-Lab-Flex-10.2-[StudentName]"**
   Picture
5. In your Deployment Profile select the Global Protect
   Picture
6. Click **YES** in the new Window
   NEW Picture
7. As next Login to your Panorama
8. In Your Panorama navigate to **Panorama -> Device Deployment -> Licenses**
![Screenshot 2023-05-10 at 08 58 44](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/7bafaf76-c150-4ec3-b304-f86999438207)
9. Select **Refresh**
Picture <br/>
10. Now Select the firewall who was associated with the Auth Code of the **"Migration-Lab-Flex-10.2-[StudentName]"** Deployment Profile (In the Example is it Firewall 5) and click **Refresh**
    Picture
11. You should see the following output if it was successfull
    Picture
12. Refresh the Panorama UI
13. Now you should see that on Software Firewall 5 is the Global Protect License Active
Picture

**Congratulations!!! You successful Updated your Deployment Profile and added another Security subscription**



