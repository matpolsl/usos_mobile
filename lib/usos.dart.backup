import 'package:oauth1/oauth1.dart' as oauth1;

const usosApi = "https://usosapi.polsl.pl/";
var platform = oauth1.Platform(
  usosApi +
      'services/oauth/request_token?scopes=grades|studies|offline_access', // temporary credentials request
  usosApi + 'services/oauth/authorize', // resource owner authorization
  usosApi + 'services/oauth/access_token', // token credentials request
  oauth1.SignatureMethods.hmacSha1, // signature method
);
var clientCredentials = oauth1.ClientCredentials(
  'Consumer Key', //Api_Key
  'Consumer Secret', // Api Secret
);
var auth = oauth1.Authorization(clientCredentials, platform);
