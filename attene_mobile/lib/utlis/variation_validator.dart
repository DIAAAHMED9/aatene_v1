class ValidationResult {
  final bool isValid;
  final String errorMessage;

  ValidationResult({required this.isValid, required this.errorMessage});
}

class VariationValidator {
  static ValidationResult validateVariations(
    bool hasVariations,
    List<dynamic> selectedAttributes,
    List<dynamic> variations,
  ) {
    if (hasVariations && selectedAttributes.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'يرجى إضافة السمات أولاً',
      );
    }

    if (hasVariations && variations.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'يرجى إنشاء قيم الاختلافات أولاً',
      );
    }

    for (final variation in variations) {
      if (variation.price <= 0) {
        return ValidationResult(
          isValid: false,
          errorMessage: 'يرجى إدخال سعر صحيح لجميع الاختلافات',
        );
      }
    }

    return ValidationResult(isValid: true, errorMessage: '');
  }
}