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
    - [3.2.2 AWS Deployment Profile](#322-aws-deployment-profile)
    - [3.2.3 GCP Deployment Profile](#323-gcp-deployment-profile)


# 1. Palo Alto Networks Professional Service Flex Licensing Migration Lab

<br/><br/>

## 1.1 Overview

The Following Lab guide will help you to understand how to migrate Non-Flex licensed Software Firewalls from Non-Flex license model (ELA, etc) to the new Flex License Model. It will also cover how to create Deployment profiles in the Customer Suport Portal (CSP) to cover several secanrios. The Lab will only cover Migration the in the following Public Cloud Providers.
1. Microsoft Azure
2. Amazon AWS
3. Google Cloud (GCP)

Private Cloud and other Public Cloud Providers will not be covered in the Lab.

<br/><br/>

## 1.2 Covered Secaniros
The following Secanrios and Lab activies are covered

1. Deploy a new Lab Panorama to fullfill the Migration process
2. Configure Panorama to perform the Lab activities
3. Setup the Customer support Portal (CSP)
4. Deploy Software Firewalls and License them with an ELA License
   1. 2 Firewalls in AWS
   2. 2 Firewalls in GCP
   3. 2 Firewalls in Azure
5. Onboard Firewalls into Panorama
6. Migrate Software Firewalls from NON-Flex License Model to Flex-License Model
   1. NON-Flex to Flex-License (Fixed Deployment Profile)
   2. Flex-License to Flex-License (Flexible Deployment Profile)
7. How to update the Deployment Profile
   1. Enable/Disable CDSS
   2. Increase/Decrease vCPU count
8. Troubleshooting

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

### 3.2.2 AWS Deployment Profile
1. On the Prisma NFGW Credits Pool click on Create Deployment Profile
   ![Screenshot 2023-04-28 at 10 34 00](https://user-images.githubusercontent.com/30934288/235103582-e0457306-91e1-41f7-9810-89e2e684e9df.png)
2. Select the following as shown on the picture below and click Next<br/>
   ![Screenshot 2023-04-28 at 10 35 37](https://user-images.githubusercontent.com/30934288/235103668-d6dca65f-7ad0-420f-89dc-4fdb0adadc14.png)
3. In the Deployment Profile use the following and replace Instructor-Lab under "Profile Name" with "AWS-Fixed-[StudentName]"
   ![Screenshot 2023-04-28 at 10 37 12](https://user-images.githubusercontent.com/30934288/235103752-1f1c0959-87a5-4654-bb76-03d472fad2b6.png)
4. Click "Create Deployment Profile"
5. Verify that your Deployment Profile is successfully created
   ![Screenshot 2023-04-28 at 10 40 09](https://user-images.githubusercontent.com/30934288/235103850-9cd1b2d9-f585-436a-bb9a-97c1d21a9b39.png)
<br/>

### 3.2.3 GCP Deployment Profile
1. On the Prisma NFGW Credits Pool click on Create Deployment Profile
   ![Screenshot 2023-04-28 at 10 34 00](https://user-images.githubusercontent.com/30934288/235103582-e0457306-91e1-41f7-9810-89e2e684e9df.png)
2. Select the following as shown on the picture below and click Next<br/>
   ![Screenshot 2023-04-28 at 10 35 37](https://user-images.githubusercontent.com/30934288/235103668-d6dca65f-7ad0-420f-89dc-4fdb0adadc14.png)
3. In the Deployment Profile use the following and replace Instructor-Lab under "Profile Name" with "GCP-Fixed-[StudentName]"
   ![Screenshot 2023-04-28 at 10 37 12](https://user-images.githubusercontent.com/30934288/235103752-1f1c0959-87a5-4654-bb76-03d472fad2b6.png)
4. Click "Create Deployment Profile"
5. Verify that your Deployment Profile is successfully created
   ![Screenshot 2023-04-28 at 10 40 09](https://user-images.githubusercontent.com/30934288/235103850-9cd1b2d9-f585-436a-bb9a-97c1d21a9b39.png)
<br/>
