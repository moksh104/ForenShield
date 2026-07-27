import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

/// Offline mock implementation of [ProfileRepository].
///
/// Provides user profile information, XP, Level, Badges, Statistics, and
/// handles profile update and password change requests with SharedPreferences persistence.
class MockProfileRepository implements ProfileRepository {
  final StorageService _storage = StorageService();

  ProfileEntity _mockProfile = const ProfileEntity(
    id: 'user_mock_001',
    fullName: 'Moksh Patel',
    email: 'moksh@forenshield.io',
    role: 'Lead Cyber Investigator',
    avatarUrl: '',
    bio: 'Lead Cyber Forensic Specialist',
    phone: '+1 (555) 019-2834',
    xpPoints: 4250,
    rankTitle: 'Senior Cyber Investigator',
    memberSince: 'Jan 2025',
    accountStatus: 'Active Security Clearer',
    level: 14,
    nextLevelXp: 5000,
    stats: UserStatsEntity(
      totalLearningHours: 42.5,
      casesSolved: 12,
      coursesCompleted: 5,
      currentStreakDays: 7,
      securityScore: 88,
    ),
    badges: [
      AchievementBadgeEntity(
        id: 'bdg_1',
        title: 'Phishing Hunter',
        description: 'Successfully identified 5 malicious email campaigns.',
        iconName: 'mark_email_unread',
        unlockedDate: 'Jan 2025',
        xpReward: 200,
        isUnlocked: true,
      ),
      AchievementBadgeEntity(
        id: 'bdg_2',
        title: 'Memory Analyst',
        description: 'Extracted process trees from 3 volatile RAM dumps.',
        iconName: 'memory',
        unlockedDate: 'Feb 2025',
        xpReward: 350,
        isUnlocked: true,
      ),
      AchievementBadgeEntity(
        id: 'bdg_3',
        title: 'Packet Guardian',
        description: 'Analyzed 500MB of raw network PCAP streams.',
        iconName: 'network_check',
        unlockedDate: 'Feb 2025',
        xpReward: 500,
        isUnlocked: true,
      ),
    ],
    xpHistory: [
      XpHistoryItemEntity(
        id: 'xp_1',
        title: 'Completed Lab: Network Traffic Analysis',
        source: 'Academy',
        xpAmount: 250,
        timestamp: '2 hours ago',
      ),
      XpHistoryItemEntity(
        id: 'xp_2',
        title: 'Solved Case #101: Phishing Investigation',
        source: 'Investigation',
        xpAmount: 400,
        timestamp: 'Yesterday',
      ),
      XpHistoryItemEntity(
        id: 'xp_3',
        title: '7-Day Learning Streak Bonus',
        source: 'Streak',
        xpAmount: 100,
        timestamp: '2 days ago',
      ),
    ],
  );

  @override
  Future<Result<ProfileEntity>> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final savedName = await _storage.read(StorageKeys.profileFullName);
    final savedEmail = await _storage.read(StorageKeys.profileEmail);
    final savedBio = await _storage.read(StorageKeys.profileBio);
    final savedPhone = await _storage.read(StorageKeys.profilePhone);
    final savedAvatar = await _storage.read(StorageKeys.profileAvatarPath);

    _mockProfile = _mockProfile.copyWith(
      fullName: savedName ?? _mockProfile.fullName,
      email: savedEmail ?? _mockProfile.email,
      bio: savedBio ?? _mockProfile.bio,
      phone: savedPhone ?? _mockProfile.phone,
      avatarUrl: savedAvatar ?? _mockProfile.avatarUrl,
    );

    return Success(_mockProfile);
  }

  @override
  Future<Result<ProfileEntity>> updateProfile({
    required String fullName,
    required String email,
    String? bio,
    String? phone,
    String? avatarUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    await _storage.write(StorageKeys.profileFullName, fullName);
    await _storage.write(StorageKeys.profileEmail, email);
    if (bio != null) await _storage.write(StorageKeys.profileBio, bio);
    if (phone != null) await _storage.write(StorageKeys.profilePhone, phone);
    if (avatarUrl != null) {
      if (avatarUrl.isEmpty) {
        await _storage.delete(StorageKeys.profileAvatarPath);
      } else {
        await _storage.write(StorageKeys.profileAvatarPath, avatarUrl);
      }
    }

    _mockProfile = _mockProfile.copyWith(
      fullName: fullName,
      email: email,
      bio: bio ?? _mockProfile.bio,
      phone: phone ?? _mockProfile.phone,
      avatarUrl: avatarUrl ?? _mockProfile.avatarUrl,
    );

    return Success(_mockProfile);
  }

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const Success(null);
  }
}
