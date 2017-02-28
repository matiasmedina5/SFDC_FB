public with sharing class FacebookController {
    
    public String accessToken {set;}
    
    public PageReference getCode() {
        // Get the app code in order to get user token to make api graph requests
        String url = 'https://www.facebook.com/v2.8/dialog/oauth?client_id=761699053909445&redirect_uri=https://sftrainingexam-dev-ed--c.na30.visual.force.com/apex/FacebookDashboardApp&response_type=code&scope=email,user_friends';
        PageReference pr = new PageReference(url);
        pr.setRedirect(true);
        return pr;
        /*HttpResponse res;
        try {
            // Instantiate a new http object
            String url = 'https://www.facebook.com/v2.8/dialog/oauth?client_id=761699053909445&redirect_uri=https://sftrainingexam-dev-ed--c.na30.visual.force.com/apex/FacebookDashboardApp&response_type=token&scope=email,user_friends';
            Http h = new Http();
        
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
        
            // Send the request, and return a response
            res = h.send(req);
            
        } catch(System.CalloutException e) {
            System.debug(e.getStackTraceString());
        }*/
        //System.debug(res.getHeader('Location'));
        //PageReference pr = new PageReference(res.getHeader('Location'));
        
    }
    
    /*public void validateAccessToken() {
        try {
            HttpResponse res;
            
            // Make this request to get the app access token in order to make another request to validate the user token
            String url = 'https://graph.facebook.com/oauth/access_token?client_id=761699053909445&client_secret=8038ee52d83634eeda36b5f2b93fda1d&grant_type=client_credentials';
            Http h = new Http();
        
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
        
            // Send the request, and return a response
            res = h.send(req);
            
            
            // Validate
            
        } catch(System.CalloutException e) {
            System.debug(e.getStackTraceString());
        }
    }*/
    
    /*private HttpResponse validateAccessToken(String appToken) {
    }*/
    

}