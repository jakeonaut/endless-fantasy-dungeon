# from: https://gitlab.com/frankiezafe/godot-wireframe
tool
extends MeshInstance

export(bool) var sides = true setget _sides
export(float) var split = 0 setget _split

var processed_once = false
var vertices = null

func _sides( s ):
    sides = s
    if processed_once:
        cube_create()

func _split( s ):
    if s < 0:
        s = 0
    elif s > 0.5:
        s = 0.5
    split = s
    if processed_once:
        cube_create()

func split_vertices():
    if split != 0:
        var tmp = []
        for v in vertices:
            tmp.append( v )
        vertices = []
        for i in range( 0, len( tmp ) / 2 ):
            var a = tmp[i*2]
            var b = tmp[i*2 + 1]
            var mid = b - a
            vertices.append( a )
            vertices.append( a + mid * split )
            vertices.append( b )
            vertices.append( b - mid * split )

func cube_create():

    vertices = []
    # top
    vertices.append( Vector3( -1, -1, -1 ) )
    vertices.append( Vector3( 1, -1, -1 ) )
    vertices.append( Vector3( 1, -1, -1 ) )
    vertices.append( Vector3( 1, -1, 1 ) )
    vertices.append( Vector3( 1, -1, 1 ) )
    vertices.append( Vector3( -1, -1, 1 ) )
    vertices.append( Vector3( -1, -1, 1 ) )
    vertices.append( Vector3( -1, -1, -1 ) )
    # bottom
    vertices.append( Vector3( -1, 1, -1 ) )
    vertices.append( Vector3( 1, 1, -1 ) )
    vertices.append( Vector3( 1, 1, -1 ) )
    vertices.append( Vector3( 1, 1, 1 ) )
    vertices.append( Vector3( 1, 1, 1 ) )
    vertices.append( Vector3( -1, 1, 1 ) )
    vertices.append( Vector3( -1, 1, 1 ) )
    vertices.append( Vector3( -1, 1, -1 ) )

    if sides:
        vertices.append( Vector3( -1, -1, -1 ) )
        vertices.append( Vector3( -1, 1, -1 ) )
        vertices.append( Vector3( 1, -1, -1 ) )
        vertices.append( Vector3( 1, 1, -1 ) )
        vertices.append( Vector3( 1, -1, 1 ) )
        vertices.append( Vector3( 1, 1, 1 ) )
        vertices.append( Vector3( -1, -1, 1 ) )
        vertices.append( Vector3( -1, 1, 1 ) )

    split_vertices()

    var _mesh = Mesh.new()
    var _surf = SurfaceTool.new()

    _surf.begin(Mesh.PRIMITIVE_LINES)
    for v in vertices:
        _surf.add_vertex(v)
    _surf.index()
    _surf.commit( _mesh )
    set_mesh( _mesh )

    vertices = null


func _ready():
    cube_create()

func _process(delta):
    processed_once = true
