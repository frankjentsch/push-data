# Push Table Data Between Two Tenants of SAP BTP ABAP Environment
This Git repository provides an utility to push table data from one [SAP BTP ABAP Environment](https://community.sap.com/topics/btp-abap-environment)  (aka "Steampunk") tenant to another tenant. The code is compliant to [ABAP Cloud](https://community.sap.com/topics/abap) and can also be used in SAP S/4HANA Cloud, public edition.

The utility consists of two communication scenarios, one for **outbound** communication to push the data and the other one for **inbound** communication. A SAP Fiori app is provided to trigger the push and to display the outbound logs and the inbound logs of the performed data transfer.

The utility supports only *custom-defined* database tables, but not SAP-delivered database tables. All types of database tables are supported. Please consider the implications if you are upload data of client-independent tables, configuration or system tables.

The utility represents example code. Feel free to extend it depending on your needs. Limitations of the current implementation are:
* The pushed data per database table **replaces** the existing data in the target tenant. There no other operations supported like **append** or **modify** (without deletion).
* The pushed data is transfered without paging. Therefore, the supported data volume is limited to the ABAP max. session size.

Please grant the authorizations for the utility carefully. Only the start authorization of the SAP Fiori app is checked. There is no further authorization check on table level. This utility is intended to be used by adminstators or key users only.

## Prerequisites
Make sure to fulfill the following requirements:
* You have access to an SAP BTP ABAP Environment instance (see [here](https://discovery-center.cloud.sap/serviceCatalog/abap-environment?region=all) or [here](https://help.sap.com/docs/sap-btp-abap-environment) for additional information).
* You have downloaded and installed ABAP Development Tools (ADT). Make sure to use the most recent version as indicated on the [installation page](https://tools.hana.ondemand.com/#abap). 
* You have created an ABAP Cloud Project in ADT that allows you to access your SAP BTP ABAP Environment instance (see [here](https://help.sap.com/docs/abap-cloud/abap-development-tools-user-guide/creating-abap-cloud-project) for additional information). Your log-on language is English.
* You have installed the [abapGit](https://github.com/abapGit/eclipse.abapgit.org) plug-in for ADT from the update site `http://eclipse.abapgit.org/updatesite/`.

## Download
Use the abapGit plug-in to install the **Push Table Data Between Two Tenants** by executing the following steps:
1. Open the Administrator's Fiori Launchpad and start the app **Maintain Software Components**. Create a new software component `ZPUSH` of type *Development*. Press the button *Clone* which creates the software component and the stucture package with the same name `ZPUSH` in the respective ABAP system (see [here](https://help.sap.com/docs/sap-btp-abap-environment/abap-environment/how-to-create-software-components) for additional information).
2. In your ABAP cloud project, create the ABAP package `ZPUSH_MAIN` (using the superpackage `ZPUSH`) as the target package for the utility to be downloaded (leave the suggested values unchanged when following the steps in the package creation wizard).
3. To add the <em>abapGit Repositories</em> view to the <em>ABAP</em> perspective, click `Window` > `Show View` > `Other...` from the menu bar and choose `abapGit Repositories`.
4. In the <em>abapGit Repositories</em> view, click the `+` icon to clone an abapGit repository.
5. Enter the following URL of this repository: `https://github.com/frankjentsch/dbtab-down-and-upload.git` and choose <em>Next</em>.
6. Select the branch <em>refs/heads/main</em> and enter the newly created package `ZPUSH_MAIN` as the target package and choose <em>Next</em>.
7. Create a new transport request that you only use for this utility installation (recommendation) and choose <em>Finish</em> to link the Git repository to your ABAP cloud project. The repository appears in the abapGit Repositories View with status <em>Linked</em>.
8. Right-click on the new ABAP repository and choose `Pull ...` to start the cloning of the repository content. Note that this procedure may take a few seconds. 

As a result of the installation procedure above, the ABAP system creates an inactive version of all artifacts for the utility. Further manual steps are required to finally use the utility. Please refer to the next section.

## Configuration

To activate all development objects from the `ZPUSH_MAIN` package: 
1. Click the mass-activation icon (<em>Activate inactive ABAP development objects</em>) in the toolbar.  
2. In the dialog that appears, select all development objects in the transport request (that you created for the utility installation) and choose `Activate`.

To transport the finally completed utility:
1. Release the task and transport via ADT view `Transport Organizer`. As a result of this release, the developed objects of that software component are written into a hidden Git repository.
2. Import the utility in a subsequent system: Open the Administrator's Fiori Launchpad of the subsequent system and start the app **Maintain Software Components**. Press the button *Clone* which imports all the released objects into the subsequent system.

## How it works

The basic approach is as follows:
* The push is based on a configured table group. A table group comprises 1 to many custom database tables.
* A SAP Fiori app in the *source* tenant (= *push* principle) shows the configured table groups and provides a button to *push* the data completely to a target tenant.
* The supported target tenants are determined based on the configured outbound Communication Arrangements of a certain Communication Scenario. The result is shown in a selection popup after pressing the *Push* button.
* The data transfer (push to the target tenant) is implemented by a Remote Function Call (RFC) using the respective Communication Scenario.
* The RFC execution in the target tenant replaces the data of all database tables of the pushed table group in the target tenant.
* The same SAP Fiori app can be used to see the log of all performed data transfers in the target tenant.

### Example

This Git repository contains also two database tables to test the data transfer:
* `ZEXAMPLE_TAB_1` - represents a typical table of a RAP Managed BO with UUID as primary key and different timestamp fields
* `ZEXAMPLE_TAB_2` - represents a table with a CHAR field as a primary key

Class `ZCL_EXAMPLE_TAB_GEN_TEST_DATA` is a console app which can be used to fill test data in the source tenant into these two tables.

### Configure Table Groups

A table group defines a collection of custom database tables which will be pushed as one action later in the SAP Fiori app. In our example, we define three table groups for the two example tables. The same database table can be used in different table groups. The table group name and description need to be maintained in system table `ZPUSH_TAB_GRP` and the assigned tables need to be maintained in system table `ZPUSH_TAB_GRP_I`. You can use class `ZCL_PUSH_TAB_GRP_TEST_DATA` to create these system table entries. 

Data preview of `ZPUSH_TAB_GRP`:

![](png/01%20-%20ZPUSH_TAB_GRP%20Data%20Preview.png)

Data preview of `ZPUSH_TAB_GRP_I`:

![](png/02%20-%20ZPUSH_TAB_GRP_I%20Data%20Preview.png)

### SAP Fiori App to Push the Data

a

## How to obtain support
This project is provided "as-is": there is no guarantee that raised issues will be answered or addressed in future releases.

