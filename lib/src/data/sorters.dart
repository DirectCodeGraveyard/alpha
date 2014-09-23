part of alpha.data;

class Sorters {
  static Comparator<String> LARGEST_STRING_LENGTH = (String a, String b) =>
      b.length.compareTo(a.length);
  static Comparator<String> SMALLEST_STRING_LENGTH = (String a, String b) =>
      a.length.compareTo(b.length);
}