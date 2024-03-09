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

package com.field.util;

@:expose
@:nativeGen
class SingleFieldView extends com.field.views.AbstractView implements com.field.navigator.NavigatorInterface {
    public function new() {
        super();
        _element = createElement();
        #if js
            js.Syntax.code("{0}.style.height = \"100%\";", _element);
            js.Syntax.code("{0}.style.width = \"100%\";", _element);
        #end
        _field = createField();
        _view = createView();
        _view.addToOnNavigate(navigateI);
    }

    private var _field : com.field.FieldInterface<Dynamic, Dynamic>;
    private var _view : com.field.views.FieldView;

    private function getFieldOptions() : com.field.FieldOptions<Dynamic, Dynamic> {
        return com.field.FieldStandard.options();
    }

    private function getViewOptions() : com.field.views.FieldViewOptions {
        return cast com.field.views.FieldView.options();
    }

    private function createField() : com.field.FieldInterface<Dynamic, Dynamic> {
        return cast getFieldOptions().execute();
    }

    private function createView() : com.field.views.FieldView {
        return cast getViewOptions().execute();
    }

    public function fieldViews() : Array<com.field.views.FieldView> {
        return [ _view ];
    }

    private function navigateI(direction : com.field.navigator.DirectionInterface, distance : Int) : Void { }

    public function navigate(direction : com.field.navigator.DirectionInterface, distance : Int) : Bool {
        return _view.navigate(direction, distance);
    }

    public function navigateInDegrees(direction : Float, distance : Int) : Bool {
        return _view.navigateInDegrees(direction, distance);
    }

    public function navigateInRadians(direction : Float, distance : Int) : Bool {
        return _view.navigateInRadians(direction, distance);
    }

    public function navigateInClock(direction : Float, distance : Int) : Bool {
        return _view.navigateInClock(direction, distance);
    }

    public function navigateInXY(x : Int, y : Int) : Bool {
        return _view.navigateInXY(x, y);
    }

    public function directionCount() : Int {
        return _view.directionCount();
    }

    public function directions() : NativeVector<com.field.navigator.DirectionInterface> {
        return _view.directions();
    }

    public function diagonal() : com.field.navigator.NavigatorInterface {
        return _view.diagonal();
    }

    public function allDirections() : com.field.navigator.NavigatorInterface {
        return _view.allDirections();
    }

    public function standard() : com.field.navigator.NavigatorInterface {
        return _view.standard();
    }
}
