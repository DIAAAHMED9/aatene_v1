

const String postMethod = 'POST';
const String getMethod = 'GET';
const String putMethod = 'PUT';
const String deleteMethod = 'DELETE';
const String patchMethod = 'PATCH';

enum AppMode { dev, staging, production }

const AppMode currentMode = AppMode.dev;