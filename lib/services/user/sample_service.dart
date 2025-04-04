class SampleService {
  static final _instance = SampleService._internal();

  SampleService._internal();

  factory SampleService() => _instance;
}
