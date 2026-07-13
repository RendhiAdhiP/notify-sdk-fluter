class AuthManager {
  String _projectToken;
  String _origin;

  AuthManager({
    required String projectToken,
    required String origin,
  })  : _projectToken = projectToken,
        _origin = origin;

  String get projectToken => _projectToken;
  String get origin => _origin;

  set projectToken(String token) => _projectToken = token;
  set origin(String origin) => _origin = origin;

  Map<String, dynamic> get socketAuth => {
    'project_token': _projectToken,
    'origin': _origin,
  };

  Map<String, String> get httpHeaders => {
    'project_token': _projectToken,
    'origin': _origin,
    'Content-Type': 'application/json',
  };
}
