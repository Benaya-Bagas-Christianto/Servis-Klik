import 'dart:convert';
import 'package:http/http.dart' as http;

class NvidiaService {
  final String apiKey =
      "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";
  final String endpoint =
      "https://integrate.api.nvidia.com/v1/chat/completions";

  Future<String> getSmartDiagnosis(String device, String complaint) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "meta/llama3-8b-instruct",
          "messages": [
            {
              "role": "system",
              "content":
                  "Kamu adalah teknisi laptop profesional. Analisis keluhan pengguna dan berikan diagnosa singkat (maksimal 2 kalimat) dalam bahasa Indonesia yang ramah, serta tindakan awal yang harus dilakukan.",
            },
            {
              "role": "user",
              "content": "Laptop saya $device. Keluhannya: $complaint",
            },
          ],
          "max_tokens": 150,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].toString().trim();
      } else {
        return "Gagal mendapatkan analisa AI. Teknisi kami akan mengeceknya secara manual.";
      }
    } catch (e) {
      return "Terjadi masalah jaringan. Pesanan Anda tetap diteruskan.";
    }
  }
}
