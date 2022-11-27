# Identity & Access - Privileged Identity Management

## Privileged Identity Management

* Provides Just in time privileged access to AAD & Azure resources.
* Time bound access to resources by using start and end date.
* Approval can be made before the the activation of the previleged roles.
* Ensure MFA is carried out to activate any role.
* Get notifacation when previleged roles are activated.
* Each user is assigned with AAD P P2 lincense.

Goto "Azure AD Privileged Identity Management"

Goto Manage->Azure AD Roles->Sign up for Azure AD Roles (must be global administrator)
it will authenticate , then back to the AD Roles screen and click signup

You can see the existing roles in the Managed->Roles.

Choose a role->Add member->Choose a member and add.
This member is now "Eligible" to be assigned to this role.

The member can login , go to PIM->My Roles and activate the role (under eligible roles)
Activation duration and reason needs to be specified.
After re-login the role is now activated as observed in the PIM->My Roles->Active roles

### Configure Role settings

In AAD Roles->Manage->Settings->Roles->Choose a Role.
You can configure Max activation duration, Notification, require incident/request ticket number, MFA, require approval,

### Azure Resources

In AAD Roles->Manage->Azure Resources->->discover resources->Choose subscription->Manage resource.

Click on the Resource (Subscription in this case)->Manage->Roles-Select a role.

You can now add member, assign either eligible or active, then start and end date.

The member can login and decide to activate the role.

The Azure Resources PIM also has similar settings to configure eligible criteria. (Activate, Assignment & Notification)