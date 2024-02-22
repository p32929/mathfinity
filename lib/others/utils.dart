class Utils {
  static List<int> generateNumberArray(int start, int end,
      {bool shuffle = false}) {
    List<int> numbers = [];
    for (int i = start; i <= end; i++) {
      numbers.add(i);
    }

    if (shuffle) {
      numbers = Utils.shuffleArray(numbers);
    }

    return numbers;
  }

  static List<int> shuffleArray(List<int> array) {
    List<int> shuffledArray =
        List.from(array); // Make a copy of the original array
    shuffledArray.shuffle();
    return shuffledArray;
  }
}
