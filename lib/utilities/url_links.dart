const databaseURL = "YOUR_FIREBASE_REALTIME_DATASTORE_URL_HERE";
const API_KEY = "YOUR_API_KEY";
enum authAction { signUp, login }

String generateURL(authAction action) {
  // URL FROM OFFICIAL FIREBASE API DOCS
  return "https://identitytoolkit.googleapis.com/v1/accounts:${action == authAction.signUp ? "signUp" : "signInWithPassword"}?key=$API_KEY";
}
