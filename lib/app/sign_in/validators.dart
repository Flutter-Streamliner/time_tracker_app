abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator {

  @override
  bool isValid(String value) =>  value.isNotEmpty;

}

class EmailAndPasswordValidators {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
}