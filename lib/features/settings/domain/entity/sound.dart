class Sound {
  final String title;
  final String fileName;
  final bool isCustom;

  Sound({
    required this.title,
    required this.fileName,
    this.isCustom = true,
  });

  Sound.fromFile(this.fileName)
      : title = fileName.split('.')[0],
        isCustom = true;
}
