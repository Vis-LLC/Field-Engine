/*
    Copyright (C) 2020-2023 Vis LLC - All Rights Reserved

    This program is free software : you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <https ://www.gnu.org/licenses/>.
*/

/*
    FieldEngine
    FieldEngine - Source code can be found on SourceForge.net
*/

package com.field;

import com.field.FrameOfReference;

@:expose
@:nativeGen
/**
    Allows for the transformation of XY coordinates in case the representation of the coordinates is different than expected.
**/
class FieldMapping implements FrameOfReference {
    private var _previous : FieldMapping;

    public function new(previous : FieldMapping) {
        _previous = previous;
    }

    public function transformX(x : Float, y : Float) : Float {
        return _previous.transformX(x, y);
    }

    public function transformY(x : Float, y : Float) : Float {
        return _previous.transformY(x, y);
    }

    public function reverseX(x : Float, y : Float) : Float {
        return _previous.reverseX(x, y);
    }

    public function reverseY(x : Float, y : Float) : Float {
        return _previous.reverseX(x, y);
    }    
}

@:expose
@:nativeGen
class FieldMappingWrap extends FieldMapping {
    private var _reference : FrameOfReference;

    public function new(previous : FrameOfReference) {
        super(null);
        _reference = previous;
    }
}

@:expose
@:nativeGen
class FieldMappingSwapXY extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

    public override function transformX(x: Float, y : Float) : Float {
        return _previous.transformY(x, y);
    }

    public override function transformY(x: Float, y : Float) : Float {
        return _previous.transformX(x, y);
    }

    public override function reverseX(x: Float, y : Float) : Float {
        return _previous.reverseY(x, y);
    }

    public override function reverseY(x: Float, y : Float) : Float {
        return _previous.reverseX(x, y);
    }    
}

@:expose
@:nativeGen
class FieldMappingInvertX extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

    public override function transformX(x: Float, y : Float) : Float {
        return _previous.transformX(x, y) * -1;
    }

    public override function reverseX(x: Float, y : Float) : Float {
        return _previous.reverseX(x, y) * -1;
    }
}

@:expose
@:nativeGen
class FieldMappingInvertY extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

    public override function transformY(x: Float, y : Float) : Float {
        return _previous.transformY(x, y) * -1;
    }

    public override function reverseY(x: Float, y : Float) : Float {
        return _previous.reverseY(x, y) * -1;
    }    
}

@:expose
@:nativeGen
class FieldMappingLogX extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

    public override function transformX(x: Float, y : Float) : Float {
        return Math.log(x) / Math.log(10);
    }

    public override function reverseX(x: Float, y : Float) : Float {
        return Math.pow(10, x);
    }    
}

@:expose
@:nativeGen
class FieldMappingLogY extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

    public override function transformY(x: Float, y : Float) : Float {
        return Math.log(y) / Math.log(10);
    }

    public override function reverseY(x: Float, y : Float) : Float {
        return Math.pow(10, y);
    }    
}

@:expose
@:nativeGen
class FieldMappingLnX extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

    public override function transformX(x: Float, y : Float) : Float {
        return Math.log(x);
    }

    public override function reverseX(x: Float, y : Float) : Float {
        return Math.exp(x);
    }    
}

@:expose
@:nativeGen
class FieldMappingLnY extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

    public override function transformY(x: Float, y : Float) : Float {
        return Math.log(y);
    }

    public override function reverseY(x: Float, y : Float) : Float {
        return Math.exp(y);
    }    
}

@:expose
@:nativeGen
class FieldMappingPowerOf10X extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

    public override function transformX(x: Float, y : Float) : Float {
        return Math.pow(10, x);
    }

    public override function reverseX(x: Float, y : Float) : Float {
        return Math.log(x) / Math.log(10);
    }    
}

@:expose
@:nativeGen
class FieldMappingPowerOf10Y extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

    public override function transformY(x: Float, y : Float) : Float {
        return Math.pow(10, y);
    }

    public override function reverseY(x: Float, y : Float) : Float {
        return Math.pow(10, y);
    }    
}

@:expose
@:nativeGen
class FieldMappingPowerOfEX extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

    public override function transformX(x: Float, y : Float) : Float {
        return Math.exp(x);
    }

    public override function reverseX(x: Float, y : Float) : Float {
        return Math.log(x);
    }    
}

@:expose
@:nativeGen
class FieldMappingPowerOfEY extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

    public override function transformY(x: Float, y : Float) : Float {
        return Math.exp(y);
    }

    public override function reverseY(x: Float, y : Float) : Float {
        return Math.log(y);
    }    
}

// TODO
@:expose
@:nativeGen
class FieldMappingOffsetOddR extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

}

// TODO
@:expose
@:nativeGen
class FieldMappingOffsetEvenR extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

}

@:expose
@:nativeGen
class FieldMappingOffsetOddQ extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

    public override function transformX(x: Float, y : Float) : Float {
        return x / 2;
    }

    public override function transformY(x: Float, y : Float) : Float {
        return x % 2 + y * 2;
    }

    public override function reverseX(x: Float, y : Float) : Float {
        return x * 2 + y % 2;
    }

    public override function reverseY(x: Float, y : Float) : Float {
        return y / 2;
    }  
}

@:expose
@:nativeGen
class FieldMappingOffsetEvenQ extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

    public override function transformX(x: Float, y : Float) : Float {
        return (x + 1) / 2;
    }

    public override function transformY(x: Float, y : Float) : Float {
        return (x + 1) % 2 + y * 2;
    }

    public override function reverseX(x: Float, y : Float) : Float {
        return x * 2 + (y + 1) % 2;
    }

    public override function reverseY(x: Float, y : Float) : Float {
        return y / 2;
    }     
}

// TODO
@:expose
@:nativeGen
class FieldMappingOffsetOddRDoubled extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

}

// TODO
@:expose
@:nativeGen
class FieldMappingOffsetEvenRDoubled extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

}

@:expose
@:nativeGen
class FieldMappingOffsetOddQDoubled extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

    public override function transformX(x: Float, y : Float) : Float {
        return x / 2;
    }

    public override function transformY(x: Float, y : Float) : Float {
        return x % 2 + y;
    }

    public override function reverseX(x: Float, y : Float) : Float {
        return x * 2 + (y / 2) % 2;
    }

    public override function reverseY(x: Float, y : Float) : Float {
        return y;
    } 
}

@:expose
@:nativeGen
class FieldMappingOffsetEvenQDoubled extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

    public override function transformX(x: Float, y : Float) : Float {
        return (x + 1) / 2;
    }

    public override function transformY(x: Float, y : Float) : Float {
        return (x + 1) % 2 + y;
    }

    public override function reverseX(x: Float, y : Float) : Float {
        return x * 2 + (y / 2 + 1) % 2;
    }

    public override function reverseY(x: Float, y : Float) : Float {
        return y;
    } 
}

@:expose
@:nativeGen
class FieldMappingOffsetAxial extends FieldMapping {
    public function new(previous : FieldMapping) {
        super(previous);
    }

    public override function transformX(x: Float, y : Float) : Float {
        return x / 2;
    }

    public override function transformY(x: Float, y : Float) : Float {
        return x + y * 2;
    }

    public override function reverseX(x: Float, y : Float) : Float {
        return x * 2 + y % 2;
    }

    public override function reverseY(x: Float, y : Float) : Float {
        return (y - x) / 2;
    }   
}