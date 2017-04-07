package tests;
import triangulations.Edge;
import triangulations.Edges;
import triangulations.Vertices;
import triangulations.Geom2;
import triangulations.Node;
import triangulations.Queue;
import triangulations.SideEdge;
import triangulations.Settings;
import triangulations.Graph;
//import triangulations.Rupert;
import triangulations.Triangulate;
import tests.fillShapes.Bannana;
import tests.fillShapes.Guitar;
import tests.fillShapes.Key;
import tests.fillShapes.Sheet;
import tests.fillShapes.Ty;
import triangulations.FillShape;

// drawing specific
import js.Browser;
import khaMath.Matrix4;
import justTrianglesWebGL.Drawing;
import justTriangles.Triangle;
import justTriangles.Draw;
import justTriangles.Point;
import justTriangles.PathContext;
import justTriangles.ShapePoints;
import justTriangles.QuickPaths;
import htmlHelper.tools.CSSEnterFrame;
import justTriangles.SvgPath;
import justTriangles.PathContextTrace;
@:enum
abstract RainbowColors( Int ){
    var Violet = 0x9400D3;
    var Indigo = 0x4b0082;
    var Blue   = 0x0000FF;
    var Green  = 0x00ff00;
    var Yellow = 0xFFFF00;
    var Orange = 0xFF7F00;
    var Red    = 0xFF0000;
    var Black  = 0x000000;
}
class MainTestSetup {

    static function main(){
        new MainTestSetup();
    }
    
    public var bannana: FillShape;
    public var guitar:  FillShape;
    public var key:     FillShape;
    public var sheet:   FillShape;
    public var ty:      FillShape;
    
    public function fillShapesCreate(){
        bannana = new Bannana();
        guitar = new Guitar();
        key = new Key();
        sheet = new Sheet();
        ty = new Ty();
    }
    
    var rainbow = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet ];   
    public function new(){
        var webgl = Drawing.create( 570*2 );
        fillShapesCreate();
        draw();
        webgl.setTriangles( Triangle.triangles, cast rainbow );
        trace( 'Testing Triangulations ');
    }
    
    public function draw(){
        trace('webgl drawing setup');
        Draw.colorFill_id = 1;
        Draw.colorLine_id = 0;
        Draw.colorLine_id = 7;
        Draw.extraFill_id = 2;
        var ctx;
        var thick = 2;
        ctx = new PathContext( 1, 1000, 100, 100 );
        ctx.lineType = TriangleJoinCurve; // - default
        ctx.moveTo( 50, 50 );
        ctx.lineTo( 100, 100 );
        ctx.render( thick, false ); 
    }
}
