import 'dart:io';

class SafeFile {
  File file;

  SafeFile(String path) {
    if (path.startsWith('file://')) {
      path = path.substring(7);
    }
    this.file = new File(path);
  }

  Future<SafeFile> writeAsBytes(List<int> bytes) async {
    this.file = await this.file.writeAsBytes(bytes);
    return this;
  }

  void writeAsBytesSync(List<int> bytes) {
    return this.file.writeAsBytesSync(bytes);
  }

  Future<FileSystemEntity> delete({bool recursive: false}) async {
    return await this.file.delete(recursive: recursive);
  }

  void deleteSync({bool recursive: false}) {
    return this.file.deleteSync(recursive: recursive);
  }

  Future<bool> exists() async {
    return await this.file.exists();
  }

  bool existsSync() {
    return this.file.existsSync();
  }

  Future<SafeFile> copy(String newPath) async {
    this.file = await this.file.copy(newPath);
    return this;
  }

  SafeFile copySync(String newPath) {
    this.file = this.file.copySync(newPath);
    return this;
  }

  Future<void> safeDelete() async {
    if (this.file.existsSync()) {
      await this.file.delete();
      print("Deleted " + this.file.path);
    }
  }

  void safeDeleteSync() {
    if (this.file.existsSync()) {
      this.file.deleteSync();
      print("Deleted " + this.file.path);
    }
  }

  Future<SafeFile> create({bool recursive: false}) async {
    this.file = await this.file.create(recursive: recursive);
    return this;
  }

  void createSync({bool recursive: false}) {
    this.file.createSync(recursive: recursive);
  }

  Directory get parent => file.parent;

  String get prefixPath => "file://" + file.path;

  String get path => file.path;

  Uri get uri => file.uri;

}