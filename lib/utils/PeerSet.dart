// Returns the list of maps for eval
// One list for each student (with email)

Map<String, Map<String, bool>> getPeerSet(List students) {
  List<String> realStudents = [];
  Map<String, Map<String, bool>> peerSet = {};

  // get the real students
  for (String stud in students) {
    if (stud.contains('@')) {
      realStudents.add(stud);
    }
  }
  if (realStudents.length > 2) {
    // randomize the list
    // shuffling the probability of a student assessing their peers
    // twice, gets reduced.
    realStudents.shuffle();

    // given a list of size N => 3 every student will assess the others *once*
    // but each student gets assessed exactly twice.
    for (int i = 0; i < realStudents.length; i++) {
      print(i);
      if (i > 0 && i < realStudents.length - 1) {
        peerSet[realStudents[i]] = {
          realStudents[i - 1]: false,
          realStudents[i + 1]: false,
        };
      }

      if (i == 0) {
        peerSet[realStudents.first] = {
          realStudents.last: false,
          realStudents[1]: false
        };
      }
      if (i == realStudents.length - 1) {
        peerSet[realStudents.last] = {
          realStudents.first: false,
          realStudents[realStudents.length - 2]: false
        };
      }
    }

    return peerSet;
  }
  return {};
}
