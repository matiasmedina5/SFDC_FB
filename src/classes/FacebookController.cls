public with sharing class FacebookController {

    public PageReference getCode() {
        // Get the app code in order to get user token to make api graph requests
        PageReference pageRef = new PageReference(FacebookConstants.APP_CODE_URI);
        pageRef.setRedirect(true);
        return pageRef;
    }

}