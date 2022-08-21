import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth.dart';

final credentials = ServiceAccountCredentials.fromJson(r'''
{
  "type": "service_account",
  "project_id": "nwl-mobile-app-calendar",
  "private_key_id": "3c925173c73496cb3db8f2086acb476bb4b1e605",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC3yS6b2BMBrNDl\n+1x49W6EuzbWZb/mBu1x/5pwJkRWJFdTveAib7IQZLDqgy1C1lOSnnBxY8J7+DaS\nDKNSZKkqAoHte33wMmyWNqv0F7sU2phDf7LxtZ50fyx8+p/AntoSIyn0xJvGQhTi\n92IpLa6KAIoaXDGkbluQIi/2FHGkPP/I9yUzzuGL74HBQ6+5BiEOLvgcM5pvHgm1\n7V2nprFn3m404tyDsrpOIGONIS9qPD0/6FswYtQfCPiZkwpbtggH4UH/dgtnLLkr\na1N6p6uc9j5eKbn7e5r2WwC3x1gkPutFbNCMT8N8UtXFhjeGH8udoLkXQ1V9Gal+\nPKrAb8gXAgMBAAECggEABEgT5Y//brCrM9zZI27sUMMRjolToQpbm8Kb362mUpL7\nRkead3Z3WoDcPO3xoMUZPuH2tjLf/OnO3lDVR2/HWKrdnuibe7UoIckSRnR82kL2\nxAWSy0/dv31CFUpmUFwjB1JA1vjW7fkkzWxf9ypJ1eFtjxqKhDDspWChLoVuvTYt\nzTthZga4+agAYdVx6lYYM8z/33d53OYNqIqiKBumPSlsAWOgXlZjbzzgyEk350lY\nXqsNf1ZtYLqej0kyiFJHj0siT/lqVY35GxJ94ZGK2Nud+bVp4oUGFQmQ9jIUwSsd\ng/ZsGCrEnlCq7v1+LC5Lsf1wmubK6JLok0xvxda6IQKBgQDjQ2Wz8eb53ggK7MMW\n7n88xF4nhWfUBsKaRfCw8pCCPmUU1cAIyWWvtHSS9nq9wdIBd0TqV6Fnl9yNxNll\nyg0J0NDP0fOy5+mluPaj7mlpckubrPVwsBA4+eqG4qMuVYYFKhwKhK7Qa4mSq5eD\nPBnAyHhTqnf66OECYT4r1L218QKBgQDPBmdmU+axmzjHgjQkf+3iIEq/2vZAvxO1\nRrDAJRs7FHD5g0QkPFNp+dg56m5MKdX0wzO5U/PGDtvngK/fq7McUaBpwd8JNhYV\nrNYcnlr9yC7dV4bjFLel0+JTh/xXBNP8Ckw8oAeVOqNOvysTnp7B9WcnwdAGTujj\nxrvEuEQ2hwKBgCk6Q8v2GVHA3rKkquuRDpIGiZIf2GsVYt47y+M9zcti6FF0SWcO\nqhzK3s7+Wdvsul07tsvQY954JTGuwUV+9wiN0iOxUcVl3vQKbuvkR0kyy9aM9OWh\nev/rDomzuaihKTPspLOfyFrU91sdN9o93+oiM/nxldx1vMQCwhWPfW7xAoGAIkFR\nAqGHXoPslTZ6Ij/4wJ3PQIeej4AOZsRXorOBGfl76A1MTSKeOr7YhFzB+2BAwss5\n18SIZZE32cp1T3E9pcXr4RPvL7r/VH7QvtOFAtEI0B8XdqOK76lrnZ62pj9qRB4A\nF1fzaUHWm8UN/6UTZ8yPUQjEvwZ3ipjroNVMlCkCgYB7hGOCXy0tYgDf39hwnXG8\nJ6nIbbwZpkDUZQlwb93dAik83UyzYe6OBz2cxA2Brm+L7gXm3USlp8zFLDjIx3Hz\n0jZdd5TjyRvebuJ/0b7nfCzi6PVlsxk3UEtVrnnuhvu0YqNvYZREkp6Qe4npXYPf\nJZ0Xv64X7xNEqL0Iddkw7g==\n-----END PRIVATE KEY-----\n",
  "client_email": "royaltouchapp@nwl-mobile-app-calendar.iam.gserviceaccount.com",
  "client_id": "111744632436063288190",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/royaltouchapp%40nwl-mobile-app-calendar.iam.gserviceaccount.com"
}
''');

const CalendarEventsScope = [
  CalendarApi.CalendarEventsScope,
  CalendarApi.CalendarScope,
  CalendarApi.CalendarEventsScope,
  CalendarApi.CalendarSettingsReadonlyScope,
  CalendarApi.CalendarReadonlyScope
];
