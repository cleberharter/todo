# Recursos de backend (App Service) e frontend (Static Web App) de um único ambiente.
resource "azurerm_resource_group" "env" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location
}

resource "azurerm_service_plan" "backend" {
  name                = "asp-${var.project_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.env.name
  location            = azurerm_resource_group.env.location
  os_type             = "Linux"
  sku_name            = var.app_service_sku
}

resource "azurerm_linux_web_app" "backend" {
  name                = "app-${var.project_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.env.name
  location            = azurerm_resource_group.env.location
  service_plan_id     = azurerm_service_plan.backend.id

  site_config {
    application_stack {
      docker_image_name        = "todo-backend:${var.image_tag}"
      docker_registry_url      = "https://${data.terraform_remote_state.shared.outputs.acr_login_server}"
      docker_registry_username = data.terraform_remote_state.shared.outputs.acr_admin_username
      docker_registry_password = data.terraform_remote_state.shared.outputs.acr_admin_password
    }
  }

  app_settings = {
    ASPNETCORE_ENVIRONMENT = var.environment
    WEBSITES_PORT          = "5140"
  }
}

resource "azurerm_static_web_app" "frontend" {
  name                = "swa-${var.project_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.env.name
  location            = azurerm_resource_group.env.location
  sku_tier            = var.static_web_app_sku_tier
  sku_size            = var.static_web_app_sku_tier
}
