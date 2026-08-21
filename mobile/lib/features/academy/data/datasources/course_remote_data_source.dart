import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';

/// Remote Data Source for Cyber Academy API calls.
class CourseRemoteDataSource {
  final ApiClient _apiClient;

  const CourseRemoteDataSource(this._apiClient);

  /// Fetches courses list from API.
  Future<List<CourseModel>> getCourses({
    String? category,
    String? searchQuery,
  }) async {
    if (ApiConfig.useMockApi) {
      return _getFallbackCourses(category: category, searchQuery: searchQuery);
    }
    final response = await _apiClient.get<List<dynamic>>(
      '/academy_courses.php',
      queryParameters: {
        if (category != null && category != 'All') 'category': category,
        if (searchQuery != null && searchQuery.isNotEmpty) 'q': searchQuery,
      },
    );
    if (response.data != null) {
      return response.data!
          .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw const ApiException('Invalid courses data received');
  }

  /// Fetches course details.
  Future<CourseModel> getCourseDetail(String courseId) async {
    if (ApiConfig.useMockApi) {
      final all = _getFallbackCourses();
      return all.firstWhere((c) => c.id == courseId, orElse: () => all.first);
    }
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/academy_course_detail.php',
      queryParameters: {'id': courseId},
    );
    if (response.data != null) {
      return CourseModel.fromJson(response.data!);
    }
    throw const ApiException('Invalid course details received');
  }

  /// Fetches lesson details.
  Future<LessonModel> getLesson(String lessonId) async {
    if (ApiConfig.useMockApi) {
      return _fallbackLesson;
    }
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/academy_lesson.php',
      queryParameters: {'id': lessonId},
    );
    if (response.data != null) {
      return LessonModel.fromJson(response.data!);
    }
    throw const ApiException('Invalid lesson details received');
  }

  /// Submits quiz answers.
  Future<int> submitQuiz({
    required String quizId,
    required Map<String, int> selectedOptions,
  }) async {
    if (ApiConfig.useMockApi) {
      return 85;
    }
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/academy_quiz_submit.php',
      data: {'quiz_id': quizId, 'answers': selectedOptions},
    );
    if (response.data != null && response.data!['score'] != null) {
      return response.data!['score'] as int;
    }
    throw const ApiException('Invalid quiz submission response');
  }

  static final LessonModel _fallbackLesson = LessonModel(
    id: 'les_101',
    title: 'Digital Forensics Acquisition Techniques',
    durationMinutes: 20,
    contentType: 'text',
    contentText:
        'Memory forensics is the analysis of an acquired memory dump from a physical machine. When investigating an active C2 infection, RAM artifacts contain unencrypted network sockets, injected DLLs, and plaintext credentials.',
    imageUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5',
    codeSnippet:
        '# Run Volatility 3 plugin for Windows processes\npython3 vol.py -f memory.raw windows.pslist\npython3 vol.py -f memory.raw windows.netscan',
    codeLanguage: 'bash',
    checklist: const [
      LessonChecklistItemModel(
        id: 'chk_1',
        label: 'Verify raw RAM image SHA256 checksum',
        isChecked: true,
      ),
      LessonChecklistItemModel(
        id: 'chk_2',
        label: 'Identify suspicious PID from netscan output',
        isChecked: false,
      ),
      LessonChecklistItemModel(
        id: 'chk_3',
        label: 'Dump process executable for YARA scanning',
        isChecked: false,
      ),
    ],
    isCompleted: false,
    order: 1,
    quizId: 'qz_101',
  );

  static List<CourseModel> _getFallbackCourses({
    String? category,
    String? searchQuery,
  }) {
    final list = [
      CourseModel(
        id: 'crs_1',
        title: 'Digital Forensics Fundamentals',
        description:
            'Learn the basics of digital evidence, acquisition, and analysis techniques.',
        category: 'Digital Forensics',
        difficulty: 'Beginner',
        durationMinutes: 150,
        instructorName: 'Dr. Alex Vance',
        thumbnailUrl: '',
        prerequisites: const ['Basic OS Concepts', 'Command Line Proficiency'],
        learningOutcomes: const [
          'Acquire disk and memory evidence safely',
          'Identify file system artifacts',
          'Analyze browser & system logs',
        ],
        modules: List.generate(
          12,
          (i) => ModuleModel(
            id: 'mod_${i + 1}',
            title: 'Module ${i + 1}: Forensics Core Concepts',
            description: 'Essential techniques for evidence handling.',
            lessons: [_fallbackLesson],
            order: i + 1,
          ),
        ),
        isEnrolled: true,
        completionPercentage: 0.75,
        totalXp: 500,
      ),
      CourseModel(
        id: 'crs_2',
        title: 'Malware Analysis Essentials',
        description:
            'Understand malware behavior, static & dynamic analysis and reverse engineering.',
        category: 'Malware Analysis',
        difficulty: 'Intermediate',
        durationMinutes: 190,
        instructorName: 'Elena Rostova',
        thumbnailUrl: '',
        prerequisites: const ['Assembly Basics', 'C Programming'],
        learningOutcomes: const [
          'Static PE header analysis',
          'Dynamic sandbox behavior tracking',
          'Decompiling binaries with Ghidra',
        ],
        modules: List.generate(
          15,
          (i) => ModuleModel(
            id: 'mod_${i + 1}',
            title: 'Module ${i + 1}: Reverse Engineering',
            description: 'Analyzing malicious payloads.',
            lessons: [_fallbackLesson],
            order: i + 1,
          ),
        ),
        isEnrolled: true,
        completionPercentage: 0.45,
        totalXp: 650,
      ),
      CourseModel(
        id: 'crs_3',
        title: 'Phishing Detection & Prevention',
        description:
            'Identify phishing attacks, analyze techniques and stay protected.',
        category: 'Phishing Detection',
        difficulty: 'Intermediate',
        durationMinutes: 140,
        instructorName: 'Marcus Thorne',
        thumbnailUrl: '',
        prerequisites: const ['Email Protocols', 'SPF/DKIM/DMARC Basics'],
        learningOutcomes: const [
          'Analyze email headers & MIME structures',
          'Extract suspicious URLs & attachments',
          'Implement defense rules',
        ],
        modules: List.generate(
          10,
          (i) => ModuleModel(
            id: 'mod_${i + 1}',
            title: 'Module ${i + 1}: Phishing Vectors',
            description: 'Social engineering countermeasures.',
            lessons: [_fallbackLesson],
            order: i + 1,
          ),
        ),
        isEnrolled: true,
        completionPercentage: 0.30,
        totalXp: 450,
      ),
      CourseModel(
        id: 'crs_4',
        title: 'Network Security Fundamentals',
        description:
            'Learn networking concepts, common vulnerabilities and defense strategies.',
        category: 'Network Security',
        difficulty: 'Beginner',
        durationMinutes: 200,
        instructorName: 'Sarah Jenkins',
        thumbnailUrl: '',
        prerequisites: const ['TCP/IP Fundamentals'],
        learningOutcomes: const [
          'Configure firewalls & IDS/IPS',
          'Analyze Wireshark PCAP files',
          'Detect scanning & intrusion attempts',
        ],
        modules: List.generate(
          8,
          (i) => ModuleModel(
            id: 'mod_${i + 1}',
            title: 'Module ${i + 1}: Network Defense',
            description: 'Securing network infrastructure.',
            lessons: [_fallbackLesson],
            order: i + 1,
          ),
        ),
        isEnrolled: true,
        completionPercentage: 0.60,
        totalXp: 550,
      ),
      CourseModel(
        id: 'crs_5',
        title: 'Linux Forensics',
        description:
            'Master Linux systems, logs, artifacts and forensic techniques.',
        category: 'Linux Forensics',
        difficulty: 'Intermediate',
        durationMinutes: 250,
        instructorName: 'David Miller',
        thumbnailUrl: '',
        prerequisites: const ['Linux CLI Mastery', 'Bash Scripting'],
        learningOutcomes: const [
          'Inspect systemd journal logs & auth.log',
          'Analyze persistence mechanisms in cron',
          'Audit user activity & bash history',
        ],
        modules: List.generate(
          14,
          (i) => ModuleModel(
            id: 'mod_${i + 1}',
            title: 'Module ${i + 1}: Linux Artifacts',
            description: 'Investigating Linux environments.',
            lessons: [_fallbackLesson],
            order: i + 1,
          ),
        ),
        isEnrolled: true,
        completionPercentage: 0.50,
        totalXp: 700,
      ),
      CourseModel(
        id: 'crs_6',
        title: 'Mobile Forensics',
        description: 'Extract, analyze and interpret data from mobile devices.',
        category: 'Mobile Forensics',
        difficulty: 'Intermediate',
        durationMinutes: 220,
        instructorName: 'Amara Chen',
        thumbnailUrl: '',
        prerequisites: const ['Android/iOS Architecture Basics'],
        learningOutcomes: const [
          'Extract SQLite databases from app data',
          'Analyze location & communication artifacts',
          'Decode backup files & keychain items',
        ],
        modules: List.generate(
          12,
          (i) => ModuleModel(
            id: 'mod_${i + 1}',
            title: 'Module ${i + 1}: Mobile Data Extraction',
            description: 'Analyzing iOS & Android evidence.',
            lessons: [_fallbackLesson],
            order: i + 1,
          ),
        ),
        isEnrolled: true,
        completionPercentage: 0.40,
        totalXp: 600,
      ),
    ];

    return list.where((c) {
      if (category != null && category != 'All') {
        if (category == 'Beginner' && c.difficulty != 'Beginner') {
          return false;
        }
        if (category == 'Intermediate' && c.difficulty != 'Intermediate') {
          return false;
        }
        if (category == 'Advanced' && c.difficulty != 'Advanced') {
          return false;
        }
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        return c.title.toLowerCase().contains(q) ||
            c.description.toLowerCase().contains(q);
      }
      return true;
    }).toList();
  }
}
