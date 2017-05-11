package triangulations;

import khaMath.Vector2;

// static inline functions related to multiple Vector2D and triangulation
// https://github.com/mkacz91/Triangulations/blob/master/js/geometry.js

class Geom2 {
    
    /*
    // Not currently used but perhaps useful.
    //
    // Copyright 2001 softSurfer, 2012 Dan Sunday
    // This code may be freely used and modified for any purpose
    // providing that this copyright notice is included with it.
    // SoftSurfer makes no warranty for this code, and cannot be held
    // liable for any real or imagined damage resulting from its use.
    // Users of this code must verify correctness for their application.
    public static inline
    function inSegment( a: Vector2, b: Vector2, p: Vector2 ): Bool {
        var out = false;
        if( a.x != b.x ) {    // S is not  vertical
            if( a.x <= p.x && p.x <= b.x ) { 
                out = true;
            } else if( a.x >= p.x && p.x >= b.x ) {
                out = true;
            }
        } else {    // S is vertical, so test y  coordinate
            if( a.y <= p.y && p.y <= b.y ) {
                out = true;
            } else if( a.y >= p.y && p.y >= b.y ){
                out = true;
            }
        }
        return out;
    }
    */
    
    public static inline
    function pointEncroachesEdge( a: Vector2, b: Vector2, p: Vector2 ):Bool {
        var c = a.mid(b);
        return c.distSq(p) <= c.distSq(a);
    }
    
    public static inline
    function triangleArea(a: Vector2, b: Vector2, c: Vector2 ): Float {
        return ( a.x * (b.y - c.y)
         + b.x * (c.y - a.y)
         + c.x * (a.y - b.y) ) / 2;
    }
    
    public static inline
    function triangleIsBad( minAngle: Float, maxArea: Float )
            : Vector2 -> Vector2 -> Vector2 -> Bool {
        minAngle *= Math.PI / 180;
        var sinSqMinAngle = Math.sin( minAngle );
        sinSqMinAngle *= sinSqMinAngle;
        return 
            function( a: Vector2, b: Vector2, c: Vector2 ): Bool {
                if( triangleArea(a, b, c) > maxArea ) return true;
                var ab = a.span(b);
                var abLenSq = ab.lenSq();
                var ca = c.span(a);
                var caLenSq = ca.lenSq();
                var abxca = ab.cross(ca);
                var sinSqcab = abxca * abxca / (abLenSq * caLenSq);
                if( abxca * abxca < sinSqMinAngle * abLenSq * caLenSq ) return true;
                var bc = b.span(c);
                var bcLenSq = bc.lenSq();
                var abxbc = ab.cross(ab);
                if( abxbc * abxbc < sinSqMinAngle * abLenSq * bcLenSq ) return true;
                var bcxca = bc.cross(ca);
                return bcxca * bcxca < sinSqMinAngle * bcLenSq * caLenSq;
      }
    }
    // Return the center of the circumscribed circle of triangle abc.
    public static inline
    function circumcenter(a: Vector2, b: Vector2, c: Vector2 ): Vector2 {
        // Taken from https://www.ics.uci.edu/~eppstein/junkyard/circumcenter.html
        var xa = a.x;
        var ya = a.y;
        var xb = b.x;
        var yb = b.y;
        var xc = c.x;
        var yc = c.y;
        var d = 2 * ((xa - xc) * (yb - yc) - (xb - xc) * (ya - yc));
        var ka = ((xa - xc) * (xa + xc) + (ya - yc) * (ya + yc));
        var kb = ((xb - xc) * (xb + xc) + (yb - yc) * (yb + yc));
        var xp = ka * (yb - yc) - kb * (ya - yc);
        var yp = kb * (xa - xc) - ka * (xb - xc);
        return new Vector2( xp / d, yp / d );
    }    
    
    // Check whether v is strictly in the interior of the circumcircle of the
    // triangle abc.
    public static inline
    function pointInCircumcircle(a: Vector2, b: Vector2, c: Vector2, v: Vector2): Bool {
        var p = circumcenter( a, b, c );
        return p.distSq(v) < a.distSq(p);
    }
    
    public static inline
    function edgeVSRay( u: Vector2, v: Vector2, y: Float ): Null<Float> {
        var val: Float;
        if(u.y > v.y) {
            var tmp = u;
            u = v;
            v = tmp;
        }
        if(y <= u.y || v.y < y) {
            val = null;
        } else {
            var t = (y - u.y) / (v.y - u.y);
            val = u.x + t * (v.x - u.x);
        }
        return val;
    }   
    
    // Returns boolean indicating whether edges ab and cd intersect.
    public static inline
    function edgesIntersect(a: Vector2, b: Vector2, c: Vector2, d: Vector2 ): Bool {
        // The edges intersect only if the endpoints of one edge are on the opposite
        // sides of the other (both ways).
        var out = true;
        var u = a.span(b);
        var su = u.cross(a.span(c)) * u.cross(a.span(d));
        // If su is positive, the endpoints c and d are on the same side of
        // edge ab.
        if (su > 0) {
            out = false;
        } else {
            var v = c.span(d);
            var sv = v.cross(c.span(a)) * v.cross(c.span(b));
            if (sv > 0) {
                out = false;
            } else {
                // We still have to check for collinearity.
                if (su == 0 && sv == 0) {
                    var abLenSq = a.distSq(b);
                    out = a.distSq(c) <= abLenSq || a.distSq(d) <= abLenSq;
                }
            }
        }
        return out;
    }    
    
    //// Functions that return a function. ////
    
    // Check wether point p is within triangle abc or on its border.
    public static inline
    function pointInTriangle(a: Vector2, b: Vector2, c: Vector2): Vector2 -> Bool {
        var u = a.span(b);
        var v = a.span(c);
        var vxu = v.cross(u);
        var uxv = -vxu;
        return function( p: Vector2 ): Bool {
            var w = a.span(p);
            var vxw = v.cross(w);
            if (vxu * vxw < 0) return false;
            var uxw = u.cross(w);
            if (uxv * uxw < 0) return false;
            return Math.abs(uxw) + Math.abs(vxw) <= Math.abs(uxv);
        };
    }
    
    public static inline
    function pointToEdgeDistSq(u: Vector2, v: Vector2): Vector2 -> Float {
        var uv = u.span(v);
        var uvLenSq = uv.lenSq();
        return function(p: Vector2){
            var uvxpu = uv.cross(p.span(u));
            return uvxpu * uvxpu / uvLenSq;
        };
    }
    
// TODO: check if Float is ideal return.
    // Given an origin c and direction defining vertex d, returns a comparator for
    // points. The points are compared according to the angle they create with
    // the vector cd.
    public static inline
    function angleCompare(c: Vector2, d: Vector2 ): Vector2 -> Vector2 -> Float {
        var cd = c.span(d);
        // Compare angles ucd and vcd
        return function (u: Vector2, v: Vector2): Float {
            var cu = c.span(u);
            var cv = c.span(v);
            var cvxcu = cv.cross(cu);
            // Check if they happen to be equal
            if(cvxcu == 0 && cu.dot(cv) >= 0) return 0;
            var cuxcd = cu.cross(cd);
            var cvxcd = cv.cross(cd);
            // If one of the angles has magnitude 0, it must be strictly smaller than
            // the other one.
            if(cuxcd == 0 && cd.dot(cu) >= 0) return -1;
            if(cvxcd == 0 && cd.dot(cv) >= 0) return 1;
            // If the points u and v are on the same side of cd, the one that is on the
            // right side of the other must form a smaller angle.
            if(cuxcd * cvxcd >= 0) return cvxcu;
            // The one on the left side of cd side forms a smaller angle.
            return cuxcd;
        }
    }   
}
