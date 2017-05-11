package triangulations;
/**
 *  SideEdge used in quad
 **/
class SideEdge {
    public var length: Int = 4;
    public var a: Null<Int>;
    public var b: Null<Int>;
    public var c: Null<Int>;
    public var d: Null<Int>;
    public var count: Int = 0;
    public function new( a_: Null<Int>, b_: Null<Int>, c_: Null<Int>, d_: Null<Int> ){
        a = a_;
        b = b_;
        c = c_;
        d = d_;
    }
    /**
     * create empty side edge to put values on later
     **/
    public static inline 
    function getEmpty(){
        var sideEdge = new SideEdge( null, null, null, null );
        return sideEdge;
    }
    /**
     * to allow iteration on SideEdge as if it's an array!
     **/
    public inline
    function iterator<Int>():Iterator<Int> { 
        count = 0;
        return cast this;
    }
    /**
     * special push that emulates array where you can push on to the next side that is empty
     **/
    public inline
    function push( val: Int ){
        if( a == null ){
            a = val;
        } else if( b == null ){
            b = val;
        } else if ( c == null ){
            c = val;
        } else if( d == null ){
            d = val;
        } else {
            throw "Error SideEdge already full can't push";
        }
    }
    /**
     * checks if you can keep iterating through a,b,c,d 
     **/
    public inline
    function hasNext(): Bool {
        return count < length;
    }
    /**
     * get next with count helping it to be like an array your can loop through
     **/
    public inline
    function next(): Null<Int> { 
        var out: Null<Int>;
        switch( count ){
            case 0:
                out = a;
            case 1:
                out = b;
            case 2:
                out = c;
            case 3:
                out = d;
            default:
                out = a;
        }
        count++;
        return out; 
    }
    /**
     * allows you to get value by it's index rather than a,b,c,d
     **/
    public inline 
    function getByIndex( i: Int ): Null<Int> {
        var out: Int;
        switch( i ){
            case 0:
                out = a;
            case 1:
                out = b;
            case 2:
                out = c;
            case 3:
                out = d;
            default:
                out = a;
        }
        return out;
    }
    /**
     * used in flipping edges
     **/
    public inline
    function substitute( x: Null<Int>, y: Null<Int> ) {
        if( this == null ) return;
        if( x == a ){
            a = y;
        } else if( x == b ){
            b = y;
        } else if( x == c ){
            c = y;
        } else {
            d = y;
        }
    }
}
