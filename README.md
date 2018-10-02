# README

This is the companion application to the [diaper](https://github.com/rubyforgood/diaper) app. The diaper app is an
inventory management system and this partner application handles the onboarding, approving, and handling of requests
from diaper banks from their partners. Diaper banks do not distribute diapers directly to the public, instead they
distribute diapers to partners like women's shelters, food pantries, homeless shelters, and other organizations.

The flow for partners being created, approved, and finally approved works as follows:

1) A diaper bank enters a new partner into the the diaper application.
    * The diaper app sends a post request to the partner app containing `organization_id`, `partner_id`, and 
    `email`. The organization id is the diaper bank id and the partner id is the partner id are the corresponding
    ids in the diaper app.
2) On receiving this post request, the partner app immediately sends an email to the new partner inviting them
to become a user.
3) The new potential partner fills out the details on about their organization, uploads required documentations
and then submits for approval.
    * A post request is sent to the diaper app updating the status of the partner to ready for review.
4) The diaper bank reviews and approves the partner.
    * A get request is made to the partner app to grab the relevant partner information for review.
    * After review, a post request is made to the partner app changing their status to approved.
5) The approved partner can now fill out requests for diapers to their diaper bank partner.
    * After a request is made a post request is made to the diaper app containing the requested diapers.
6) The diaper bank sees the request, approves it, and creates a distribution. Once the distribution is created
the partner gets an email notification stating their pick up date and a pdf copy of their invoice.

