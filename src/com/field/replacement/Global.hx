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

package com.field.replacement;

@:expose
@:native
class Global {
    public function new() {
        #if JS_BROWSER
            register("field-table", function(e : Dynamic, header : NativeVector<NativeVector<Any>>, rows : NativeVector<NativeVector<Any>>) : Void {
                var field = com.field.Convert.array2DToFieldNoIndexesOptions().value(rows).execute();
                var fieldHeader = null;
                if (header.length() > 0) {
                    fieldHeader = com.field.Convert.array2DToFieldNoIndexesOptions().value(header).execute();
                }
            
                var wrapper = js.Browser.document.createElement("div");
                e.replaceWith(wrapper);
                wrapper.id = e;
                wrapper.className = e.className;
            
                var width : Int = rows.get(0).length();
                var height : Int = rows.length();
            
                var view = com.field.views.FieldView.create(
                    com.field.views.FieldView.options()
                    .field(field)
                    .parent(wrapper)
                    .show(true)
                    .tileWidth(width)
                    .tileHeight(height)
                    .tileBuffer(0)
                    .noAreaXY(true)
                    .autoUpdate(true)
                    .scrollOnMove(true)
                    .movementForValidOnly()
                    .tilesAreSquares(false)
                    .scrollOnWheel(true)
                );
            
                var viewHeader = null;
                if (fieldHeader != null) {
                    viewHeader = com.field.views.FieldView.create(
                        com.field.views.FieldView.options()
                        .field(fieldHeader)
                        .parent(wrapper)
                        .show(true)
                        .tileWidth(width)
                        .tileHeight(header.length())
                        .tileBuffer(0)
                        .noAreaXY(true)
                        .autoUpdate(true)
                        .scrollOnMove(true)
                        .movementForValidOnly()
                        .tilesAreSquares(false)
                        .scrollOnWheel(false)
                    );
                }
            });
            register("field-vertical-menu", function (e: Dynamic, header : NativeVector<NativeVector<Any>>, rows : NativeVector<NativeVector<Any>>) : Void {
                var options : com.field.views.VerticalMenuViewOptions = com.field.views.VerticalMenuView.options();
                for (row in rows) {
                    options.add(row.get(0));
                }
                var wrapper = js.Browser.document.createElement("div");
                e.replaceWith(wrapper);
                var view = options.parent(wrapper).show(true).execute();
            });
            register("field-gamepad", function (e: Dynamic, header : NativeVector<NativeVector<Any>>, rows : NativeVector<NativeVector<Any>>) : Void {
                e.replaceWith(com.field.views.VirtualGamepadView.get().toElement());
            });
            register("field-pyramid", function (e: Dynamic, header : NativeVector<NativeVector<Any>>, rows : NativeVector<NativeVector<Any>>) : Void {
                var options : com.field.views.PyramidViewOptions = com.field.views.PyramidView.options();
                switch (rows.length()) {
                    case 0:
                        // Intentionally empty
                    case 1:

                    case 2:
                    default:
                }
            });
            register("field-split", function (e: Dynamic, header : NativeVector<NativeVector<Any>>, rows : NativeVector<NativeVector<Any>>) : Void {
            });
            register("field-circle", function (e: Dynamic, header : NativeVector<NativeVector<Any>>, rows : NativeVector<NativeVector<Any>>) : Void {
            });            
            register("field-graph", function (e: Dynamic, header : NativeVector<NativeVector<Any>>, rows : NativeVector<NativeVector<Any>>) : Void {
            });
        #end
    }
    private var _searchFor: Array<Dynamic> = [];
    private static var _instance : Global = null;
    public static function instance() : Global {
        if (_instance == null) {
            _instance = new Global();
        }
        return _instance;
    }
    public function register(name: String, finish: Dynamic) {
        _searchFor.push({ name: name, finish: finish });
    }
    public function replaceElements(?list : Array<Dynamic>, ?finish : com.field.renderers.Element->Array<Array<String>>->Array<Array<String>>->Void) {
        if (list == null) {
            for (search in _searchFor) {
                // TODO - Other environments
                #if JS_BROWSER
                    replaceElements([
                        cast js.Syntax.code("Array.prototype.slice.call({0})", js.Browser.document.getElementsByTagName(cast search.name)),
                        cast js.Syntax.code("Array.prototype.slice.call({0})", js.Browser.document.getElementsByClassName(cast search.name))
                    ], search.finish);
                #end
            }
        } else {
            #if js
                list = cast js.Syntax.code("{0}.flat()", list);
            #else
                {
                    var arr = [];
                    var i : Int = 0;
                    while (i < list.length) {
                        if (Std.is(list[i], Array)) {
                            var arr2 : Array<Dynamic> = cast list[i];
                            arr = arr.concat(arr2.copy());
                        } else {
                            arr.push(list[i]);
                        }
                        i++;
                    }
                    list = arr;
                }
            #end
            
            {
                var arr = [];
                var i : Int = 0;
                while (i < list.length) {
                    var arr2 : Array<Dynamic> = cast list[i];
                    arr = arr.concat(arr2.copy());
                    i++;
                }
                list = arr;
            }
            {
                var i : Int = 0;
                while (i < list.length) {
                    var e = list[i];
                    var header = [];
                    var rows = [];
                
                    function addTo(c : Dynamic, row : Dynamic) : Void {
                        if (!!(row.children)) {
                            var e = [];
                            c.push(e);
                            var j : Int = 0;
                            while (j < row.children.length()) {
                                addTo(e, row.children[j]);
                                j++;
                            }
                        } else {
                            c.push(row.innerText);
                        }
                    }
                
                    {
                        var j : Int = 0;
                        while (j < e.children.length) {
                            var child = e.children[j];
                            var t = child.tagName.trim().toUpperCase();
                            switch (t) {
                                case "TR":
                                case "LI":
                                    addTo(rows, child);
                                case "TH":
                                    addTo(header, child);
                            }
                            j++;
                        }
                    }

                    finish(cast e, header, rows);
     
                    i++;
                }
            }
        }
    }
}