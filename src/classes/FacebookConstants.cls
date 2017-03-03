public with sharing class FacebookConstants {
    public static String CODE_ERROR_MSG = 'This authorization code has been used.';
    public static String CLIENT_ID = '761699053909445';
    public static String CLIENT_SECRET = '8038ee52d83634eeda36b5f2b93fda1d';
    public static String APP_PERMISSIONS_REQUESTED = 'email,user_friends';
    public static String REDIRECT_URI = 'https://sftrainingexam-dev-ed--c.na30.visual.force.com/apex/'
            + 'FacebookDashboardApp';
    public static String APP_CODE_URI = 'https://www.facebook.com/v2.8/dialog/oauth?client_id=' + CLIENT_ID 
            + '&redirect_uri=' + REDIRECT_URI + '&response_type=code&scope=' + APP_PERMISSIONS_REQUESTED;
    public static String USER_ACCESS_TOKEN_URI = 'https://graph.facebook.com/v2.8/oauth/access_token?client_id=' 
            + CLIENT_ID + '&redirect_uri=' + REDIRECT_URI + '&client_secret=' + CLIENT_SECRET + '&code=';
    public static String APP_ACCESS_TOKEN_URI = 'https://graph.facebook.com/oauth/access_token?client_id=' 
            + CLIENT_ID + '&client_secret=' + CLIENT_SECRET + '&grant_type=client_credentials';
    public static String VALIDATE_USER_TOKEN_URI = 'https://graph.facebook.com/debug_token?input_token={0}' 
            + '&access_token={1}';
}