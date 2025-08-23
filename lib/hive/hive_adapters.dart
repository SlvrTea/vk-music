import 'dart:ui';

import 'package:hive_ce/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vk_music/common/utils/config/app_config.dart';
import 'package:vk_music/data/models/user/user.dart';


@GenerateAdapters([
  AdapterSpec<User>(),
  AdapterSpec<AppConfig>(),
  AdapterSpec<LoopMode>(),
  AdapterSpec<Color>(),
])
part 'hive_adapters.g.dart';
