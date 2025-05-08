
import 'package:logger/logger.dart';

final logger = Logger(
  output: ConsoleOutput(),
  filter: DevelopmentFilter(),
);