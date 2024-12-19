# Azure FrontDoor (AFD)

## References

* <https://www.youtube.com/watch?v=DHiZbIks9i0&ab_channel=JohnSavill%27sTechnicalTraining>
* <https://learn.microsoft.com/en-us/azure/frontdoor/front-door-traffic-acceleration?pivots=front-door-standard-premium>
* <https://azure.microsoft.com/en-us/pricing/details/frontdoor/>
* <https://learn.microsoft.com/en-us/azure/frontdoor/understanding-pricing>
* <https://github.com/MicrosoftDocs/azure-docs/blob/main/includes/front-door-limits.md>
* <https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits>
* <https://simonangling.com/azure-front-door-vanilla-standard-and-premium/>
* <https://learn.microsoft.com/en-us/azure/frontdoor/front-door-cdn-comparison>

## Summary

A global layer 7 load balancing solution.

Can serve public up/ dns as origins. Premium v2 also supports private endpoints as origins.

Azure has a wide network coverage which includes points-of-presense to deliver contents (CDN),
we can observe that AFD leverages on this PoP for it's service availability as well

<https://learn.microsoft.com/en-us/azure/cdn/cdn-pop-locations>
<https://learn.microsoft.com/en-us/azure/frontdoor/edge-locations-by-region>

Premium has additional support for CDN, WAF, Private Origin, Bot protection & Security Report
