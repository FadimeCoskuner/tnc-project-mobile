import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/app.dart';

/// Testleri gerçek bir telefon ekranı boyutunda (360x780) çalıştırır.
void usePhoneScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  // rootBundle okunan dosyaları önbellekte tutar; önceki testin önbelleği
  // sonraki testte takılmaya yol açtığı için her testten önce temizlenir.
  setUp(rootBundle.clear);

  testWidgets('katalog yüklenir, arama yapılır, ürün sepete eklenir', (tester) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const MiniKatalogApp());
    await tester.pumpAndSettle();

    expect(find.text('Keşfet'), findsOneWidget);
    expect(find.text('20 ürün'), findsOneWidget);

    // Arama
    await tester.enterText(find.byType(TextField), 'airpods');
    await tester.pumpAndSettle();
    expect(find.text('2 ürün'), findsOneWidget);
    expect(find.text('AirPods Max'), findsOneWidget);

    // Detay sayfası (Route Arguments); kart önce görünür alana kaydırılır.
    await tester.ensureVisible(find.text('AirPods Max'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('AirPods Max'));
    await tester.pumpAndSettle();
    expect(find.text('Açıklama'), findsOneWidget);
    expect(find.text('\$549'), findsOneWidget);

    // Sepete ekle ve sepet sayfasında toplamı gör
    await tester.tap(find.text('Sepete ekle'));
    await tester.pumpAndSettle();
    expect(find.text('Sepete ekle (sepette 1 adet)'), findsOneWidget);

    await tester.tap(find.byTooltip('Sepetim'));
    await tester.pumpAndSettle();
    expect(find.text('Toplam (1 ürün)'), findsOneWidget);

    await tester.tap(find.byTooltip('Artır'));
    await tester.pumpAndSettle();
    expect(find.text('Toplam (2 ürün)'), findsOneWidget);
    expect(find.text('\$1,098'), findsWidgets);
  });

  testWidgets('kategori çiplerinin yazısı seçili olsa da olmasa da görünür', (tester) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const MiniKatalogApp());
    await tester.pumpAndSettle();

    // Ekranda gerçekten çizilen yazının rengi (çipin uyguladığı stil dahil).
    Color? labelColor(String label) => tester
        .renderObject<RenderParagraph>(
          find.descendant(of: find.widgetWithText(ChoiceChip, label), matching: find.text(label)),
        )
        .text
        .style
        ?.color;

    expect(labelColor('Tümü'), Colors.white); // seçili: siyah zemin üstünde beyaz
    expect(labelColor('iPhone'), Colors.black87); // seçili değil: beyaz zemin üstünde koyu
  });

  testWidgets('kategori filtresi ve boş arama sonucu', (tester) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const MiniKatalogApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'Mac'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Mac'));
    await tester.pumpAndSettle();
    expect(find.text('5 ürün'), findsOneWidget);

    await tester.dragUntilVisible(find.byType(TextField), find.byType(ListView).first, const Offset(0, 300));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'olmayan ürün');
    await tester.pumpAndSettle();
    expect(find.text('Sonuç bulunamadı'), findsOneWidget);

    await tester.ensureVisible(find.text('Filtreleri temizle'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Filtreleri temizle'));
    await tester.pumpAndSettle();
    expect(find.text('20 ürün'), findsOneWidget);
  });
}
