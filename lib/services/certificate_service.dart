import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_hogar/config/firebase_config.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Servicio de Generación de Certificados
class CertificateService {
  final FirebaseFirestore _firestore = FirebaseConfig.firestore;

  /// Generar certificado mensual en PDF
  Future<File?> generateMonthlyCertificate({
    required String userName,
    required double totalRecycled,
    required int totalPoints,
    required String community,
    required DateTime month,
  }) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // Encabezado
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 2),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'CERTIFICADO DE RECONOCIMIENTO',
                        style: pw.TextStyle(
                          fontSize: 28,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'EcoHogar - Programa de Reciclaje',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 30),
                // Contenido
                pw.Text(
                  'Se reconoce a:',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  userName,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Por su contribución al cuidado del medio ambiente',
                  style: pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 20),
                // Estadísticas
                pw.Container(
                  padding: const pw.EdgeInsets.all(15),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 1),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Estadísticas del Mes:',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Residuos Reciclados: ${totalRecycled.toStringAsFixed(2)} kg',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                      pw.Text(
                        'Puntos Acumulados: $totalPoints',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                      pw.Text(
                        'Mes: ${_monthName(month.month)} ${month.year}',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                      pw.Text(
                        'Comunidad: $community',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 30),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Column(
                      children: [
                        pw.Container(
                          width: 100,
                          height: 50,
                          decoration: pw.BoxDecoration(
                            border: pw.Border(top: pw.BorderSide(width: 1)),
                          ),
                        ),
                        pw.Text(
                          'Firma',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Container(
                          width: 100,
                          height: 50,
                          decoration: pw.BoxDecoration(
                            border: pw.Border(top: pw.BorderSide(width: 1)),
                          ),
                        ),
                        pw.Text(
                          'Sello Municipal',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );

      // Guardar PDF
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'Certificate_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      return file;
    } catch (e) {
      print('Error generando certificado: $e');
      return null;
    }
  }

  /// Obtener nombre del mes
  String _monthName(int month) {
    List<String> months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return months[month - 1];
  }
}
