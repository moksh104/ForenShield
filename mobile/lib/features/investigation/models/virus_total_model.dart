class VirusTotalModel {
  final String detectionRatio;
  final String riskLevel;
  final String fileHash;
  final String fileType;
  final String fileSize;
  final String firstSeen;
  final String lastAnalysis;
  final String malicious;
  final String suspicious;
  final String harmless;
  final String undetected;
  final String reputation;

  const VirusTotalModel({
    required this.detectionRatio,
    required this.riskLevel,
    required this.fileHash,
    required this.fileType,
    required this.fileSize,
    required this.firstSeen,
    required this.lastAnalysis,
    required this.malicious,
    required this.suspicious,
    required this.harmless,
    required this.undetected,
    required this.reputation,
  });

  factory VirusTotalModel.fromJson(Map<String, dynamic> json) {
    return VirusTotalModel(
      detectionRatio: json['Detection ratio'] ?? 'N/A',
      riskLevel: json['Risk level'] ?? 'N/A',
      fileHash: json['File hash'] ?? 'N/A',
      fileType: json['File type'] ?? 'N/A',
      fileSize: json['File size'] ?? 'N/A',
      firstSeen: json['First seen'] ?? 'N/A',
      lastAnalysis: json['Last analysis'] ?? 'N/A',
      malicious: json['Malicious'] ?? 'N/A',
      suspicious: json['Suspicious'] ?? 'N/A',
      harmless: json['Harmless'] ?? 'N/A',
      undetected: json['Undetected'] ?? 'N/A',
      reputation: json['Reputation'] ?? 'N/A',
    );
  }

  Map<String, String> toMap() {
    return {
      'Detection ratio': detectionRatio,
      'Risk level': riskLevel,
      'File hash': fileHash,
      'File type': fileType,
      'File size': fileSize,
      'First seen': firstSeen,
      'Last analysis': lastAnalysis,
      'Malicious': malicious,
      'Suspicious': suspicious,
      'Harmless': harmless,
      'Undetected': undetected,
      'Reputation': reputation,
    };
  }
}
