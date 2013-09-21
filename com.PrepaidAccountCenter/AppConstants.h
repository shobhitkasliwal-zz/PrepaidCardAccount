
@interface AppConstants : NSObject

/*    SERVICE Constants   */
#define SERVICE_BASE_URL @"https://test.prepaidcardstatus.com/MobileServices/JsonService.asmx/"
#define AUTHENTICATE_SERVICE_URL SERVICE_BASE_URL @"AuthenticateUser?UserName=%@&Password=%@&AuthenticationType=%@"

/*    SERVICE Constants   */

/* Other Constants */

#define LOGGEDIN_CREDENTIAL_KEY_USERNAME @"Username"
#define LOGGEDIN_CREDENTIAL_KEY_PASSWORD @"Password"
#define LOGGEDIN_CREDENTIAL_KEY_SELECTED_LOGIN_OPTION @"SelectedOption"
#define LOGGEDIN_OPTION_CARD @"LoginByCard"
#define LOGGEDIN_OPTION_USERNAME @"LoginByUsername"


#define  isTestEnvironment NO
/* Other Constants */


@end
