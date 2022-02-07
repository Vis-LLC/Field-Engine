/*
    Copyright (C) 2020-2021 Vis LLC - All Rights Reserved

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

package com.field.views;

import com.field.navigator.DirectionInterface;
import com.field.renderers.Style;

@:expose
@:nativeGen
/**
    Specifies options for creating FieldViews.
**/
class FieldViewOptions extends FieldViewOptionsAbstract<FieldViewOptions> {
    public inline function new() { super(); }

    /**
        Specifies that individual tiles have equal sides.  Default is true.
    **/
    public function tilesAreSquares(squares : Bool) : FieldViewOptions {
        return set("lockSquareOrientation", squares);
    }

    /**
        The size of the view is "locked" after creation.  Default is true.
    **/
    public function lockViewSize(lock : Bool) : FieldViewOptions {
        return set("lockViewSize", lock);
    }

    /**
        The style to assign to SpriteViews.
    **/
    public function spriteStyle(style : Any) : FieldViewOptions {
        return set("spriteStyle", style);
    }

    /**
        Have the tile layer in SpriteViews.  Default is true.
    **/
    public function spriteTileElement(spriteTileElement : Bool) : FieldViewOptions {
        return set("spriteTileElement", spriteTileElement);
    }

    /**
        Have the effect layer in LocationViews.  Default is true.
    **/
    public function spriteEffectElement(spriteEffectElement : Bool) : FieldViewOptions {
        return set("spriteEffectElement", spriteEffectElement);
    }

    /**
        Have the select layer in LocationViews.  Default is true.
    **/
    public function spriteSelectElement(spriteSelectElement : Bool) : FieldViewOptions {
        return set("spriteSelectElement", spriteSelectElement);
    }

    /**
        Don't hide the SpriteView when adding it to the FieldView.
    **/
    public function spriteNoHideShow(spriteNoHideShow : Bool) : FieldViewOptions {
        return set("spriteNoHideShow", spriteNoHideShow);
    }

    /**
        Fire event when mouse is over SpriteView.
    **/
    public function spriteSetOnMouseOver(spriteSetOnMouseOver : Bool) : FieldViewOptions {
        return set("spriteSetOnMouseOver", spriteSetOnMouseOver);
    }

    /**
        Keep a pool of SpriteViews and reuse allocated ones.
    **/
    public function reuseSpriteViews(reuseSpriteViews : Bool) : FieldViewOptions {
        return set("reuseSpriteViews", reuseSpriteViews);
    }

    /**
        Make FieldView display a grid of hexagons.
    **/
    public function gridTypeHex() : FieldViewOptions {
        return setOnce("gridType", 3);
    }

    /**
        Make FieldView display a grid of squares.
    **/
    public function gridTypeSquare() : FieldViewOptions {
        return setOnce("gridType", 1);
    }    

    /**
        Make FieldView display a grid of rectangles.
    **/
    public function gridTypeRectangle() : FieldViewOptions {
        return setOnce("gridType", 2);
    }        

    /**
        Make FieldView display a grid of triangles.
    **/    
    public function gridTypeTriangle() : FieldViewOptions {
        return setOnce("gridType", 4);
    }

    /**
        Make FieldView isometric, leaning inwards slightly.
    **/    
    public function isometricStraight() : FieldViewOptions {
        return setOnce("isometric", 1);
    }

    /**
        Make FieldView isometric, leaning inwards significantly.
    **/    
    public function isometricDeep() : FieldViewOptions {
        return setOnce("isometric", 2);
    }    

    /**
        Make FieldView isometric, rotated clockwise.
    **/    
    public function isometricClock() : FieldViewOptions {
        return setOnce("isometric", 3);
    }        

    /**
        Make FieldView isometric, rotated counterclockwise.
    **/
    public function isometricCounter() : FieldViewOptions {
        return setOnce("isometric", 4);
    }
    
    /**
        Create a FieldView using the specified options.
    **/
    public function execute() : FieldView {
        return FieldView.create(this);
    }
}