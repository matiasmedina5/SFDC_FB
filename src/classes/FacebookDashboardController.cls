public with sharing class FacebookDashboardController {
    private String userAccessToken;
    
    public List<Friend> friends {get; set;}
    
    public FacebookDashboardController() {

    }
    
    public PageReference init() {

        // Get client code from the Facebook Url
        String clientCode = ApexPages.currentPage().getParameters().get('code');
        PageReference pageRef;
        HttpResponse res;
        
        try {
            // Get the user access token. It allows you get a lot of information from Facebook (eg: list of friends).
            res = makeRequest(FacebookConstants.USER_ACCESS_TOKEN_URI + clientCode, 'GET');
            // The user access token.
            String token = parseResponse(res.getBody(), 'access_token');
            // If code expired or some other issue, try to get a new user token.
            if (String.isBlank(token)) {
                pageRef = new PageReference(FacebookConstants.APP_CODE_URI);
                pageRef.setRedirect(true);
            } else {
                // Get application access token in order to validate the user token.
                String appAccessToken = getAppAccessToken(makeRequest(FacebookConstants.APP_ACCESS_TOKEN_URI, 'GET'));
                // Check if the user token is valid.
                res = makeRequest(String.format(FacebookConstants.VALIDATE_USER_TOKEN_URI, 
                        new String [] {token, appAccessToken}), 'GET');
                if (validateUserToken(res)) {
                    userAccessToken = token;
                }
            }
            
        } catch(System.CalloutException e) {
            System.debug(e.getStackTraceString());
        }
        
        return pageRef;
    }
    
    private String parseResponse(String body, String field) {
        String result;
        JSONParser parser = JSON.createParser(body);
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == field)) {
                parser.nextToken();
                result = parser.getText();
                break;
            }
        }
        return result;
    }
    
    private String getAppAccessToken(HttpResponse response) {
        Integer equalIndex = response.getBody().indexOf('|');
        String lastPartToken = response.getBody().substring(29, response.getBody().length());
        
        return FacebookConstants.CLIENT_ID + '|' + lastPartToken;
    }
    
    private Boolean validateUserToken(HttpResponse response) {
        Boolean result = false;
        if (parseResponse(response.getBody(), 'is_valid') == 'true') {
            result = true;
        }
        return result;
    }
    
    public void getFriends() {
        HttpResponse response;
        List<Friend> friendsWithTheApp = new List<Friend>();
            
        if (String.isNotBlank(userAccessToken)) {
            String url = 'https://graph.facebook.com/v2.8/me/friends?access_token=' + userAccessToken;
            response = makeRequest(url, 'GET');
            // Parse the 'data' array from the friend list that facebook retrieves
            JSONParser parser = JSON.createParser(response.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.START_ARRAY)) {
                    while (parser.nextToken()!= null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            friendsWithTheApp.add((Friend)parser.readValueAs(Friend.class));
                        }
                    }
                }
            }
            if (!friendsWithTheApp.isEmpty()) {
                friends = friendsWithTheApp;
            }
        }
    }
    
    private HttpResponse makeRequest(String url, String method) {
        // Instantiate a new http object
        HttpResponse res;
        Http h = new Http();
        // Instantiate a new HTTP request, specify the method as well as the endpoint
        HttpRequest req = new HttpRequest();
        
        try {
            req.setEndpoint(url);
            req.setMethod(method);
            
            // Send the request, and return a response
            res = h.send(req);
            
        } catch(System.CalloutException e) {
            System.debug(e.getStackTraceString());
        }
        return res;
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