package triangulations;
import triangulations.Geom2;
@:forward
abstract Edges( Array<Edge> ) from Array<Edge> to Array<Edge> {
    
    inline public function new( ?v: Array<Edge> ) {
        if( v == null ) v = getEmpty();
        this = v;
    }
    /**
     * allow simple creation of empty Edges
     * @return      Edges
     **/
    public inline static 
    function getEmpty(){
        return new Edges( new Array<Edge>() );
    }
    /**
     * loops through all the edges and sets them up as external and fixed if val is true
     * often used just after creating a new shape.
     * 
     * @param val    set to true for external and fixed.
     * @return   true
     **/
    public /*inline*/ function set_fixedExternal( val: Bool ){
        for( e in this ) {
            e.fixed = val;
            e.external = val;
        }
        return val;
    }
    /**
     * fixed and external setter 
     **/
    public var fixedExternal( never, set ):Bool;
    /**
     * clones edges to new instance 
     **/
    public inline
    function clone(): Edges {
        var e = new Edges();
        var l = this.length;
        var tempIn: Edge;
        var tempOut: Edge;
        for( i in 0...l ){
            e[i] = this[i].clone();       
        }
        return e;
    }
    /**
     * @return unsure edges
     **/
    public inline
    function getUnsure(): Array<Int> {
        var unsureEdges = new Array<Int>();
        var l = this.length;
        var lu = 0;
        for( j in 0...l ){
            if( !this[j].fixed ){
                unsureEdges[ lu ] = j;
                lu++;
            }
        }
        return unsureEdges;
    }
    /**
     * fast ( ? ) concat for edges
     **/
    public inline
    function add( e: Edges ): Edges {
        var l = this.length;
        var el = e.length;
        for( i in 0...el ) this[ l + i ] = e[ i ];
        return this;
    }
    /** 
     * function for creating Edges from nested Array structures
     * 
     * @param   arr             Array of Array of Int structure 
     * @return  edges
     **/
    @:from
    static public function fromArrayArray( arr: Array<Array<Null<Int>>> ) {
        var edges: Edges = getEmpty();
        var l = arr.length;
        for( i in 0...l ) {
            edges[ i ] = Edge.fromArray( arr[ i ] );
        }
        return edges;
    }
    /**
     *  Flips edge j.
     *  Given edges along with their quad-edge datastructure, flips the chosen edge
     *  j, maintaining the quad-edge structure integrity.
     *
     * @param   coEdges
     * @param   sideEdges
     * @param   j               edge index
     **/
    public inline
    function flipEdge( coEdges: Edges, sideEdges: Array<SideEdge>, j: Int ) {
      var edge = this[j].clone();
      var coEdge = coEdges[j];
      var se = sideEdges[j];
      var j0 = se.a;
      var j1 = se.b;
      var j2 = se.c;
      var j3 = se.d;

      // Amend side edges 
      coEdges[j0].substitute( edge.p, coEdge.q);
      se = sideEdges[j0];
      se.substitute( j, j1 );
      se.substitute( j3, j );

      coEdges[j1].substitute( edge.p, coEdge.p);
      se = sideEdges[j1];
      se.substitute( j , j0);
      se.substitute( j2, j );

      coEdges[j2].substitute( edge.q, coEdge.p);
      se = sideEdges[j2];
      se.substitute( j , j3);
      se.substitute( j1, j );

      coEdges[j3].substitute( edge.q, coEdge.q);
      se = sideEdges[j3];
      se.substitute( j , j2);
      se.substitute( j0, j );
        
      // Flip
      this[j] = coEdges[j];
      coEdges[j] = edge; // in order to not effect the input

      // Amend primary edge
      var tmp = sideEdges[j].a;
      sideEdges[j].a = sideEdges[j].c;
      sideEdges[j].c = tmp;
    }
    /**
     * @return      verbose string representation
     **/
    public function toString() {
        var out = 'Edges( ';
        var e: Edge;
        for( i in 0...this.length ){
            e = this[i];
            out += e.toString() + ',';
        }
        out = out.substr( 0, out.length - 1 );
        out += ' )';
        return out;
    }
    /** 
     * @return      light string reprentation easy to read but less descriptive.
     */
    public function out(){
        var out = '';
        var e: Edge;
        var l = this.length;
        for( i in 0...l ){
            out += this[i].out() + ',';
        }
        out = out.substr( 0, out.length - 1 );
        return out;
    }
}
