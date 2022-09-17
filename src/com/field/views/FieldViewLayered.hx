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

#if !EXCLUDE_RENDERING
/*


import com.field.NativeObjectMap;
import com.field.navigator.DirectionInterface;
import com.field.renderers.Element;
import com.field.renderers.LeftStyle;
import com.field.renderers.TopStyle;
import com.field.renderers.Style;

// TODO - Put dInnerDiv.style.zIndex = 0; in style
// TODO - Put dInnerDiv2.style.zIndex = -1; in style
// TODO - Put dInnerDiv3.style.zIndex = -2; in style
@:expose
@:nativeGen
class FieldViewLayered extends AbstractView implements FieldViewInterface {
    private var _mainLayerIndex : Int;
    private var _views : NativeVector<FieldViewInterface>;
    private var _mainLayer : FieldViewInterface;
    private var _magnifier : NativeVector<Float>;
    private var _layers : NativeVector<FieldInterface<Dynamic, Dynamic>>;

    private function updateLayers() : Void {

    }

    public function changeLayers(delta : Int) : Void {
        _mainLayerIndex += delta;
        updateLayers();
    }

    public function directionCount() : Int {
        return _mainLayer.directionCount();
    }

    public function directions() : NativeVector<DirectionInterface> {
        return _mainLayer.directions();
    }

    public function navigate(direction : DirectionInterface, distance : Int) : Bool {
        return _mainLayer.navigate(direction, distance);
    }

    public function navigateInDegrees(direction : Float, distance : Int) : Bool {
        return _mainLayer.navigateInDegrees(direction, distance);
    }

    public function navigateInRadians(direction : Float, distance : Int) : Bool {
        return _mainLayer.navigateInRadians(direction, distance);
    }

    public function navigateInClock(direction : Float, distance : Int) : Bool {
        return _mainLayer.navigateInClock(direction, distance);
    }

    public function navigateInXY(x : Int, y : Int) : Bool {
        return _mainLayer.navigateInXY(x, y);
    }
}
*/
#end