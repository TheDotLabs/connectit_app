bool checkIfNotEmpty(String value) {
  return value != null &&
      value.isNotEmpty &&
      value != "null" &&
      value.trim().length != 0;
}

bool checkIfListIsNotEmpty(List list) {
  return list != null && list.isNotEmpty;
}
