import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/report_case.dart';

/// Authoritative PDF Generator for ForenShield Incident Reports.
class IncidentReportPdfGenerator {
  const IncidentReportPdfGenerator._();

  static Future<void> exportAndPrint(ReportCase report) async {
    final doc = pw.Document(
      title: '${report.caseNumber} Incident Report',
      author: report.analyst,
      subject: report.title,
    );

    final PdfColor primary = PdfColor.fromInt(0xFF00E5FF);
    final PdfColor cardBg = PdfColor.fromInt(0xFF141C2E);
    final PdfColor textWhite = PdfColor.fromInt(0xFFF0F4FC);
    final PdfColor textMuted = PdfColor.fromInt(0xFF8A99AD);
    final PdfColor accentGold = PdfColor.fromInt(0xFFFFD700);

    PdfColor severityColor;
    switch (report.severity.toLowerCase()) {
      case 'critical':
        severityColor = PdfColor.fromInt(0xFFFF3366);
        break;
      case 'high':
        severityColor = PdfColor.fromInt(0xFFFF9900);
        break;
      case 'medium':
        severityColor = PdfColor.fromInt(0xFF00D2FF);
        break;
      default:
        severityColor = PdfColor.fromInt(0xFF00FF88);
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) {
          return pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 12),
            margin: const pw.EdgeInsets.only(bottom: 16),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey700, width: 0.8),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Row(
                  children: [
                    pw.Text(
                      'FORENSHIELD',
                      style: pw.TextStyle(
                        color: primary,
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Text(
                      '// INCIDENT INTELLIGENCE SYSTEM',
                      style: pw.TextStyle(
                        color: textMuted,
                        fontSize: 9,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                pw.Text(
                  'CONFIDENTIAL & AUTHORITATIVE',
                  style: pw.TextStyle(
                    color: severityColor,
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
        footer: (context) {
          return pw.Container(
            padding: const pw.EdgeInsets.only(top: 12),
            margin: const pw.EdgeInsets.only(top: 16),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(color: PdfColors.grey700, width: 0.8),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Report ID: ${report.id} · Generated: ${report.generatedAt}',
                  style: pw.TextStyle(color: textMuted, fontSize: 8),
                ),
                pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.TextStyle(color: textMuted, fontSize: 8),
                ),
              ],
            ),
          );
        },
        build: (context) => [
          // ── Title & Metadata Banner ──
          pw.Container(
            padding: const pw.EdgeInsets.all(14),
            decoration: pw.BoxDecoration(
              color: cardBg,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
              border: pw.Border.all(color: severityColor, width: 1.2),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: pw.BoxDecoration(
                        color: severityColor,
                        borderRadius: const pw.BorderRadius.all(
                          pw.Radius.circular(3),
                        ),
                      ),
                      child: pw.Text(
                        'SEVERITY: ${report.severity.toUpperCase()}',
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Text(
                      report.caseNumber,
                      style: pw.TextStyle(
                        color: primary,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  report.title,
                  style: pw.TextStyle(
                    color: textWhite,
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetaItem('CATEGORY', report.category, textMuted, textWhite),
                    _buildMetaItem('STATUS', report.status, textMuted, primary),
                    _buildMetaItem('ANALYST', report.analyst, textMuted, textWhite),
                    _buildMetaItem('SCORE', '${report.score}%', textMuted, accentGold),
                    _buildMetaItem('XP EARNED', '+${report.xpEarned} XP', textMuted, primary),
                  ],
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 16),

          // ── Executive Summary ──
          _buildSectionHeader('EXECUTIVE SUMMARY', primary),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: cardBg,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Text(
              report.summary,
              style: pw.TextStyle(
                color: textWhite,
                fontSize: 10,
                lineSpacing: 1.4,
              ),
            ),
          ),

          pw.SizedBox(height: 14),

          // ── Key Findings ──
          if (report.findings.isNotEmpty) ...[
            _buildSectionHeader('KEY FINDINGS & ATTACK VECTOR DIAGNOSIS', primary),
            ...report.findings.map(
              (f) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 5),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 5,
                      height: 5,
                      margin: const pw.EdgeInsets.only(top: 4, right: 8),
                      decoration: pw.BoxDecoration(
                        color: severityColor,
                        shape: pw.BoxShape.circle,
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        f,
                        style: pw.TextStyle(color: textWhite, fontSize: 9.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: 14),
          ],

          // ── Timeline Section ──
          if (report.timeline.isNotEmpty) ...[
            _buildSectionHeader('INVESTIGATION TIMELINE', primary),
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey800, width: 0.5),
              ),
              child: pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey800, width: 0.5),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey900),
                    children: [
                      _buildTableCell('Timestamp', isHeader: true, primary: primary),
                      _buildTableCell('Event Title', isHeader: true, primary: primary),
                      _buildTableCell('Severity', isHeader: true, primary: primary),
                      _buildTableCell('Details', isHeader: true, primary: primary),
                    ],
                  ),
                  ...report.timeline.map((t) => pw.TableRow(
                    children: [
                      _buildTableCell(t.timestamp, textMuted: textMuted),
                      _buildTableCell(t.title, textColor: textWhite),
                      _buildTableCell(t.severity, textColor: severityColor),
                      _buildTableCell(t.description, textMuted: textMuted),
                    ],
                  )),
                ],
              ),
            ),
            pw.SizedBox(height: 14),
          ],

          // ── Evidence Section ──
          if (report.evidence.isNotEmpty) ...[
            _buildSectionHeader('FORENSIC EVIDENCE ARTIFACTS', primary),
            ...report.evidence.map((ev) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 6),
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: cardBg,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                border: pw.Border.all(color: PdfColors.grey800, width: 0.5),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        '${ev.title} (${ev.type.toUpperCase()})',
                        style: pw.TextStyle(
                          color: primary,
                          fontSize: 9.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        ev.timestamp,
                        style: pw.TextStyle(color: textMuted, fontSize: 8),
                      ),
                    ],
                  ),
                  if (ev.content.isNotEmpty) ...[
                    pw.SizedBox(height: 4),
                    pw.Text(
                      ev.content,
                      style: pw.TextStyle(color: textWhite, fontSize: 8.5),
                    ),
                  ],
                ],
              ),
            )),
            pw.SizedBox(height: 14),
          ],

          // ── Remediation Actions ──
          if (report.remediationActions.isNotEmpty) ...[
            _buildSectionHeader('REMEDIATION & THREAT MITIGATION', primary),
            ...report.remediationActions.map(
              (action) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 5),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 5,
                      height: 5,
                      margin: const pw.EdgeInsets.only(top: 4, right: 8),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromInt(0xFF00FF88),
                        shape: pw.BoxShape.circle,
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        action,
                        style: pw.TextStyle(color: textWhite, fontSize: 9.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );

    // Launch native print/preview/share dialog
    await Printing.layoutPdf(
      onLayout: (format) async => doc.save(),
      name: 'ForenShield_${report.caseNumber.replaceAll('#', '')}_Report.pdf',
    );
  }

  static pw.Widget _buildSectionHeader(String title, PdfColor color) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.only(bottom: 4),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: color, width: 1.0),
        ),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  static pw.Widget _buildMetaItem(
    String label,
    String value,
    PdfColor labelColor,
    PdfColor valueColor,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            color: labelColor,
            fontSize: 7.5,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          value,
          style: pw.TextStyle(
            color: valueColor,
            fontSize: 9.5,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    PdfColor? primary,
    PdfColor? textColor,
    PdfColor? textMuted,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: isHeader
              ? (primary ?? PdfColors.cyanAccent)
              : (textColor ?? textMuted ?? PdfColors.white),
          fontSize: isHeader ? 8.5 : 8,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}
