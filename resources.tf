
resource "azurerm_resource_group" "my_example"{
  name = "nan_resource_example"
  location = "East US"
}

resource "azurerm_storage_account" "mystorageexample"{
  name = "nanstorexample"
  location = "East US"
  account_replication_type = "LRS"
  account_tier = "Standard"
  resource_group_name = azurerm_resource_group.my_example.name
}

resource "azurerm_storage_container" "my_container_example"{
  name = "nan-container-example"
  storage_account_name = azurerm_storage_account.mystorageexample.name
  container_access_type = "private"
}

resource "azurerm_eventhub_namespace" "my_eh_namespace_example" {
  name                = "nan-example-namespace"
  resource_group_name = azurerm_resource_group.my_example.name
  location            = azurerm_resource_group.my_example.location
  sku                 = "Basic"
}

resource "azurerm_eventhub" "my_eventhub_example" {
  name                = "nan_example-eventhub"
  resource_group_name = azurerm_resource_group.my_example.name
  namespace_name      = azurerm_eventhub_namespace.my_eh_namespace_example.name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub_authorization_rule" "my_eventhubrule_example"{
  name = "nan_eventhub_example"
  eventhub_name = azurerm_eventhub.my_eventhub_example.name
  namespace_name = azurerm_eventhub_namespace.my_eh_namespace_example.name
  resource_group_name = azurerm_resource_group.my_example.name
  send                = true
}

resource "azurerm_virtual_network" "blue_virtual_network" {
  address_space = ["10.0.0.0/16"]
  location = "East US"
  name = "nan_virtual_network_example"
  resource_group_name = azurerm_resource_group.my_example.name
  dns_servers = ["10.0.0.4","10.0.0.5"]

  subnet {
    address_prefix = "10.0.1.0/24"
    name = "subnet1"
  }

  subnet {
    address_prefix = "10.0.2.0/24"
    name = "subnet2"
  }

  tags = {
    environment= "nan_finder"
  }
}

resource "azurerm_iothub" "myiot_example" {
  name                = "nan-Example-IoTHub"
  resource_group_name = azurerm_resource_group.my_example.name
  location            = azurerm_resource_group.my_example.location

  sku {
    name     = "S1"
    capacity = "1"
  }

  endpoint {
    type                       = "AzureIotHub.StorageContainer"
    connection_string          = azurerm_storage_account.mystorageexample.primary_blob_connection_string
    name                       = "export"
    batch_frequency_in_seconds = 60
    max_chunk_size_in_bytes    = 10485760
    container_name             = azurerm_storage_container.my_container_example.name
    encoding                   = "Avro"
    file_name_format           = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
  }

  endpoint {
    type              = "AzureIotHub.EventHub"
    connection_string = azurerm_eventhub_authorization_rule.my_eventhubrule_example.primary_connection_string
    name              = "export2"
  }

  route {
    name           = "export"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["export"]
    enabled        = true
  }

  route {
    name           = "export2"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["export2"]
    enabled        = true
  }

  tags = {
    purpose = "testing"
  }
}