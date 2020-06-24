
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

  static String passStrengthValidator(String text){
    String err = Validator.notEmptyValidator(text, error: "Debe ingresar una contraseña");
    if(err == null){
      err = Validator.lengthValidator(text, 6, error: "La contraseña debe tener al menos 6 caracteres");
    }
    return err;
  }

  static String emailValidator(String text){
    String err = Validator.notEmptyValidator(text, error: "Debe ingresar un correo electrónico");
    if(err == null){
      RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
      if(!emailRegExp.hasMatch(text)){
        err = "Ingrese un correo electrónico válido";
      }
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
    var _error = (error != null ? error : "Este campo es requerido");
    if(text == null){
      return _error;
    }
    if(text.isEmpty){
      return _error;
    }
    return null;
  }
}