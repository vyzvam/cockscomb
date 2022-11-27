# Identity & Access - MFA & identity protection

## MFA

IN AAD->Security, Manage->MFA->Additional MFA Cloud based settings
Can enable MFA for single or bulk users.

## AAD Identity Protection

Tool to automate the detection of identity based risks & remediation of such risks.

Go to "Azure AD Identity Protection"
Under "protect", you can set policy for user risk, sign in risk and MFA registration.

the user policies can control the action such as deny/block and requiest password change.
the sign in policies can control the action such as deny/block and inforce MFA.

## Conditional access policy

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

### Named locations

Go to Conditional access -> Manage -> Named locations.

To control access to cloud apps based on the network location of the user
Mark a location as trusted.

### Different risk levels

* Low - sign ins that occure from infected devices
* Medium - sign ins from unfamiliar or atypical locations, anonymous ip address
* High - Users with leaked credentials

#### Notes

Exclude action overrides an include in policy
<https://learn.microsoft.com/en-us/azure/active-directory/conditional-access/concept-conditional-access-users-groups#exclude-users>

### License considerations

Capabilities depends on the AAD license.
identity protection risk policies, sign in risk policy from id protection & conditional acccess,
overview risk reports, risky users security reports, risky sign in risk reports, risk detection security reports
users at risks detected reports, weekly digest reports, MFA registration policy

### AAD Access review

Goto Identity governance -> Access reviews -> onboard.
Then can create an access review by specifying start date , frequency, end date & users/groups and reviewers.