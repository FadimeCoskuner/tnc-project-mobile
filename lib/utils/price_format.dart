/// Fiyatı "$1,299" ya da "$1,299.50" biçiminde yazar.
/// (intl paketi kullanmamak için basit bir biçimlendirici.)
String formatPrice(double value) {
  final totalCents = (value * 100).round();
  final whole = (totalCents ~/ 100).toString();
  final cents = totalCents % 100;

  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return cents == 0 ? '\$$buffer' : '\$$buffer.${cents.toString().padLeft(2, '0')}';
}
