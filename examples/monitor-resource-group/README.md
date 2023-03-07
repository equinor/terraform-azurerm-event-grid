# Monitor resource group

Example Terraform configuration which shows how to setup Event Grid to send resource group events to a Storage queue for further processing.

This example uses a Storage queue endpoint for the following reasons:

- The Azure Function endpoint requires a response from an existing Azure Function, which means that an Azure Function would have to be deployed.
- The webhook endpoint requires a response from an existing webhook, which means that a remote webhook would have to be created.
