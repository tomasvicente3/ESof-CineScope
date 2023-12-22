String? emailValidator(String? data) {
  if (data == null || data.isEmpty ) {
    return "You have to input with a valid email";
  }
  if (!RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
    .hasMatch(data)) {
      return "This is an invalid email...";
      }
  return null;
}


String? strongPasswordValidator(String? data){
  if (data == null || data.isEmpty ) {
    return "The password cannot be empty";
  }
  if(data.length < 8){
    return "It must contain at least 8 characters";
  }
  return null;
}