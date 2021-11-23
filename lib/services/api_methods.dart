Future<bool> signIn(String email, String password) async {
  //TODO send signIn to api

  try {
    // TODO send request to api
    return true;
  } catch (e) {
    //TODO return error to user
    // print(e.toString());
    return false;
  }
}

//not clean enough/ smooth enough for publish - but will work for now
Future<bool> register(String email, String password) async {
  //TODO send register to api

  try {
    //TODO call api
    return true;
  } catch (e) {
    //TODO return error to user
    // print(e.toString());
    return false;
  }
}
