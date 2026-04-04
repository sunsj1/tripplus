import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:tripplus/features/community/data/local_db/community_local_db.dart';

final communityLocalDbProvider = Provider<CommunityLocalDb>((ref) {
  final box = Hive.box(CommunityLocalDb.boxName);
  return CommunityLocalDb(box);
});
