class Validators {
  // Validator pour email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  // Validator pour mot de passe
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  // Validator pour nom/prénom
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est requis';
    }
    if (value.length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    return null;
  }

  // Validator pour téléphone
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de téléphone est requis';
    }
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value.replaceAll(' ', ''))) {
      return 'Veuillez entrer un numéro valide (10 chiffres)';
    }
    return null;
  }

  // Validator pour titre
  static String? title(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le titre est requis';
    }
    if (value.length < 3) {
      return 'Le titre doit contenir au moins 3 caractères';
    }
    if (value.length > 100) {
      return 'Le titre ne peut pas dépasser 100 caractères';
    }
    return null;
  }

  // Validator pour libellé
  static String? label(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le libellé est requis';
    }
    if (value.length < 2) {
      return 'Le libellé doit contenir au moins 2 caractères';
    }
    if (value.length > 50) {
      return 'Le libellé ne peut pas dépasser 50 caractères';
    }
    return null;
  }

  // Validator pour description
  static String? description(String? value) {
    if (value == null || value.isEmpty) {
      return 'La description est requise';
    }
    if (value.length < 10) {
      return 'La description doit contenir au moins 10 caractères';
    }
    if (value.length > 1000) {
      return 'La description ne peut pas dépasser 500 caractères';
    }
    return null;
  }

  // Validator générique pour champ requis
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Ce champ'} est requis';
    }
    return null;
  }

  // Validator pour longueur minimale
  static String? minLength(String? value, int min, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Ce champ'} est requis';
    }
    if (value.length < min) {
      return '${fieldName ?? 'Ce champ'} doit contenir au moins $min caractères';
    }
    return null;
  }

  // Validator pour confirmer mot de passe
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer le mot de passe';
    }
    if (value != password) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }
}