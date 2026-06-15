gh repo clone kineticadvantagedev/auction-access-worker$appName = "Comms Hub Api Support"
$app = New-MgApplication -DisplayName $appName -SignInAudience "AzureADMyOrg"

Update-MgApplication -ApplicationId $app.Id -RequiredResourceAccess @(
	@{
		ResourceAppId  = '00000003-0000-0000-c000-000000000000'
		ResourceAccess = @(
			@{
				Id   = "bc024368-1153-4739-b217-4326f2e966d0"
				Type = "Scope"
			},
			@{
				Id   = "14dad69e-099b-42c9-810b-d002981feec1"
				Type = "Scope"
			},
			@{
				Id   = "64a6cdd6-aab1-4aaf-94b8-3cc8405e90d0"
				Type = "Scope"
			},
			@{
				Id   = "37f7f235-527c-4136-accd-4a02d197296e"
				Type = "Scope"
			},
			@{
				Id   = "06da0dbc-49e2-44d2-8312-53f166ab848a"
				Type = "Scope"
			},
			@{
				Id   = "5f8c59db-677d-491f-a6b8-5f174b11ec1d"
				Type = "Scope"
			},
			@{
				Id   = "a154be20-db9c-4678-8ab7-66f6cc099a59"
				Type = "Scope"
			},
			@{
				Id   = "b340eb25-3456-403f-be2f-af7a0d370277"
				Type = "Scope"
			},
			@{
				Id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
				Type = "Scope"
			},
			@{
				Id   = "98830695-27a2-44f7-8c18-0c3ebc9698f6"
				Type = "Role"
			},
			@{
				Id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61"
				Type = "Role"
			},
			@{
				Id   = "5b567255-7703-4780-807c-7be8301ae99b"
				Type = "Role"
			},
			@{
				Id   = "df021288-bdef-4463-88db-98f22de89214"
				Type = "Role"
			}
		)
	}
)

$idTokenClaims = @(
	@{
		additionalProperties = @()
		essential            = $false
		name                 = "given_name"
		source               = $null
	},
	@{
		additionalProperties = @(
			"sam_account_name"
		)
		essential            = $false
		name                 = "groups"
		source               = $null
	}
)

$accessToken = @(
	@{
		additionalProperties = @()
		essential            = $false
		name                 = "email"
		source               = $null
	},
	@{
		additionalProperties = @()
		essential            = $false
		name                 = "acct"
		source               = $null
	},
	@{
		additionalProperties = @()
		essential            = $false
		name                 = "given_name"
		source               = $null
	},
	@{
		additionalProperties = @(
			"sam_account_name"
		)
		essential            = $false
		name                 = "groups"
		source               = $null
	}
)

$saml2Token = @(
	@{
		additionalProperties = @(
			"sam_account_name"
		)
		essential            = $false
		name                 = "groups"
		source               = $null
	}
)

$optionalClaims = @{
	idToken     = $idTokenClaims
	accessToken = $accessToken # Add claims for access token if needed
	saml2Token  = $saml2Token # Add claims for SAML token if needed
}

Update-MgApplication -ApplicationId $app.Id -OptionalClaims $optionalClaims

$appIdUri = "api://$($App.AppId)"
Update-MgApplication -ApplicationId $app.Id -IdentifierUris $appIdUri

<#
$app2 = get-mgapplication -ApplicationId $app.Id

$scopeName = "api-access" # Example scope name
$adminConsentDisplayName = "Access your API"
$adminConsentDescription = "Allows the application to access your API on behalf of the signed-in user."

# Create an OAuth2PermissionScope object
$newScope = New-Object -TypeName Microsoft.Open.AzureAD.Model.OAuth2PermissionScope
$newScope.AdminConsentDisplayName = $adminConsentDisplayName
$newScope.AdminConsentDescription = $adminConsentDescription
$newScope.Id = [guid]::NewGuid() # Generate a new GUID for the scope
$newScope.IsEnabled = $true
$newScope.Type = "user" # Or "User" depending on consent requirements
$newScope.Value = $scopeName

# Add the new scope to the application's existing OAuth2 permissions
$existingPermissions = $App2.Api.OAuth2PermissionScopes
$updatedPermissions = @($existingPermissions) + @($newScope)

# Update the application with the new permissions
update-MgApplication -ApplicationId $app.Id -ApiPermissions $updatedPermissions
#>