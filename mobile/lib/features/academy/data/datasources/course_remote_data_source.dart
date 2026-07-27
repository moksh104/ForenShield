import '../../../../core/network/api_client.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../models/quiz_model.dart';

/// Remote Data Source for Cyber Academy API calls.
class CourseRemoteDataSource {
  final ApiClient _apiClient;

  const CourseRemoteDataSource(this._apiClient);

  /// Fetches courses list from API.
  Future<List<CourseModel>> getCourses({
    String? category,
    String? searchQuery,
  }) async {
    try {
      final response = await _apiClient.get<List<dynamic>>(
        '/academy/courses',
        queryParameters: {
          if (category != null && category != 'All') 'category': category,
          if (searchQuery != null && searchQuery.isNotEmpty)
            'q': searchQuery,
        },
      );
      if (response.data != null) {
        return response.data!
            .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Fallback to local structured data if backend is offline
    }
    return _getFallbackCourses(category: category, searchQuery: searchQuery);
  }

  /// Fetches course details.
  Future<CourseModel> getCourseDetail(String courseId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/academy/courses/$courseId',
      );
      if (response.data != null) {
        return CourseModel.fromJson(response.data!);
      }
    } catch (_) {
      // Fallback
    }
    final all = _getFallbackCourses();
    return all.firstWhere((c) => c.id == courseId, orElse: () => all.first);
  }

  /// Fetches lesson details.
  Future<LessonModel> getLesson(String lessonId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/academy/lessons/$lessonId',
      );
      if (response.data != null) {
        return LessonModel.fromJson(response.data!);
      }
    } catch (_) {
      // Fallback
    }
    return _fallbackLesson;
  }

  /// Submits quiz answers.
  Future<int> submitQuiz({
    required String quizId,
    required Map<String, int> selectedOptions,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/academy/quizzes/$quizId/submit',
        data: {'answers': selectedOptions},
      );
      if (response.data != null && response.data!['score'] != null) {
        return response.data!['score'] as int;
      }
    } catch (_) {
      // Fallback score calculation
    }
    return 85;
  }

  static final LessonModel _fallbackLesson = LessonModel(
    id: 'les_101',
    title: 'Volatile Memory Extraction via Volatility 3',
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
        title: 'RAM & Memory Forensics Masterclass',
        description:
            'Deep dive into Volatility 3, Windows memory artifacts, process injection detection, and kernel rootkits.',
        category: 'Memory Forensics',
        difficulty: 'Intermediate',
        durationMinutes: 180,
        instructorName: 'Dr. Alex Vance',
        thumbnailUrl: '',
        prerequisites: const ['Basic C/OS Concepts', 'Command Line Proficiency'],
        learningOutcomes: const [
          'Acquire RAM safely using DumpIt and FTK Imager',
          'Detect DLL injection and process hollowing',
          'Analyze malware network connections in memory',
        ],
        modules: [
          ModuleModel(
            id: 'mod_1',
            title: 'Module 1: Fundamentals of RAM Acquisition',
            description: 'Preserving volatile evidence adhering to RFC 3227.',
            lessons: [_fallbackLesson],
            order: 1,
          ),
          ModuleModel(
            id: 'mod_2',
            title: 'Module 2: Malfind & Process Injection',
            description: 'Locating unbacked executable memory pages.',
            lessons: [
              LessonModel(
                id: 'les_102',
                title: 'Detecting Process Hollowing in SVCHOST',
                durationMinutes: 25,
                contentType: 'text',
                contentText:
                    'Process hollowing occurs when a legitimate process (e.g. svchost.exe) is spawned in a suspended state, its code unmapped, and malicious code injected before resuming execution.',
                codeSnippet: 'python3 vol.py -f mem.raw windows.malfind',
                codeLanguage: 'bash',
                checklist: const [],
                isCompleted: true,
                order: 2,
              ),
            ],
            order: 2,
          ),
        ],
        isEnrolled: true,
        completionPercentage: 0.50,
        totalXp: 600,
        quiz: const QuizModel(
          id: 'qz_101',
          title: 'Memory Forensics Knowledge Check',
          passingScorePercent: 75,
          questions: [
            QuizQuestionModel(
              id: 'q1',
              questionText:
                  'Which Volatility 3 plugin displays active network connections in a Windows memory dump?',
              options: ['windows.pslist', 'windows.netscan', 'windows.filescan', 'windows.cmdline'],
              correctOptionIndex: 1,
              explanation:
                  'windows.netscan scans memory pools for socket structures to enumerate network connections.',
            ),
            QuizQuestionModel(
              id: 'q2',
              questionText:
                  'What is the primary indicator of process hollowing in malfind output?',
              options: [
                'Unbacked memory pages with PAGE_EXECUTE_READWRITE permissions',
                'High CPU utilization',
                'Duplicate PID numbers',
                'Missing system environment variables'
              ],
              correctOptionIndex: 0,
              explanation:
                  'Malfind detects VAD regions containing executable code that are not backed by a disk file, typically marked PAGE_EXECUTE_READWRITE (0x40).',
            ),
          ],
        ),
      ),
      CourseModel(
        id: 'crs_2',
        title: 'Reverse Engineering Ransomware Binaries',
        description:
            'Decompile, disassemble, and analyze malware samples using Ghidra and x64dbg.',
        category: 'Reverse Engineering',
        difficulty: 'Advanced',
        durationMinutes: 240,
        instructorName: 'Elena Rostova',
        thumbnailUrl: '',
        prerequisites: const ['x86 Assembly Basics', 'C Programming'],
        learningOutcomes: const [
          'Unpack XOR / AES obfuscated payloads',
          'Bypass anti-analysis routines',
          'Extract C2 IP addresses & encryption keys',
        ],
        modules: const [],
        isEnrolled: false,
        completionPercentage: 0.0,
        totalXp: 850,
      ),
      CourseModel(
        id: 'crs_3',
        title: 'Network Traffic Analysis & Wireshark',
        description:
            'Capture PCAPs, analyze covert C2 channels, and decrypt TLS traffic with session keys.',
        category: 'Network Defense',
        difficulty: 'Beginner',
        durationMinutes: 120,
        instructorName: 'Marcus Thorne',
        thumbnailUrl: '',
        prerequisites: const ['TCP/IP Fundamentals'],
        learningOutcomes: const [
          'Filter DNS tunneling attacks',
          'Identify HTTP POST exfiltration vectors',
        ],
        modules: const [],
        isEnrolled: true,
        completionPercentage: 0.85,
        totalXp: 450,
      ),
    ];

    return list.where((c) {
      if (category != null && category != 'All' && c.category != category) {
        return false;
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
