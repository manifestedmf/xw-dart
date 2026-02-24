
class VertexError {
  final Object? message;

  const VertexError([this.message]);
}

class Point {
  final int x;

  final int y;

  final int z;

  int get width => x;
  int get height => y;
  int get depth => z;

  const Point({required this.x, required this.y, required this.z});

  @Deprecated("2.8, use Point(x: x, y: y, z: z)")
  const Point.xyz({required this.x, required this.y, required this.z});

  const Point.xy(this.x,this.y) : z = 0;

  const Point.xz(this.x, this.z) : y = 0;

  const Point.whd({required int width, required int height, required int depth})
      : x = width,
        y = height,
        z = depth;
  const Point.wh({required int width, required int height})
      : x = width,
        y = height,
        z = 0;
  const Point.wd({required int width, required int depth})
      : x = width,
        y = 0,
        z = depth;

  @override
  int get hashCode => Object.hash(x, y, z);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Point &&
              x == other.x &&
              y == other.y &&
              z == other.z &&
              hashCode == other.hashCode;

  @override
  toString() => "\$x:$x, \$y:$y, \$z:$z";
}

sealed class VertexProvider {
  final Point a;
  final Point b;

  const VertexProvider(this.a,this.b);

  @override
  int get hashCode => Object.hashAllUnordered([a,b]);
  @override
  bool operator ==(Object other) =>
      identical(this,other)
          || other is VertexProvider && runtimeType == runtimeType
          && ((a == other.a && b == other.b) || (a == other.b && b == other.a));


  @override
  String toString();

  Set<Vertex> toVertices();

  String toDenoter() => "\$$denotation:";

  String get denotation;

  String join([String seperator = " "]);
}

class Vertex extends VertexProvider {
  final Point c;
  const Vertex(super.a, super.b, this.c);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Vertex &&
              runtimeType == other.runtimeType &&
              hashCode == other.hashCode;

  @override
  int get hashCode => Object.hashAllUnordered([a, b, c]);

  @override
  Set<Vertex> toVertices() => {this};

  @override
  toString() => "\$a:{$a}, \$b:{$b}, \$c:{$c}";

  @override
  join([String seperator = " "]) => "$a$seperator$b$seperator$c$seperator";

  @override
  String get denotation => "vertex";
}

class Triangle extends Vertex {
  const Triangle(super.a, super.b, super.c);
}

@Deprecated("2.8, use Square.sameY(a, b)")
class SquareFlat extends VertexProvider {

  const SquareFlat(super.a, super.b);

  Point get c => Point(x: a.x, y: a.y, z: b.z);
  Point get d => Point(x: b.x, y: b.y, z: a.z);

  @override
  Set<Vertex> toVertices() => {Vertex(a, b, c), Vertex(a, b, d)};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SquareFlat &&
              runtimeType == other.runtimeType &&
              hashCode == other.hashCode;

  @override
  int get hashCode => Object.hashAllUnordered([a, b]);

  @override
  toString() => "\$from:{$a}, \$to:{$b}";

  @override
  join([String seperator = " "]) => "$a$seperator$b$seperator";

  @override
  String get denotation => "squareF";
}
enum _SquareState {
  sameWidth,
  sameHeight,
  sameDepth,
  userDefined,
}
class Square extends VertexProvider {
  final Point topLeft;

  final Point bottomRight;

  final Point? _topRight;

  final Point? _bottomLeft;

  final _SquareState _state;


  const Square.sameY(this.topLeft, this.bottomRight)
      : _state = _SquareState.sameHeight,
        _topRight = null,
        _bottomLeft = null,
        super(topLeft,bottomRight);

  const Square.sameX(this.topLeft, this.bottomRight)
      : _state = _SquareState.sameWidth,
        _topRight = null,
        _bottomLeft = null,
        super(topLeft,bottomRight);

  const Square.sameZ(this.topLeft, this.bottomRight)
      : _state = _SquareState.sameDepth,
        _topRight = null,
        _bottomLeft = null,
        super(topLeft,bottomRight);

  const Square({
    required this.topLeft,
    required Point topRight,
    required this.bottomRight,
    required Point bottomLeft,
  }): _topRight = topRight,
        _bottomLeft = bottomLeft,
        _state = _SquareState.userDefined,
        super(topLeft,bottomRight);

  Point get topRight => switch(_state) {
    _SquareState.sameWidth => Point.whd(
      width: topLeft.width,
      height: topLeft.height,
      depth: bottomRight.depth,
    ),
    _SquareState.sameHeight => Point.whd(
      width: bottomRight.width,
      height: topLeft.height,
      depth: topLeft.depth,
    ),
    _SquareState.sameDepth => Point.whd(
      width: bottomRight.width,
      height: topLeft.height,
      depth: topLeft.depth,
    ),
    _SquareState.userDefined => _topRight!,
  };
  Point get bottomLeft => switch(_state) {
    _SquareState.sameWidth => Point.whd(
      width: bottomRight.width,
      height: bottomRight.height,
      depth: topLeft.depth,
    ),
    _SquareState.sameHeight => Point.whd(
      width: topLeft.width,
      height: bottomRight.height,
      depth: bottomRight.depth,
    ),
    _SquareState.sameDepth => Point.whd(
      width: topLeft.width,
      height: bottomRight.height,
      depth: bottomRight.depth,
    ),
    _SquareState.userDefined => _bottomLeft!,
  };

  @override
  Set<Vertex> toVertices() => {
    Vertex(topLeft, bottomRight, topRight),
    Vertex(topLeft, bottomRight, bottomLeft),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SquareFlat &&
              runtimeType == other.runtimeType &&
              hashCode == other.hashCode;

  @override
  int get hashCode => Object.hashAllUnordered([
    topLeft,
    topRight,
    bottomLeft,
    bottomRight,
  ]);

  @override
  toString() => "\$from:{$a}, \$to:{$b}";

  @override
  join([String seperator = " "]) => "$a$seperator$b$seperator";

  @override
  String get denotation =>
      (_state == _SquareState.userDefined)
          ? "squareX"
          : "square";
}

class Cube extends VertexProvider {
  const Cube(super.a,super.b);

  Point get _topB => Point(x: b.x, y: a.y, z: b.z);
  Point get _bottomA => Point(x: a.x, y: b.y, z: a.z);

  /*
 Point get _bottomC => Point(x: a.x, y: )*/

  Square get top => Square.sameY(a,_topB);
  Square get bottom => Square.sameY(a,_bottomA);

  @override
  String join([String seperator = " "]) =>
      throw VertexError("to be introduced in a later version");

  @override
  Set<Vertex> toVertices() {
    throw UnimplementedError();
  }

  @override
  String get denotation => "cube";
}

@Deprecated("2.8, use Point(x: x, y: y, z: z)")
class PointXYZ extends Point {
  const PointXYZ({required super.x, required super.y, required super.z});
}

class Model {
  final Set<VertexProvider> vertices;
  const Model(this.vertices);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Model &&
              runtimeType == other.runtimeType &&
              vertices == other.vertices;

  Set<Vertex> get vertexes {
    Set<Vertex> mule = {};
    Set<Vertex> current;
    for (VertexProvider provider in vertices) {
      current = provider.toVertices();
      for (int index = 0; index < current.length; index++) {
        mule.add(current.elementAt(index));
      }
    }
    return mule;
  }

  @override
  int get hashCode => Object.hashAllUnordered(vertices);

  @override
  toString() {
    String mule = "\$model:(";
    for (int index = 0; index < vertices.length; index++) {
      VertexProvider vertex = vertices.elementAt(index);
      if (index > 0) {
        mule += "; ";
      }
      mule += "${vertex.toDenoter()}[$vertex]";
    }
    mule += ")";
    return mule;
  }

  String join({String seperator = ";\n\t", String start = "\n\t", String end = ";\n"}) {
    String mule = "\$model:($start";
    for (int index = 0; index < vertices.length; index++) {
      VertexProvider vertex = vertices.elementAt(index);
      if (index > 0) {
        mule += seperator;
      }
      mule += "${vertex.toDenoter()}[$vertex]";
    }
    mule += "$end)";
    return mule;
  }
}

@Deprecated("2.8, use Point.xy(x, y)")
class PointShort extends Point {
  const PointShort(int x, int y) : super.xy(x, y);
}
