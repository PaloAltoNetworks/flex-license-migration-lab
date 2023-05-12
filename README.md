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
   ![Screenshot 2023-05-10 at 08 41 39](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/b2e24f33-710a-4cd2-ae04-fe15a1c7b592)
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
   ![Screenshot 2023-05-10 at 14 50 48](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/cf799365-416f-40e6-8093-715c9b715a61)
2. In your Template click on **Select -> Service** and click on the wheel.
   ![Screenshot 2023-05-10 at 14 52 55](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/d6e5523e-2e08-4e27-bcad-fe4c9736192a)
3. In the Services tab type 8.8.8.8 under Primary DNS Server
   ![Screenshot 2023-05-10 at 14 53 57](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/e6ebf52c-45ca-41bb-912f-73fd671437a8)
4. As next click on the NTP tab and provide an NTP server from your region (my example 0.de.pool.ntp.org)
   ![Screenshot 2023-05-10 at 14 40 09](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/d500d6f9-ac11-4e7f-b3da-a55783cecc7e)
5. Click Ok once you entert it
6. As next click on the left panel on **Dynamic Updates**
7. Change the settings as shown in the picture below
   ![Screenshot 2023-05-10 at 14 29 05](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/3a20634b-14d7-40f7-bc59-49b4b8ca3b21)
8. At the end commit your changes to the Panorama
   ![Screenshot 2023-05-10 at 14 47 15](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/1e6dff87-141d-41e8-8af3-7849e5a73939)

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
   
![Screenshot 2023-05-09 at 18 27 15](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/cf1f83d9-dd78-476f-a672-c879e00b9dfc)

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
   ![Screenshot 2023-04-28 at 10 27 55](https://user-images.githubusercontent.com/30934288/235103488-dec40a3b-8b52-4e86-b47f-63a5ea94399e.png)
3.  On the Support Portal Page on the left side go to Assets -> Software NGFW Credits -> Details
   ![Screenshot 2023-05-08 at 13 57 29](https://user-images.githubusercontent.com/30934288/236821175-3277edbc-d472-4e9f-b428-1831ba25b73b.png)
4. Now Search for your previous created Azure Deployment Profile [Here](#32-create-fixed-deployment-profiles)
5. Now Copy the Auth Code of your Profile.
  ![Screenshot 2023-05-10 at 08 55 41](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/ec8b6b2e-c07a-41a4-ab36-2673cb6ae9dc)
6. As next Login in to your Panorama **https://[Public-IP]**
7. **In Your Panorama navigate to Panorama -> Device Deployment -> Licenses**
   ![Screenshot 2023-05-10 at 08 58 44](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/837950e2-0d0b-4ee6-9008-2f61898020ee)
8. In the License window click at the bottom Activate
   ![Screenshot 2023-05-10 at 09 01 09](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/845a9613-c0e8-45f2-8cf0-4aa079acbee5)
9. In the opened Window select now all available Firewalls and type in **AUTH CODE** field the auth code and click **Activate**
    ![Screenshot 2023-05-10 at 09 04 13](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/57ba35f5-23bc-4f23-ac86-b3b025691fb2)
10. The Migration process will now take several minutes. 
11. Once Migration is completed you will see the following outcome
    ![Screenshot 2023-05-10 at 09 07 12](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/af45c54b-3b08-4fb0-9a6a-d843dcd1f2ec)
12. As next check on the CSP if your credits got consumed from your deployment profile. You should see the below outcome
    ![Screenshot 2023-05-10 at 09 10 04](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/df6bcf8f-69ee-4969-9cce-cc75d97115fd)

**Congratulations!!! You Migrated successful all your Software Firewalls from a NON-Flex license model to Dlex License model (Fixed Deployment Profile) via Panorama**

### 5.2.2 Migrate PanOS 10.0.9 to Flexible Deployment Profile
In the following section we will create a new Deployment Profile to migrate the Software Firewalls from a Fixed Deployment Profile to a Flexible Deployment Profile

1. Login with your PANW Credentials at the Customer Support Portal https://support.paloaltonetworks.com/
2. In the Support Portal Change the Account Seletor to 132205 - Palo Alto Networks - Professional Services
   ![Screenshot 2023-04-28 at 10 27 55](https://user-images.githubusercontent.com/30934288/235103488-dec40a3b-8b52-4e86-b47f-63a5ea94399e.png)
3. On the Support Portal Page on the left side go to Assets -> Software NGFW Credits
4. On the Prisma NFGW Credits Pool click on Create Deployment Profile
   ![Screenshot 2023-04-28 at 10 34 00](https://user-images.githubusercontent.com/30934288/235103582-e0457306-91e1-41f7-9810-89e2e684e9df.png)
5. Select the following as shown on the picture below and click Next<br/>
   ![Screenshot 2023-05-10 at 11 00 39](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/a1877da0-2fab-451f-8452-77247429382f)
6. In the Deployment Profile use the following and use the NAME under "Profile Name" with **"Migration-Lab-Flex-[StudentName]"**
   ![Screenshot 2023-05-11 at 09 29 57](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/634bfc97-1bc9-4c4d-82d0-d733be28d76e)
7. Click "Create Deployment Profile"
8. Verify that your Deployment Profile is successfully created
   ![Screenshot 2023-05-10 at 11 06 15](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/a216a585-e1cf-4a30-8c6e-edcfe072e29e)
9. Now Copy the Auth Code of the newly created Deployment Profile
10. As next Login in to your Panorama **https://[Public-IP]**
11. **In Your Panorama navigate to Panorama -> Device Deployment -> Licenses**
   ![Screenshot 2023-05-10 at 08 58 44](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/837950e2-0d0b-4ee6-9008-2f61898020ee)
12. In the License window click at the bottom Activate
   ![Screenshot 2023-05-10 at 09 01 09](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/845a9613-c0e8-45f2-8cf0-4aa079acbee5)
13. Select now Firewall 3 and 4 or as in shown in the Picture the firewalls with the name "PA-VM". You can verify the Name of the firewalls in the Summary tab. Now type in **AUTH CODE** field the auth code and click **Activate**
    ![Screenshot 2023-05-10 at 14 08 34](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/9bd87a8b-74e6-4189-97bb-7150e948cb0c)
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
    ![Screenshot 2023-05-10 at 13 02 30](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/341c7bad-d56c-46ce-81ea-3c876b09d2f4)
18. In the Firewall navigate **Device -> License** and click on **Upgrade VM capacity**
    ![Screenshot 2023-05-10 at 13 04 55](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/090c5b34-30ee-4744-ab45-d5d24257e31f)
19. In the window add under Authorization Code your atuh code and click Continue
    ![Screenshot 2023-05-10 at 13 05 53](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/3c4d6afc-8c03-4a0b-9820-cdfeddadf64a)
20. You will see the below outcome once it completed. Click close and refresh the UI
    ![Screenshot 2023-05-10 at 13 18 38](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/ac1d0226-d321-4ab3-9507-739d6a055179)
21. In the Firewall switch to the Dashboard and you can see the VM License changed to VM-FLEX-4
    ![Screenshot 2023-05-10 at 13 18 47](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/ec2d2ff9-341d-4dec-8e21-3a3c25eef3ae)
22. Repeat the same steps for the second firewall.
23. When you know go to the Support Portal and check your profiles, you can see that the count of the Fixed prile is reduced by 2 firewalls and 8 vcpus and the Flex profile increased.
    ![Screenshot 2023-05-10 at 13 24 11](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/f7bff680-846d-4595-8ae7-db53fde1fb1f)

**Congratulations!!! You successful migrated 2 Firewalls from a Fixed License Deployment Profile to an Flexible Deployment profile and implemented the API License Key on the Firewalls**

### 5.2.3 Migrate PanOS 10.2.3 to Flexible Deployment Profile
In the following section we will create a new Deployment Profile to migrate the Software Firewalls from a Fixed Deployment Profile to a Flexible Deployment Profile

1. Login with your PANW Credentials at the Customer Support Portal https://support.paloaltonetworks.com/
2. In the Support Portal Change the Account Seletor to 132205 - Palo Alto Networks - Professional Services
   ![Screenshot 2023-04-28 at 10 27 55](https://user-images.githubusercontent.com/30934288/235103488-dec40a3b-8b52-4e86-b47f-63a5ea94399e.png)
3. On the Support Portal Page on the left side go to Assets -> Software NGFW Credits
4. On the Prisma NFGW Credits Pool click on Create Deployment Profile
   ![Screenshot 2023-04-28 at 10 34 00](https://user-images.githubusercontent.com/30934288/235103582-e0457306-91e1-41f7-9810-89e2e684e9df.png)
5. Select the following as shown on the picture below and click Next<br/>
   ![Screenshot 2023-05-10 at 11 00 39](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/a1877da0-2fab-451f-8452-77247429382f)
6. In the Deployment Profile use the following and use the NAME under "Profile Name" with **"Migration-Lab-Flex-10.2-[StudentName]"**
   ![Screenshot 2023-05-10 at 14 05 47](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/14afeaef-ba0b-42f0-8b3a-f7faf7b4660a)
7. Click "Create Deployment Profile"
8. Verify that your Deployment Profile is successfully created
   ![Screenshot 2023-05-10 at 14 06 25](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/5a498d91-863b-4b86-a9ba-2ddd508d0725)
9. Now Copy the Auth Code of the newly created Deployment Profile
10. As next Login in to your Panorama **https://[Public-IP]**
11. **In Your Panorama navigate to Panorama -> Device Deployment -> Licenses**
   ![Screenshot 2023-05-10 at 08 58 44](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/837950e2-0d0b-4ee6-9008-2f61898020ee)
12. In the License window click at the bottom Activate
   ![Screenshot 2023-05-10 at 09 01 09](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/845a9613-c0e8-45f2-8cf0-4aa079acbee5)
13. Select now Firewall 5 and 6 or as in shown in the Picture. You can verify the Name of the firewalls in the Summary tab. Now type in **AUTH CODE** field the auth code and click **Activate**
    ![Screenshot 2023-05-10 at 14 17 35](https://github.com/PaloAltoNetworks/flex-license-migration-lab/assets/30934288/7c661312-2e49-4f7c-92e4-16f53b787aac)
14. It will fail too because of the same issue you already faced above. Please set the API License Key on both firewalls and repeat the steps from above.
