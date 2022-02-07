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

// TODO - Put dInnerDiv.style.zIndex = 0; in style
// TODO - Put dInnerDiv2.style.zIndex = -1; in style
// TODO - Put dInnerDiv3.style.zIndex = -2; in style

@:expose
@:nativeGen
/**
    Displays a Field in an Element.
**/
class FieldView extends FieldViewAbstract implements FieldViewFullInterface {
    private static function withDefault(v : Any, d : Any) : Any {
        if (v == null) {
            return d;
        } else {
            return v;
        }
    }

    /**
        Create a FieldView based on the specified options.
    **/
    public static function create(options : FieldViewOptions) : FieldView {
        return new FieldView(options);
    }

    /**
        Returns the possible options for creating a FieldView.
    **/
    public static function options() : FieldViewOptions {
        return new FieldViewOptions();
    }

    private function new(options : FieldViewOptions) {
        super(options.toMap());
    }

    public function setMainSprite(s : SpriteInterface<Dynamic, Dynamic>) : Void {
        if (s != null) {
            _mainSprite = s;
            _moveSprite = _spriteMoverActual;
        } else {
            _mainSprite = null;
            _moveSprite = _spriteMoverNull;
        }
    }

    public function needToAdd(s : SpriteInterface<Dynamic, Dynamic>) : Void {
        _spritesAdded.push(s);
    }

    public function findViewForSprite(s : SpriteInterface<Dynamic, Dynamic>) {
        return _spriteToViews.get(s.getI());
    }
}