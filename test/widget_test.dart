import 'package:flutter_test/flutter_test.dart';
// Pastikan nama package ini sesuai dengan nama project-mu (project_moprog)
import 'package:project_moprog/main.dart';

void main() {
  testWidgets('App start smoke test', (WidgetTester tester) async {
    // Membangun aplikasi kita untuk proses testing
    await tester.pumpWidget(const ServisKlikApp());

    // Karena aplikasi kita sekarang mulai dari Splash Screen,
    // kita cukup memastikan aplikasinya bisa jalan (pump) tanpa error.
  });
}
