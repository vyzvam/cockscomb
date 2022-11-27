# Identity & Access - Azure AD

## Working with Subscriptions

* Classic subscription administrator roles
* Account Admin - One per Azure account & has access to azure account center. Can manage all subscriptions in the account
* Service Admin - One per azure subscription. Can cancel the subsciption and managed services in azure portal.
* Co-Admin - equavilent to have user who is assignmed the owner role to the subscription level.

## Azure AD

A Cloud based identity and access management service.
Can create users and group in AAD. Can assign licenses for user.
Can give access to resources in Azure to users defined in AAD.
Can grant different roles to AAD users.

### AAD Free

Provides users and group management, On prem directry synchronization,
basic reports and self service password change for cloud users.

### AAD Premium P1

Hybrid users can acces cloud and on prem resources. Supports dynamic groups and write-back
capabilities and self service password reset for on prem users.

### AAD Premium P2

Provides AAD Identity protection and Privileged identity management

## Users and groups

### Users

You can create a usesname associated to the selectedable domain name.
assign first name and last name, assign to a group and asign a role.
you can create or auto generate a password for this users.

### Groups

You create by assigning a type , assigned, dynamic users / dynamic devices.
"Dynamic membership rules" is used to add users automatically to a dynamic group.

## Application

To grant an applicatin access to azure resources.
You can register an app in AAD which will created an app object and a service principal object.
The SP defines the access policy and permission for the user or app within AAD Tenant.

API permissions can be granted to the registered app. There are 2 types of permissions

* Delegated permission - for apps that have a signed-in user. the app has delegated permission to act as a signed in user to make api calls.
* Application permissions - used by apps that don't have a signed in user present such as a background service or daemons.

Goto AAD->App registration->New registration
supply a name
Choose either single tenant / multi tenant / multi tenant + personal MS accounts
Provide an optional redirect Url.

You can create certificates and secret under the Manage->Certifcates & Secrets blade
You can assign api permissions under the Manage->API Permissions blade




## Self service signup

When sharing an application with external users, you might not always know in advance who will need access to the application. As an alternative to sending invitations directly to individuals, you can allow external users to sign up for specific applications themselves by enabling self-service sign-up user flow. You can create a personalized sign-up experience by customizing the self-service sign-up user flow. For example, you can provide options to sign up with Azure AD or social identity providers and collect information about the user during the sign-up process.

### Howto

Sign in to the Azure portal as an Azure AD administrator.
Under Azure services, select Azure Active Directory.
Select User settings, and then under External users, select Manage external collaboration settings.
Set the Enable guest self-service sign up via user flows toggle to Yes.
