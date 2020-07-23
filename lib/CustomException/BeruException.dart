class NoUserException implements Exception {
  String errMsg() => "No User Dectected Login";
}

class SighUpNotComplete implements Exception {
  String toString() => "User Must SignUp";
  int code() => 121;
}

class BeruFirebaseError implements Exception {
  String toString() => "FireBase Not Responding";
}

class BeruServerError implements Exception {
  String toString() => "Server Not Responding";
}

class BeruUnKnownError implements Exception {
  final String error;
  BeruUnKnownError({this.error});
  String toString() => error;
}

class BeruNoProductForSalles implements Exception {
  String toString() => "No Product Is Available For this Category";
}
