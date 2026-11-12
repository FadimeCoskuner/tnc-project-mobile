// JSON'daki teknik özellik anahtarlarının Türkçe karşılıkları.
const _labels = {
  'audio': 'Ses',
  'battery': 'Pil',
  'brightness': 'Parlaklık',
  'camera': 'Kamera',
  'cancellation': 'Gürültü engelleme',
  'carbon': 'Karbon',
  'case': 'Kasa',
  'chip': 'Çip',
  'colors': 'Renkler',
  'connectivity': 'Bağlantı',
  'control': 'Kontrol',
  'design': 'Tasarım',
  'display': 'Ekran',
  'driver': 'Sürücü',
  'feature': 'Özellik',
  'gps': 'GPS',
  'home': 'Akıllı ev',
  'id': 'Kimlik doğrulama',
  'material': 'Malzeme',
  'materials': 'Malzemeler',
  'os': 'İşletim sistemi',
  'pencil': 'Kalem',
  'ports': 'Bağlantı noktaları',
  'screen': 'Ekran',
  'sensing': 'Algılama',
  'size': 'Boyut',
  'weight': 'Ağırlık',
};

String specLabel(String key) {
  final label = _labels[key];
  if (label != null) return label;
  return key.isEmpty ? key : key[0].toUpperCase() + key.substring(1);
}
