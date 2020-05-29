
abstract class Validator{
  static String userValidator(String text){
    return Validator.notEmptyValidator(text, error: "Debe ingresar un usuario");
  }

  static String passValidator(String text){
    String err = Validator.notEmptyValidator(text, error: "Debe ingresar una contraseña");
    if(err == null){
      err = Validator.lengthValidator(text, 4, error: "Contraseña inválida");
    }
    return err;
  }

  static String lengthValidator(String text, int length, {String error}){
    var _error = (error != null ? error : "La contraseña debe ser mayor a "+length.toString()+" caracteres.");
    if(text.length < length){
      return _error;
    }
    return null;
  }

  static String notEmptyValidator(String text, {String error}){
    var _error = (error != null ? error : "Debe ingresar un valor");
    if(text == null){
      return _error;
    }
    if(text.isEmpty){
      return _error;
    }
    return null;
  }
}