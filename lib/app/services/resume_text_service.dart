import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:xml/xml.dart';

class ResumeTextService {
  static Future<String> extractText(PlatformFile file) async {
    final bytes = file.bytes;
    if (bytes == null) {
      throw StateError(
        'Unable to extract text because file bytes are unavailable.',
      );
    }

    final extension = file.extension?.toLowerCase() ?? '';
    switch (extension) {
      case 'docx':
        return _extractDocxText(bytes);
      case 'pdf':
        return _extractPdfText(bytes);
      case 'doc':
        return _extractDocText(bytes);
      default:
        throw UnsupportedError('Unsupported resume format: $extension');
    }
  }

  static String _extractDocxText(Uint8List bytes) {
    final archive = ZipDecoder().decodeBytes(bytes, verify: true);
    final documentEntry = archive.files.firstWhere(
      (entry) => entry.name == 'word/document.xml',
      orElse: () => throw StateError('Missing document.xml in DOCX file.'),
    );

    final documentXml = utf8.decode(documentEntry.content as List<int>);
    final xmlDocument = XmlDocument.parse(documentXml);
    final paragraphs = xmlDocument.findAllElements('t');

    return paragraphs
        .map((node) => node.text)
        .join(' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String _extractPdfText(Uint8List bytes) {
    final pdfString = latin1.decode(bytes, allowInvalid: true);

    final textMatches = RegExp(r'\(([^)]*)\)').allMatches(pdfString);
    final extractedText = textMatches.map((match) => match.group(1)!).join(' ');

    return _normalizeText(extractedText);
  }

  static String _extractDocText(Uint8List bytes) {
    final rawText = latin1.decode(bytes, allowInvalid: true);
    final asciiText = rawText.replaceAll(RegExp(r'[^\x20-\x7E\r\n]'), ' ');

    return _normalizeText(asciiText);
  }

  static String _normalizeText(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
