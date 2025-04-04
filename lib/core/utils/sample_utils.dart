class SampleUtils {
  static final _instance = SampleUtils._internal();

  SampleUtils._internal();

  factory SampleUtils() => _instance;
}
