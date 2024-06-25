function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    conduitBaseUrl: 'https://conduit-api.bondaracademy.com/api',
  };
  if (env == 'dev') {
    config.conduitUserEmail = 'jess@test.com';
    config.conduitUserPassword = 'KarateTest-123';
  }
  if (env == 'qa') {
    // customize
  }

  var conduitAccessToken = karate.callSingle(
    'classpath:helpers/CreateConduitToken.feature',
    config
  ).conduitAuthToken;
  karate.configure('headers', { Authorization: 'Token ' + conduitAccessToken });

  return config;
}
