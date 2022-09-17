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
import com.field.navigator.DirectionInterface;

@:expose
@:nativeGen
/**
    Specifies options for creating GraphViews.
**/
class VerticalMenuViewOptions extends FieldViewOptionsAbstract<VerticalMenuViewOptions> {
    public inline function new() {
        super();
        _values.set("lockSquareOrientation", false);
    }

    public function add(item : String, ?indent : Int = 0, ?callback : Void->Void = null, ?open : Int = 0) : VerticalMenuViewOptions {
        var items : NativeArray<String> = cast _values.get("items");
        var indents : NativeArray<Int> = cast _values.get("indents");
        var callbacks : NativeArray<Void->Void> = cast _values.get("callbacks");
        var opens : NativeArray<Int> = cast _values.get("open");
        if (items == null) {
            items = new NativeArray<String>();
            indents = new NativeArray<Int>();
            callbacks = new NativeArray<Void->Void>();
            opens = new NativeArray<Int>();
            _values.set("items", items);
            _values.set("indents", indents);
            _values.set("callbacks", callbacks);
            _values.set("open", opens);
        }
        items.push(item);
        indents.push(indent);
        callbacks.push(callback);
        opens.push(open);
        return this;
    }

    /**
        Create a GraphView using the specified options.
    **/
    public function execute() : VerticalMenuView {
        return VerticalMenuView.create(this);
    }    
}
#end