package tests.fillShapes;
import triangulations.FillShape;
import triangulations.Face;

abstract Sheet( FillShape ) from FillShape to FillShape {
    inline public function new(){
        this = new FillShape();
        this.vertices = [[78.791898, 339.19449], [640.43671, 339.19449], [640.43671, 352.32647], [640.43671, 367.47875999999997], [640.43671, 383.64119999999997], [640.43671, 400.81379], [640.43671, 415.46099999999996], [640.43671, 432.12852], [640.43671, 446.27065999999996], [640.43671, 462.43309999999997], [640.43671, 477.08030999999994], [640.43671, 491.22243999999995], [640.43671, 505.86965999999995], [640.43671, 520.0117899999999], [640.43671, 534.6589999999999], [640.43671, 547.7909899999999], [640.43671, 557.8925099999999], [78.79189899999994, 557.8925099999999]];
        this.edges = [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12], [12, 13], [13, 14], [14, 15], [15, 16], [16, 17], [17, 0]];
        var face: Face = [17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
        this.faces = [[face]];
    }
}
