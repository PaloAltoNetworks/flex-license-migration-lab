![](https://lh4.googleusercontent.com/18oAPNp1uzZ6qY6bJxg2fWYWUEV-pQzNa_dSAqSp2lEjdg4hlEyLlQYc1OAowXxSqrp5Bk9iXRYOu-mECiqSr-gzo56d8QAh97VrfTbwX4uYN2ABB8BKM9XZK2mSzSXDN3qeHzp8xRsNHmALdeNEPiw)

![](https://lh3.googleusercontent.com/_-_DS9VDmI1QhI68JOiMchoWH7Bo1fqYn0qbD9Y24KH1T1zAG272HQy7cetrLxw3buJYbJEcj7TMjxv0CeWt-z1p4a3hl1FrNKPMROVo6L42XLIWFkjw_yPGlVTzhcPz1v2IB2JCUXMrAl4p2n9kbnY) 

- [1. Palo Alto Networks Azure Autoscaling Lab Guide](#1-palo-alto-networks-azure-autoscaling-lab-guide)
- [2. Overview](#2-overview)
  - [2.1. Environment Overview](#21-environment-overview)
  - [2.2. What You'll do in the whole Lab](#22-what-youll-do-in-the-whole-lab)
- [3. Deploy Panorama](#3-deploy-panorama)
  - [3.1. What you'll do](#31-what-youll-do)
  - [3.2. Deploy new Resource Group in Azure](#32-deploy-new-resource-group-in-azure)
  - [3.3. Deploy Panorama in Azure](#33-deploy-panorama-in-azure)
  - [3.3. Configure Panorama](#33-configure-panorama)
  - [3.4. Create Deployment Profile in Customer Support Portal (CSP)](#34-create-deployment-profile-in-customer-support-portal-csp)
  - [3.4. Configure Software License Plugin](#34-configure-software-license-plugin)
- [4. Deploy Azure environment](#4-deploy-azure-environment)
  - [4.1. What you'll need](#41-what-youll-need)
  - [4.2. Validate Deployment](#42-validate-deployment)
    - [4.2.1. What You'll Do](#421-what-youll-do)
- [5. Deploy Spoke Ressource](#5-deploy-spoke-ressource)
  - [5.1. What You'll Do](#51-what-youll-do)
    - [5.1.1. Deploy the Spoke Ressource Group](#511-deploy-the-spoke-ressource-group)
    - [5.1.2. Configure VNET peering](#512-configure-vnet-peering)
    - [5.1.3. Deploy Route Table](#513-deploy-route-table)
- [6. Congratulations!!!](#6-congratulations)
- [7. Lab Activity 2: Configure Panorama, Firewalls and Azure](#7-lab-activity-2-configure-panorama-firewalls-and-azure)
  - [7.1. Configure Panorama Template for VM-Series.](#71-configure-panorama-template-for-vm-series)
    - [7.1.1 Template / Interface Configuration](#711-template--interface-configuration)
    - [7.1.2 Template / Virtual Router Configuration](#712-template--virtual-router-configuration)
  - [7.2 Configure Panorama Device Group for VM-Series.](#72-configure-panorama-device-group-for-vm-series)
  - [7.3 Configure Webserver](#73-configure-webserver)
  - [7.4 Troubleshooting 1](#74-troubleshooting-1)
  - [7.5 Traffic Validation](#75-traffic-validation)
  - [7.6 Autoscaling Test](#76-autoscaling-test)
- [8. Congratulations!!!](#8-congratulations)
- [9. Useful information](#9-useful-information)
  - [9.1. Firewall Password/Username](#91-firewall-passwordusername)
  - [9.2. Firewall IP Information](#92-firewall-ip-information)
- [10. Cheating Section](#10-cheating-section)
  - [10.1. Troubleshooting](#101-troubleshooting)

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

# 2 Start