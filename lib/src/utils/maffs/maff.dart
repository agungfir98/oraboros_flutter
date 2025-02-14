import 'dart:math';

double euclideanDistane(({double x, double y}) v1, ({double x, double y}) v2) {
  return sqrt(pow(v2.x - v1.x, 2) + pow(v2.y - v1.y, 2));
}

double magnitude(({double x, double y}) v) {
  return sqrt(pow(v.x, 2) + pow(v.y, 2));
}

(double, double) centerOfTwoVec(
    ({double x, double y}) v1, ({double x, double y}) v2) {
  double xmid = (v1.x + v2.x) / 2;
  double ymid = (v1.y + v2.y) / 2;

  return (xmid, ymid);
}

({double x, double y}) pointAtDistance(
  ({double x, double y}) v1,
  ({double x, double y}) v2,
  double d,
) {
  if (v1 == v2) return v1;

  var (dx, dy) = ((v2.x - v1.x), (v2.y - v1.y));

  double vecMag = magnitude((x: dx, y: dy));

  if (vecMag == 0) return v1;

  var normVec = (dx / vecMag, dy / vecMag);
  var (nx, ny) = normVec;
  var scaled = (nx * d, ny * d);
  var (sx, sy) = scaled;

  return (x: v1.x + sx, y: v1.y + sy);
}
