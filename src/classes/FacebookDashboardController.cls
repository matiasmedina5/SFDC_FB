public with sharing class FacebookDashboardController {
    private String userAccessToken;
    private static String CODE_ERROR_MSG = 'This authorization code has been used.';
    private static String OAUTH_EXCEPTION = 'OAuthException';
    public List<Friend> friends {get; set;}
    
    public FacebookDashboardController() {
        System.debug('###controller');
    }
    
    public PageReference init() {
        System.debug('###init');
        // Get client code from the Facebook Url
        String clientCode = ApexPages.currentPage().getParameters().get('code');
        try {
            HttpResponse res;
            
            // Make this request to get the app access token in order to make another request to validate the user token
            String url = 'https://graph.facebook.com/v2.8/oauth/access_token?client_id=761699053909445&redirect_uri=https://sftrainingexam-dev-ed--c.na30.visual.force.com/apex/FacebookDashboardApp&client_secret=8038ee52d83634eeda36b5f2b93fda1d&code=' + clientCode;
            Http h = new Http();
        
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
        
            // Send the request, and return a response
            res = h.send(req);
            String token = parseResponse(res.getBody(), 'access_token');
            System.debug(token);
            if (String.isBlank(token)) {
                if (String.isNotBlank(parseResponse(res.getBody(), 'error')) 
                        && String.isNotBlank(parseResponse(res.getBody(), 'message'))
                        && parseResponse(res.getBody(), 'message') ==  CODE_ERROR_MSG) {
                        //&& String.isNotBlank(parseResponse(res.getBody(), 'type')) 
                        //&& parseResponse(res.getBody(), 'type') == OAUTH_EXCEPTION) {
                    System.debug('reload again');
                    return new PageReference('https://www.facebook.com/v2.8/dialog/oauth?client_id=761699053909445&redirect_uri=https://sftrainingexam-dev-ed--c.na30.visual.force.com/apex/FacebookDashboardApp&response_type=code&scope=email,user_friends');
                }
            }
            
            //-----------------------------------------------
            
            // Get application access token
            String appAccessToken = getAppAccessToken();
            //-----------------------------------------------
            String str = validateUserToken(token, appAccessToken);
            System.debug(str);
            if (parseResponse(str, 'is_valid') == 'true') {
                userAccessToken = token;
            }
            
            
        } catch(System.CalloutException e) {
            System.debug(e.getStackTraceString());
        }
        
        return null;
        
    }
    
    private String parseResponse(String body, String field) {
        String accessToken;
        // Parse JSON response to get all the totalPrice field values.
        JSONParser parser = JSON.createParser(body);
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == field)) {
                // Get the value.
                parser.nextToken();
                // Compute the grand total price for all invoices.
                accessToken = parser.getText();
                break;
            }
        }
        return accessToken;
    }
    
    private String getAppAccessToken() {
        HttpResponse resValidToken;
            
        // Make this request to get the app access token in order to make another request to validate the user token
        String urlValidateToken = 'https://graph.facebook.com/oauth/access_token?client_id=761699053909445&client_secret=8038ee52d83634eeda36b5f2b93fda1d&grant_type=client_credentials';
        Http httpValidToken = new Http();
    
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest reqValidToken = new HttpRequest();
        reqValidToken.setEndpoint(urlValidateToken);
        reqValidToken.setMethod('GET');
    
        // Send the request, and return a response
        resValidToken = httpValidToken.send(reqValidToken);
        Integer equalIndex = resValidToken.getBody().indexOf('|');
        String lastPartToken = resValidToken.getBody().substring(29, resValidToken.getBody().length());
        
        return '761699053909445|' + lastPartToken;
        //return resValidToken.getBody();
    }
    
    private String validateUserToken(String tokenToInspect, String appToken) {
        HttpResponse resValidToken;
            
        // Make this request to get the app access token in order to make another request to validate the user token
        String urlValidateToken = 'https://graph.facebook.com/debug_token?input_token=' + tokenToInspect + '&access_token=' + appToken;
        System.debug(urlValidateToken);
        Http httpValidToken = new Http();
    
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest reqValidToken = new HttpRequest();
        reqValidToken.setEndpoint(urlValidateToken);
        reqValidToken.setMethod('GET');
    
        // Send the request, and return a response
        resValidToken = httpValidToken.send(reqValidToken);
        return resValidToken.getBody();
    }
    
    public void getFriends() {
        HttpResponse response;
        List<Friend> myFriends = new List<Friend>();
            
        // Make this request to get the app access token in order to make another request to validate the user token
        if (String.isNotBlank(userAccessToken)) {
            String url = 'https://graph.facebook.com/v2.8/me/friends?access_token=' + userAccessToken;
            Http http = new Http();
    
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
    
            // Send the request, and return a response
            response = http.send(req);
            
            // Parse the 'data' array from the friend list that facebook retrieves
            JSONParser parser = JSON.createParser(response.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.START_ARRAY)) {
                    // Get the value.
                    while (parser.nextToken()!= null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            myFriends.add((Friend)parser.readValueAs(Friend.class));
                        }
                    }
                    
                }
            }
        }
        
        if (!myFriends.isEmpty()) {
            friends = myFriends;
            System.debug('###friends:' + friends);
        }

    }
    
    public class Friend {
        public String name {get; set;}
        public String id {get; set;}
        public Friend(String name, String id) {
            name = name;
            id = id;
        }
    }

}