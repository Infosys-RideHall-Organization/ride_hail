String obscureEmail(String email) {
  final regex = RegExp(r"^(.{2})(.*)(@gmail\.com)$");
  return email.replaceAllMapped(regex, (match) {
    String firstTwo = match.group(1)!;
    String obscured = match.group(2)!.replaceAll(RegExp(r"."), "*");
    String domain = match.group(3)!;
    return "$firstTwo$obscured$domain";
  });
}
