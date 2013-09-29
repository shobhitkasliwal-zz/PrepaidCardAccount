
@interface AppConstants : NSObject

/*    SERVICE Constants   */
#define SERVICE_BASE_URL @"https://test.prepaidcardstatus.com/MobileServices/JsonService.asmx/"
#define AUTHENTICATE_SERVICE_URL SERVICE_BASE_URL @"AuthenticateUser?UserName=%@&Password=%@&AuthenticationType=%@"
#define CREATE_CREDENTIAL_SERVICE_URL SERVICE_BASE_URL @"CreateLoginCredentials?UserName=%@&Password=%@"
#define ADD_CARD_TO_USER_SERVICE_URL SERVICE_BASE_URL @"AddCardToUserName?UserCredentialID=%@&CardNumber=%@&pin=%@"
#define FAQ_SERVICE_URL SERVICE_BASE_URL @"GetFaq?SiteconfigID=%@"

/*    SERVICE Constants   */

/* Other Constants */
#define INTERNET_NOT_AVAILABLE_POPUP_TEXT @"Please check your internet connection."
#define INTERNET_NOT_AVAILABLE_POPUP_TITLE @"Message."
#define LOGGEDIN_CREDENTIAL_KEY_USERNAME @"Username"
#define LOGGEDIN_CREDENTIAL_KEY_PASSWORD @"Password"
#define LOGGEDIN_CREDENTIAL_KEY_SELECTED_LOGIN_OPTION @"SelectedOption"
#define LOGGEDIN_OPTION_CARD @"LoginByCard"
#define LOGGEDIN_OPTION_USERNAME @"LoginByUsername"
#define LOGGEDIN_USERCREDNTIALID @"UserCredentialID"


#define  isTestEnvironment NO
/* Other Constants */


@end
