class Pair {
  int first, second;

  Pair(this.first, this.second);

  @override
  String toString() {
    return '($first, $second)';
  }
}

class PathFinder {
  List<int> shopping_list;
  List<int> cell_list;
  PathFinder( { required List<int> shopping_list, required List<int> cell_list})
    : shopping_list = shopping_list,
      cell_list = cell_list;

bool isSafe(List<List<int>> mat, List<List<bool>> visited, int x, int y) {
    return (x >= 0 &&
        x < mat.length &&
        y >= 0 &&
        y < mat[0].length &&
        mat[x][y] == 1 &&
        !visited[x][y]);
  }

  int findShortestPath(
    List<List<int>> mat,
    List<List<bool>> visited,
    int i,
    int j,
    int x,
    int y,
    int minDist,
    int dist,
    List<Pair> path,
    List<Pair> currentPath,
  ) {
    if (i == x && j == y) {
      if (dist < minDist) {
        minDist = dist;
        path.clear();
        path.addAll(currentPath);
      }
      return minDist;
    }

    visited[i][j] = true;
    currentPath.add(Pair(i, j));

    // go to the bottom cell
    if (isSafe(mat, visited, i + 1, j)) {
      minDist = findShortestPath(
          mat, visited, i + 1, j, x, y, minDist, dist + 1, path, currentPath);
    }

    // go to the right cell
    if (isSafe(mat, visited, i, j + 1)) {
      minDist = findShortestPath(
          mat, visited, i, j + 1, x, y, minDist, dist + 1, path, currentPath);
    }

    // go to the top cell
    if (isSafe(mat, visited, i - 1, j)) {
      minDist = findShortestPath(
          mat, visited, i - 1, j, x, y, minDist, dist + 1, path, currentPath);
    }

    // go to the left cell
    if (isSafe(mat, visited, i, j - 1)) {
      minDist = findShortestPath(
          mat, visited, i, j - 1, x, y, minDist, dist + 1, path, currentPath);
    }

    visited[i][j] = false;
    currentPath.removeLast();
    return minDist;
  }

  List<dynamic> findShortestPathLength(
    List<List<int>> mat,
    Pair src,
    Pair dest,
  ) {
    if (mat.isEmpty ||
        mat[src.first][src.second] == 0 ||
        mat[dest.first][dest.second] == 0) {
      return [-1, []];
    }

    int row = mat.length;
    int col = mat[0].length;

    List<List<bool>> visited =
        List.generate(row, (_) => List.filled(col, false));

    List<Pair> path = [];
    List<Pair> currentPath = [];

    int dist = 2147483647;
    dist = findShortestPath(mat, visited, src.first, src.second, dest.first,
        dest.second, dist, 0, path, currentPath);

    if (dist != 2147483647) {
      return [dist, path];
    }
    return [-1, []];
    /* if (dist != 2147483647) {
    return [dist, path.cast<Pair>()]; // Ensure that path is cast to List<Pair>
  }
  return [-1, []]; */
  }

  List<int> findPath() {
    // List<List<int>> mat = [
    //   [1, 0, 1, 1, 1, 1, 0, 1, 1, 1],
    //   [1, 0, 1, 0, 1, 1, 1, 0, 1, 1],
    //   [1, 1, 1, 0, 1, 1, 0, 1, 0, 1],
    //   [0, 0, 0, 0, 1, 0, 0, 0, 0, 1],
    //   [1, 1, 1, 0, 1, 1, 1, 0, 1, 0],
    //   [1, 0, 1, 1, 1, 1, 0, 1, 0, 0],
    //   [1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    //   [1, 0, 1, 1, 1, 1, 0, 1, 1, 1],
    //   [1, 1, 0, 0, 0, 0, 1, 0, 0, 1]
    // ];

    List<List<int>> mat = [
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    ];

    // List<int> shopping_list = [1, 2, 3, 4];
    //from product id retrieve cell number and add it to a list
    // List<int> cell_list = [1, 2, 3, 4, 5];
    // List<int> cell_list = [0, 5, 37, 44];
    // List<int> cell_list = [178, 101, 104, 159];

    ////////////important : - cell number should be the nearest cell to the aisle

    // List<Pair> indexes = [Pair(0, 0), Pair(0, 5), Pair(3, 4), Pair(0, 4)];

    /* int row = 0;
  int col = 0; */

    /* for (int cell in cell_list) {
    row = cell ~/ 11;
    col = cell % 11;
    Pair src = Pair(row, col);
    //from cell number retrieve coordinates
    //conversion logic eg:- 0=0,0 or 12=1,1
  } */

    int src_cell = 0;
    int dest_cell = 0;
    int src_row = 0;
    int src_col = 0;
    int dest_row = 0;
    int dest_col = 0;

    List<Pair> route = [];

    for (int i = 0; i < shopping_list.length - 1; i++) {
      print("i is $i");
      src_cell = cell_list[i];
      dest_cell = cell_list[i + 1];
      src_row = src_cell ~/ 11;
      src_col = src_cell % 11;

      dest_row = dest_cell ~/ 11;
      dest_col = dest_cell % 11;

      Pair src = Pair(src_row, src_col);
      Pair dest = Pair(dest_row, dest_col);

      var result = findShortestPathLength(mat, src, dest);

      int dist = result[0];
      // List<Pair> path = result[1];
      List<Pair> path = (result[1] as List).cast<Pair>();

      if (dist != -1) {
        print("Shortest Path Length is $dist");
        print("Shortest Path is $path");
        route.addAll(path);
      } else {
        print("Shortest Path doesn't exist");
      }
    }

    print("Full Route is $route");
    List<int> numbers =
        route.map((pair) => pair.first * 11 + pair.second).toList();
    print("Path with cell ids is $numbers");

    /* Pair src = Pair(0, 0);
  Pair dest = Pair(4, 0);
  var result = findShortestPathLength(mat, src, dest);

  int dist = result[0];
  List<Pair> path = result[1];

  if (dist != -1) {
    print("Shortest Path Length is $dist");
    print("Shortest Path is $path");
  } else {
    print("Shortest Path doesn't exist");
  } */

  return numbers;
  }


}