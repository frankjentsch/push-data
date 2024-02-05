# Push Table Data Between Two Tenants of SAP BTP ABAP Environment
This Git repository provides an utility to push table data from one [SAP BTP ABAP Environment](https://community.sap.com/topics/btp-abap-environment)  (aka "Steampunk") tenant to another tenant. The code is compliant to [ABAP Cloud](https://community.sap.com/topics/abap) and can also be used in SAP S/4HANA Cloud, public edition.

The utility consists of two communication scenarios, one for **outbound** communication to push the data and the other one for **inbound** communication. A SAP Fiori app is provided to trigger the push and to display the outbound logs and the inbound logs of the performed data transfer.

The utility supports only *custom-defined* database tables, but not SAP-delivered database tables. All types of database tables are supported. Please consider the implications if you are upload data of client-independent tables, configuration or system tables.
