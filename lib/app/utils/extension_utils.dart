extension StringExtension on String {
  String get svg => 'assets/icons/$this.svg';
  String get icon => 'assets/icons/$this.png';
  String get png => 'assets/images/$this.png';
  String get jpg => 'assets/images/$this.jpg';
}
