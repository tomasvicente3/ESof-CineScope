
import 'package:cinescope/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("EmailValidator", () { 
    test(" valid emails", (){
      expect(emailValidator("luis.duarte.2003.13@hotmail.com"), null);
      expect(emailValidator("luis.duarte.2003.13@hotmail.com.pt"), null);
      expect(emailValidator("luis.duarte.2003.13+uni@hotmail.com.pt"), null);
      expect(emailValidator("up202108734@fe.up.pt"), null);
    });

    test( "invalid emails", () {
      expect(emailValidator(null), "You have to input with a valid email");
      expect(emailValidator("ola"), "This is an invalid email...");
      expect(emailValidator("ola@gmail"), "This is an invalid email...");



    });
  });
}