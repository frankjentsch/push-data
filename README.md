# Push Table Data Between Two Tenants of SAP BTP ABAP Environment
This Git repository provides an utility to push table data from one [SAP BTP ABAP Environment](https://community.sap.com/topics/btp-abap-environment)  (aka "Steampunk") tenant to another tenant. The code is compliant to [ABAP Cloud](https://community.sap.com/topics/abap) and can also be used in SAP S/4HANA Cloud, public edition.

The utility consists of two communication scenarios, one for **outbound** communication to push the data and the other one for **inbound** communication. A SAP Fiori app is provided to trigger the push and to display the outbound logs and the inbound logs of the performed data transfer.

The utility supports only *custom-defined* database tables, but not SAP-delivered database tables. All types of database tables are supported. Please consider the implications if you are upload data of client-independent tables, configuration or system tables.

The utility represents example code. Feel free to extend it depending on your needs. Limitations of the current implementation are:
* The pushed data per database table **replaces** the existing data in trhe target tenant. There no other operations supported like **append** or **modify** (without deletion).
* The pushed data is transfered without paging. Therefore, the supported data volume is limited.

Please grant the authorizations for the utility carefully. Only the start authorization of the SAP Fiori app is checked. There is no further authorization check on table level. This utility is intended to be used by adminstators or key users only.

## Prerequisites
Make sure to fulfill the following requirements:
* You have access to an SAP BTP ABAP Environment instance (see [here](https://discovery-center.cloud.sap/serviceCatalog/abap-environment?region=all) or [here](https://help.sap.com/docs/sap-btp-abap-environment) for additional information).
* You have downloaded and installed ABAP Development Tools (ADT). Make sure to use the most recent version as indicated on the [installation page](https://tools.hana.ondemand.com/#abap). 
* You have created an ABAP Cloud Project in ADT that allows you to access your SAP BTP ABAP Environment instance (see [here](https://help.sap.com/viewer/5371047f1273405bb46725a417f95433/Cloud/en-US/99cc54393e4c4e77a5b7f05567d4d14c.html) for additional information). Your log-on language is English.
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
