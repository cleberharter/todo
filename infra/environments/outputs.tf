output "backend_hostname" {
  value = azurerm_linux_web_app.backend.default_hostname
}

output "static_web_app_hostname" {
  value = azurerm_static_web_app.frontend.default_host_name
}

output "static_web_app_api_key" {
  value     = azurerm_static_web_app.frontend.api_key
  sensitive = true
}
