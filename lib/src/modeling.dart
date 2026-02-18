import 'internal.dart';

@Added("2.7", "1.4")
class VertexError {
  @Added("2.7", "1.4")
  final Object? message;

  @Added("2.7", "1.4")
  const VertexError([this.message]);
}

@Added("2.6", "1.0")
class Point {
  @Added("2.6", "1.0")
  final int x;

  @Added("2.6", "1.0")
  final int y;

  @Added("2.6", "1.0")
  final int z;

  @Added("2.7", "1.4")
  int get width => x;
  @Added("2.7", "1.4")
  int get height => y;
  @Added("2.7", "1.4")
  int get depth => z;

  @Added("2.6", "1.0")
  const Point({required this.x, required this.y, required this.z});

  @Added("2.6","1.0")
  @Deprecated("2.8, use Point()")
  const Point.xyz({required this.x, required this.y, required this.z});

  @Added("2.6", "1.0")
  const Point.xy(this.x,this.y) : z = 0;

  @Added("2.6.2", "1.2")
  const Point.xz(this.x, this.z) : y = 0;

  @Added("2.6.2", "1.2")
  const Point.whd({required int width, required int height, required int depth})
      : x = width,
        y = height,
        z = depth;
  @Added("2.6.2", "1.2")
  const Point.wh({required int width, required int height})
      : x = width,
        y = height,
        z = 0;
  @Added("2.6.2", "1.2")
  const Point.wd({required int width, required int depth})
      : x = width,
        y = 0,
        z = depth;

  @Added("2.6", "1.0")
  @override
  int get hashCode => Object.hash(x, y, z);

  @Added("2.6", "1.0")
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Point &&
              x == other.x &&
              y == other.y &&
              z == other.z &&
              hashCode == other.hashCode;

  @Added("2.6.2", "1.2")
  @override
  toString() => "\$x:$x, \$y:$y, \$z:$z";
}

@Added("2.6.1", "1.1")
sealed class VertexProvider {
  @Added("2.7", "1.4")
  final Point a;
  @Added("2.7", "1.4")
  final Point b;

  @Added("2.7", "1.4")
  const VertexProvider(this.a,this.b);

  @Added("2.7", "1.4")
  @override
  int get hashCode => Object.hashAllUnordered([a,b]);
  @Added("2.7", "1.4")
  @override
  bool operator ==(Object other) =>
      identical(this,other)
          || other is VertexProvider && runtimeType == runtimeType
          && ((a == other.a && b == other.b) || (a == other.b && b == other.a));


  @Added("2.7", "1.4")
  @override
  String toString();

  @Added("2.6.1", "1.1")
  Set<Vertex> toVertices();

  @Added("2.6.2", "1.2")
  String toDenoter() => "\$$denotation:";

  @Added("2.7","1.4")
  String get denotation;

  @Added("2.6.3", "1.3")
  String join([String seperator = " "]);

  @Added("2.6.3", "1.3")
  @Deprecated("2.7.2, getting removed")
  String contexter([String starter = "\$vertexProvider:",String ender = " "]) =>
      throw VertexError("Function is deprecated till 2.7.2, "
          "$runtimeType can't support it");
}

@Added("2.6", "1.0")
class Vertex extends VertexProvider {
  @Added("2.6", "1.0")
  final Point c;
  @Added("2.6", "1.0")
  const Vertex(super.a, super.b, this.c);

  @Added("2.6", "1.0")
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Vertex &&
              runtimeType == other.runtimeType &&
              hashCode == other.hashCode;

  @Added("2.6", "1.0")
  @override
  int get hashCode => Object.hashAllUnordered([a, b, c]);

  @override
  @Added("2.6.1", "1.1")
  Set<Vertex> toVertices() => {this};

  @Added("2.6.2", "1.2")
  @override
  toString() => "\$a:{$a}, \$b:{$b}, \$c:{$c}";

  @Added("2.6.3", "1.3")
  @override
  join([String seperator = " "]) => "$a$seperator$b$seperator$c$seperator";

  @Added("2.6.3","1.3")
  @override
  String contexter([String starter = "\$vertex:", String ender = " "]) =>
      "$starter$a$ender$starter$b$ender$starter$c$ender";

  @Added("2.7", "1.4")
  @override
  String get denotation => "vertex";
}

@Added("2.6.1", "1.1")
class Triangle extends Vertex {
  @Added("2.6.1", "1.1")
  const Triangle(super.a, super.b, super.c);
}

@Added("2.6.1", "1.1")
@Deprecated("2.8, use Square.sameY()")
class SquareFlat extends VertexProvider {

  @Added("2.6.1", "1.1")
  const SquareFlat(super.a, super.b);

  @Added("2.6.1", "1.1")
  Point get c => Point(x: a.x, y: a.y, z: b.z);
  @Added("2.6.1", "1.1")
  Point get d => Point(x: b.x, y: b.y, z: a.z);

  @Added("2.6.1", "1.1")
  @override
  Set<Vertex> toVertices() => {Vertex(a, b, c), Vertex(a, b, d)};

  @Added("2.6.1", "1.1")
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SquareFlat &&
              runtimeType == other.runtimeType &&
              hashCode == other.hashCode;

  @Added("2.6.1", "1.1")
  @override
  int get hashCode => Object.hashAllUnordered([a, b]);

  @Added("2.6.2", "1.2")
  @override
  toString() => "\$from:{$a}, \$to:{$b}";

  @Added("2.6.3", "1.3")
  @override
  join([String seperator = " "]) => "$a$seperator$b$seperator";

  @Added("2.6.3","1.3")
  @override
  String contexter([String starter = "\$vertex:", String ender = " "]) =>
      "$starter$a$ender$starter$b$ender";

  @Added("2.7", "1.4")
  @override
  String get denotation => "squareF";
}
@Added("2.7", "1.4")
enum _SquareState {
  sameWidth,
  sameHeight,
  sameDepth,
  userDefined,
}
@Added("2.7", "1.4")
class Square extends VertexProvider {
  @Added("2.7", "1.4")
  final Point topLeft;

  @Added("2.7", "1.4")
  final Point bottomRight;

  @Added("2.7", "1.4")
  final Point? _topRight;

  @Added("2.7", "1.4")
  final Point? _bottomLeft;

  @Added("2.7", "1.4")
  final _SquareState _state;


  @Added("2.7", "1.4")
  const Square.sameY(this.topLeft, this.bottomRight)
      : _state = _SquareState.sameHeight,
        _topRight = null,
        _bottomLeft = null,
        super(topLeft,bottomRight);

  @Added("2.7", "1.4")
  const Square.sameX(this.topLeft, this.bottomRight)
      : _state = _SquareState.sameWidth,
        _topRight = null,
        _bottomLeft = null,
        super(topLeft,bottomRight);

  @Added("2.7", "1.4")
  const Square.sameZ(this.topLeft, this.bottomRight)
      : _state = _SquareState.sameDepth,
        _topRight = null,
        _bottomLeft = null,
        super(topLeft,bottomRight);

  @Added("2.7", "1.4")
  const Square({
    required this.topLeft,
    required Point topRight,
    required this.bottomRight,
    required Point bottomLeft,
  }): _topRight = topRight,
        _bottomLeft = bottomLeft,
        _state = _SquareState.userDefined,
        super(topLeft,bottomRight);

  @Added("2.7", "1.4")
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
  @Added("2.7", "1.4")
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

  @Added("2.7", "1.4")
  @override
  Set<Vertex> toVertices() => {
    Vertex(topLeft, bottomRight, topRight),
    Vertex(topLeft, bottomRight, bottomLeft),
  };

  @Added("2.7", "1.4")
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SquareFlat &&
              runtimeType == other.runtimeType &&
              hashCode == other.hashCode;

  @Added("2.7", "1.4")
  @override
  int get hashCode => Object.hashAllUnordered([
    topLeft,
    topRight,
    bottomLeft,
    bottomRight,
  ]);

  @Added("2.7", "1.4")
  @override
  toString() => "\$from:{$a}, \$to:{$b}";

  @Added("2.7", "1.4")
  @override
  join([String seperator = " "]) => "$a$seperator$b$seperator";

  @Added("2.7", "1.4")
  @override
  String contexter([String starter = "\$vertex:", String ender = " "]) =>
      "$starter$a$ender$starter$b$ender";

  @Added("2.7","1.4")
  @override
  String get denotation =>
      (_state == _SquareState.userDefined)
          ? "squareX"
          : "square";
}

@Added("2.7","1.4")
class Cube extends VertexProvider {
  @Added("2.7", "1.4")
  const Cube(super.a,super.b);

  @Added("2.7", "1.4")
  Point get _topB => Point(x: b.x, y: a.y, z: b.z);
  @Added("2.7", "1.4")
  Point get _bottomA => Point(x: a.x, y: b.y, z: a.z);

  /*@Added("2.7", "1.4")
  Point get _bottomC => Point(x: a.x, y: )*/

  @Added("2.7", "1.4")
  Square get top => Square.sameY(a,_topB);
  @Added("2.7", "1.4")
  Square get bottom => Square.sameY(a,_bottomA);

  @Added("2.7", "1.4")
  @override
  String join([String seperator = " "]) =>
      throw VertexError("to be introduced in a later version");

  @Added("2.7", "1.4")
  @override
  Set<Vertex> toVertices() {
    throw UnimplementedError();
  }

  @Added("2.7","1.4")
  @override
  String get denotation => "cube";
}

@Added("2.6","1.0")
@Deprecated("2.8, use Point()")
class PointXYZ extends Point {
  @Added("2.6","1.0")
  const PointXYZ({required super.x, required super.y, required super.z});
}

@Added("2.6", "1.0")
class Model {
  @Added("2.6", "1.0")
  final Set<VertexProvider> vertices;
  @Added("2.6", "1.0")
  const Model(this.vertices);

  @Added("2.6", "1.0")
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Model &&
              runtimeType == other.runtimeType &&
              vertices == other.vertices;

  @Added("2.6.2", "1.2")
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

  @Added("2.6", "1.0")
  @override
  int get hashCode => Object.hashAllUnordered(vertices);

  @Added("2.6.2", "1.2")
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

  @Added("2.6.3", "1.3")
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

@Added("2.6","1.0")
@Deprecated("2.8, use Point.xy()")
class PointShort extends Point {
  @Added("2.6","1.0")
  const PointShort(int x, int y) : super(x: x, y: 0, z: y);
}
