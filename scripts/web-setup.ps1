Install-WindowsFeature -name Web-Server -IncludeManagementTools

# Deploy simple HTML
echo "<h1>Welcome to 3-Tier App</h1>" > C:\inetpub\wwwroot\index.html