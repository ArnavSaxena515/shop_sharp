const databaseURL = "https://shop-sharp-default-rtdb.asia-southeast1.firebasedatabase.app/";
//const signUpURL = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=";
//const signInURL = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=";
// ignore: constant_identifier_names
const API_KEY = "AIzaSyAGzTP720XZI0v0-74CGLxsTS9V0mLTvm0";
enum authAction { signUp, login }

String generateURL(authAction action) {
  return "https://identitytoolkit.googleapis.com/v1/accounts:${action == authAction.signUp ? "signUp" : "signInWithPassword"}?key=$API_KEY";
}
