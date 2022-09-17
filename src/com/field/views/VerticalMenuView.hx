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
import com.field.NativeObjectMap;
import com.field.renderers.Element;

@:expose
@:nativeGen
/**
    A VerticalMenuView is a FieldView that is meant to display a vertical menu.
**/
class VerticalMenuView extends FieldViewAbstract {
    private var _callbacks : NativeVector<Void->Void>;
    private var _indents : NativeVector<Int>;
    private var _items : NativeVector<String>;
    private var _open : NativeVector<Int>;
    private var _children : NativeVector<Int>;
    private var _path : String;

    private function refreshMenu(openClose : Bool, itemIndex : Int) : FieldInterface<Dynamic, Dynamic> {
        var map : NativeVector<NativeVector<String>> = new NativeVector<NativeVector<String>>(_items.length());
        var i : Int = 0;
        var j : Int = 0;
        var shift : Int;
        if (itemIndex >= 0) {
            shift = _children.get(itemIndex) * (openClose ? 1 : -1);
        } else {
            shift = 0;
        }
        var subMenu : NativeVector<Bool> = new NativeVector<Bool>(_items.length());
        var subOpen : NativeVector<Bool> = new NativeVector<Bool>(_items.length());
        var display : NativeVector<Bool> = new NativeVector<Bool>(_items.length());
        {
            var open : NativeArray<Bool> = new NativeArray<Bool>();
            open.push(true);
            while (i < _items.length()) {
                display.set(i, open.get(open.length() - 1));
                if (display.get(i)) {
                    var item : NativeVector<String> = new NativeVector<String>(1);
                    item.set(0, _items.get(i));
                    map.set(j, item);
                    j++;
                }
                if (i >= (_items.length() - 1)) {
                    subMenu.set(i, false);
                } else if (_indents.get(i) < _indents.get(i + 1)) {
                    subMenu.set(i, true);
                } else {
                    subMenu.set(i, false);
                    if (_indents.get(i) > _indents.get(i + 1)) {
                        open.pop();
                    }
                }
                if (subMenu.get(i)) {
                    subOpen.set(i, (_open.get(i) == null || _open.get(i) == 1 || _open.get(i) == -1));
                    open.push(subOpen.get(i));
                } else {
                    subOpen.set(i, false);
                }
                i++;
            }
            open = null;
        }
        while (j < map.length()) {
            var item : NativeVector<String> = new NativeVector<String>(1);
            item.set(0, "");
            map.set(j, item);
            j++;
        }
        var field : FieldInterface<Dynamic, Dynamic> = com.field.Convert.array2DToFieldNoIndexesOptions().value(map).execute();
        map = null;
        i = 0;
        j = 0;
        while (i < _items.length()) {
            if (display.get(i)) {
                var l : LocationInterface<Dynamic, Dynamic> = field.get(0, j);
                l.attribute("submenu", subMenu.get(i));
                l.attribute("indent", _indents.get(i));
                l.attribute("index", i);
                if (subMenu.get(i)) {
                    l.attribute("open", subOpen.get(i));
                }
                if (i <= itemIndex) {
                    l.attribute("shiftY", 0);
                } else if (i > (itemIndex + shift)) {
                    l.attribute("shiftY", shift);
                } else {
                    var shiftPart : Int = i - itemIndex;
                    //l.attribute("shiftY", shiftPart);
                    l.attribute("shiftY", shift);
                }
                l.doneWith();
                j++;
            }
            i++;
        }
        if (_field != null) {
            this.field(field);
        }
        return field;
    }

    private function new(options : VerticalMenuViewOptions) {
        var fo : NativeStringMap<Any> = options.toMap();
        var indents : NativeArray<Int> = cast fo.get("indents");
        _indents = indents.toVector();
        var items : NativeArray<String> = cast fo.get("items");
        _items = items.toVector();
        var open : NativeArray<Int> = cast fo.get("open");
        _open = open.toVector();
        var path : String = cast fo.get("path");
        _path = path;
        var callbacks : NativeArray<Void->Void> = cast fo.get("callbacks");
        _callbacks = callbacks.toVector();
        _children = new NativeVector<Int>(_items.length());
        {
            var parent : NativeArray<Int> = new NativeArray<Int>();
            var i : Int = 0;
            while (i < _indents.length()) {
                _children.set(i, 0);
                i++;
            }
            i = 0;
            while (i < _indents.length()) {
                if (i < (_indents.length() - 1) && _indents.get(i) < _indents.get(i + 1)) {
                    parent.push(i);
                } else if (_indents.get(i) > _indents.get(i + 1)) {
                    var currentParent : Int = parent.get(parent.length() - 1);
                    _children.set(currentParent, _children.get(currentParent) + 1);
                    parent.pop();
                } else if (parent.length() > 0) {
                    var currentParent : Int = parent.get(parent.length() - 1);
                    _children.set(currentParent, _children.get(currentParent) + 1);
                }
                i++;
            }
            parent = null;
        }
        if (fo.get("field") == null) {
            options.field(refreshMenu(false, -1));
        }
        if (fo.get("tileHeight") == null) {
            options.tileHeight(items.length());
        }
        if (fo.get("tileWidth") == null) {
            options.tileWidth(1);
        }
        if (fo.get("tileBuffer") == null) {
            if (fo.get("tileHeight") != null && (cast fo.get("tileHeight")) < items.length()) {
                options.tileBuffer(2);
            } else {
                options.tileBuffer(0);
            }
        }
        if (fo.get("locationEffectElement") == null) {
            options.locationEffectElement(false);
        }
        if (fo.get("locationSelectElement") == null) {
            options.locationSelectElement(false);
        }
        if (fo.get("calculatedAttributes") == null) {
            options.simpleView();
        }
        if (fo.get("willChange") == null) {
            options.primarilyStatic();
        }
        if (fo.get("style") == null) {
            options.style("verticalMenu");
        }
        if (fo.get("shiftYLimit") == null) {
            options.shiftYLimit(_items.length());
        }

        com.field.Events.locationSelect().addEventListener(function (e : EventInfo<Dynamic, Dynamic, Dynamic>) : Void {
            var field : FieldInterface<Dynamic, Dynamic> = e.field();
            if (field.equals(_field)) {
                var i : Int = e.location().attribute("index");
                var callback : Void -> Void = _callbacks.get(i);
                if (callback != null) {
                    callback();
                }
                if (_children.get(i) > 0) {
                    switch (_open.get(i)) {
                        case 0:
                            _open.set(i, 1);
                            refreshMenu(true, i);
                        case 1:
                            _open.set(i, 0);
                            refreshMenu(false, i);
                    }
                }
            }
        });
        super(options.toMap());
    }

    public static function create(options : VerticalMenuViewOptions) : VerticalMenuView {
        return new VerticalMenuView(options);
    }

    public static function options() : VerticalMenuViewOptions {
        return new VerticalMenuViewOptions();
    }
}
#end