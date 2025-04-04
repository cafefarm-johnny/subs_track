class SampleRepository {
  static final _instance = SampleRepository._internal();

  SampleRepository._internal();

  factory SampleRepository() => _instance;
}
