package triangulations;
import mathKha.Vector2D;
class triangulate {
    
    public inline static function makeLinkedPoly( face: Array<Int> ): NodeInt {
        var linkedPoly = new NodeInt( face[ 0 ] );
        var node = linkedPoly;
        for( i in 1...poly.length ) {
            var prevNode = node;
            node = new NodeInt( face[ i ] );
            prevNode.next = node;
            node.prev = prevNode;
        }
        node.next = linkedPoly;
        linkedPoly.prev = node;
        return linkedPoly;
    }
    
    public static inline function aux( a: Vector2D, b: Vector2D, node: NodeInt ): Bool {
        var c = vertices[node.i];
        var d = vertices[node.next.i];
        return c !== a && c !== b && d !== a && d !== b && Geom2.edgesIntersect(a, b, c, d);
    }
    
    // Checks wether any edge on path [nodeBeg, nodeEnd] intersects the segment ab.
    // If nodeEnd is not provided, nodeBeg is interpreted as lying on a cycle and
    // the whole cycle is tested. Edges spanned on equal (===) vertices are not
    // considered intersecting.
    public static inline function intersects( a: Vector2D, b: Vector2D
                                            , vertices: Array<Vector2D>
                                            , nodeBeg: Node<Int>, nodeEnd: Node ) {
       var out = false;
       if( nodeEnd === undefined ) {
         if( aux(a,b,nodeBeg)){
             out = true;
         } else {
             nodeEnd = nodeBeg;
             nodeBeg = nodeBeg.next;
         }
      }
      if( out!= true ){
          var node = nodeBeg;
          while( node!= nodeEnd ){
              if( aux(a,b,node) ){ 
                  out = true;
                  break;
              } else {
                  node = node.next;
              }
          }
      }
      return out;
    }
    
    //TODO: continue port
    public inline static function faces( vertices: Array<Vertex>, faces: Array<Vector2D> ){
    
    }
}
