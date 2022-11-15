# Managed identity and access

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

### MFA

IN AAD->Security, Manage->MFA->Additional MFA Cloud based settings
Can enable MFA for single or bulk users.

### AAD Identity Protection

Tool to automate the detection of identity based risks & remediation of such risks.

Go to "Azure AD Identity Protection"
Under "protect", you can set policy for user risk, sign in risk and MFA registration.

the user policies can control the action such as deny/block and requiest password change.
the sign in policies can control the action such as deny/block and inforce MFA.

### Conditional access policy

GO to AAD -> security -> Protect -> Conditional Access.
by default there are existing baseline policies.

Create policies by specifying name, assignments (users / groups), conditions & access control

* Allow users to access a resource only if the perform a certain action
* To add an extra layer of security when accessing application such as the azure portal.
* Can provide access to users based on certain signals
  * certain users or groups
  * IP Location
  * Devices
  * real-time and calculated risk detection

#### Named locations

Go to Conditional access -> Manage -> Named locations.

To control access to cloud apps based on the network location of the user
Mark a location as trusted.

#### Different risk levels

* Low - sign ins that occure from infected devices
* Medium - sign ins from unfamiliar or atypical locations, anonymous ip address
* High - Users with leaked credentials

#### License considerations

Capabilities depends on the AAD license.
identity protection risk policies, sign in risk policy from id protection & conditional acccess,
overview risk reports, risky users security reports, risky sign in risk reports, risk detection security reports
users at risks detected reports, weekly digest reports, MFA registration policy

### AAD Access review

Goto Identity governance -> Access reviews -> onboard.
Then can create an access review by specifying start date , frequency, end date & users/groups and reviewers .

### Privileged Identity Management

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


#### Configure Role settings

In AAD Roles->Manage->Settings->Roles->Choose a Role.
You can configure Max activation duration, Notification, require incident/request ticket number, MFA, require approval,

#### PIM Azure Resources

In AAD Roles->Manage->Azure Resources->->discover resources->Choose subscription->Manage resource.

Click on the Resource (Subscription in this case)->Manage->Roles-Select a role.

You can now add member, assign either eligible or active, then start and end date.

The member can login and decide to activate the role.

The Azure Resources PIM also has similar settings to configure eligible criteria. (Activate, Assignment & Notification)










