String taskCounts(int count) {
  if (count != 0 && (count == 1 || (count != 11 && count % 10 == 1))) {
    return '$count оффер';
  } else if (count != 0 &&
      (count % 10 == 2 || count % 10 == 3 || count % 10 == 4) &&
      count != 12 &&
      count != 13 &&
      count != 14) {
    return '$count оффера';
  } else {
    return '$count офферов';
  }
}

String contractorCountTask(int count) {
  if (count != 0 && (count == 1 || (count != 11 && count % 10 == 1))) {
    return '$count задание';
  } else if (count != 0 &&
      (count % 10 == 2 || count % 10 == 3 || count % 10 == 4) &&
      count != 12 &&
      count != 13 &&
      count != 14) {
    return '$count задания';
  } else {
    return '$count заданиях';
  }
}
