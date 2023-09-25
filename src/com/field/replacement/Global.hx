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

                var width : Int = e.getAttribute("columns") == null ? rows.get(0).length() : Std.parseInt(e.getAttribute("columns"));
                var height : Int = e.getAttribute("rows") == null ? rows.length() : Std.parseInt(e.getAttribute("columns"));

                var wrapper = js.Browser.document.createElement("div");
                wrapper.id = e.id;
                wrapper.className = e.className;
                wrapper.classList.remove("field-table");
                wrapper.style.height = e.clientHeight + "px";
                wrapper.style.width = e.clientWidth + "px";

                var dataWrapper : Dynamic = null;
                var headerWrapper : Dynamic = null;
                if (fieldHeader != null) {
                    headerWrapper = js.Browser.document.createElement("div");
                    dataWrapper = js.Browser.document.createElement("div");
                    wrapper.appendChild(headerWrapper);
                    wrapper.appendChild(dataWrapper);
                    headerWrapper.style.height = (e.clientHeight / (header.length() + height) * header.length()) + "px";
                    dataWrapper.style.height = (e.clientHeight / (header.length() + height) * height) + "px";
                } else {
                    dataWrapper = wrapper;
                }

                e.replaceWith(wrapper);
                var viewHeader = null;
            
                var view = com.field.views.FieldView.create(
                    com.field.views.FieldView.options()
                    .field(field)
                    .parent(dataWrapper)
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
                    .onScroll(function (view : Dynamic, x : Float, y : Float) : Void {
                        if (fieldHeader != null) {
                            viewHeader.scrollView(x, y);
                        }
                    })
                );

                if (width != rows.get(0).length() || height != rows.length()) {
                    view.startDefaultListeners(view.startDefaultListenersOptions());
                }
                                
                if (fieldHeader != null) {
                    viewHeader = com.field.views.FieldView.create(
                        com.field.views.FieldView.options()
                        .field(fieldHeader)
                        .parent(headerWrapper)
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
                    var row2 : Dynamic = row;
                    var level : Int = 0;
                    if (row2.getAttribute("level") != null) {
                        level = Std.parseInt(row2.getAttribute("level"));
                    }
                    var onclick : Dynamic = null;
                    if (row2.getAttribute("onclick") != null) {
                        onclick = js.Syntax.code("eval({0})", row2.getAttribute("onclick"));
                    }
                    options.add(cast row2.innerText, level, onclick);
                }
                var view = options.parent(e.parentElement).show(true).execute();
                e.replaceWith(view.toElement());
            }, true);
            register("field-gamepad", function (e: Dynamic, header : NativeVector<NativeVector<Any>>, rows : NativeVector<NativeVector<Any>>) : Void {
                e.replaceWith(com.field.views.VirtualGamepadView.get().toElement());
            });
            register("field-pyramid", function (e: Dynamic, header : NativeVector<NativeVector<Any>>, rows : NativeVector<NativeVector<Any>>) : Void {
                var options : com.field.views.PyramidViewOptions = com.field.views.PyramidView.options()
                    .HOLHOPyramid();
                switch (rows.length()) {
                    case 0:
                        // Intentionally empty
                    case 1:
                        options.top(rows.get(0).get(0));
                    case 2:
                        options.top(rows.get(0).get(0));
                        options.bottom(rows.get(1).get(0));
                    case 3:
                        options.top(rows.get(0).get(0));
                        options.left(rows.get(1).get(0));
                        options.right(rows.get(2).get(0));
                    default:
                        options.top(rows.get(0).get(0));
                        options.left(rows.get(1).get(0));
                        options.right(rows.get(2).get(0));
                        options.bottom(rows.get(3).get(0));
                }
                // TODO -
                //options.borderColor("#000000");
                //options.backgroundColor("#FFFFFF");
                //options.foregroundColor("#000000");
                options
                    .parent(e)
                    .id(e.id)
                    .show(true);
                var view = options.execute();
                e.replaceWith(view.toElement());
            }, true);
            register("field-hex", function (e: Dynamic, header : NativeVector<NativeVector<Any>>, rows : NativeVector<NativeVector<Any>>) : Void {
                var field = com.field.Convert.array2DToFieldNoIndexesOptions().value(rows).gridTypeHex().execute();

                var width : Int = e.getAttribute("columns") == null ? rows.get(0).length() : Std.parseInt(e.getAttribute("columns"));
                var height : Int = e.getAttribute("rows") == null ? rows.length() : Std.parseInt(e.getAttribute("columns"));

                var wrapper = js.Browser.document.createElement("div");
                wrapper.id = e.id;
                wrapper.className = e.className;
                wrapper.classList.remove("field-table");
                wrapper.style.height = e.clientHeight + "px";
                wrapper.style.width = e.clientWidth + "px";

                e.replaceWith(wrapper);

                var view = com.field.views.FieldView.create(
                    com.field.views.FieldView.options()
                        .field(field)
                        .parent(wrapper)
                        .show(true)
                        .tileWidth(width)
                        .tileHeight(height)
                        .tileBuffer(0)
                        .gridTypeHex()
                        .show(true)
                        .noAreaXY(true)
                        .autoUpdate(true)
                        .scrollOnMove(true)
                        .movementForValidOnly()
                        .scrollOnWheel(true)
                );

                if (width != rows.get(0).length() || height != rows.length()) {
                    view.startDefaultListeners(view.startDefaultListenersOptions());
                }                
            });
            register("field-split", function (e: Dynamic, header : NativeVector<NativeVector<Any>>, rows : NativeVector<NativeVector<Any>>) : Void {
                var options = com.field.views.SplitView.options();
                var device : String = e.getAttribute("device");
                if (device != null) {
                    switch (StringTools.trim(device).toUpperCase()) {
                        case "ARYZON":
                            options.Aryzon();
                        case "DAYDREAM":
                            options.Daydream();
                        case "LENOVOHEADSET":
                            options.LenovoHeadset();
                        case "ANAGYLPH":
                            options.Anaglyph();                            
                    }
                }
                var view = options
                    .parent(e)
                    .id(e.id)
                    .show(true)
                    .execute();
                e.replaceWith(view.toElement());
            }, true);
            register("field-circle", function (e: Dynamic, header : NativeVector<NativeVector<Any>>, rows : NativeVector<NativeVector<Any>>) : Void {
                var view = com.field.views.CircleView.options()
                    .DreamMeOrbit()
                    .parent(e)
                    .id(e.id)
                    .show(true)
                    .execute();
                e.replaceWith(view.toElement());
            }, true);
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

    public function register(name: String, finish: Dynamic, ?elementsInList : Bool = false) {
        _searchFor.push({ name: name, finish: finish, elementsInList: elementsInList });
    }

    private static function toVector(a : NativeArray<NativeArray<Any>>) : NativeVector<NativeVector<Any>> {
        try {
            var i : Int = 0;
            var v : NativeVector<NativeVector<Any>> = new NativeVector<NativeVector<Any>>(a.length());
            for (e in a) {
                v.set(i++, e.toVector());
            }
            return v;
        } catch (ex : Any) {
            return cast a;
        }
    }

    public function replaceElements(?list : Array<Dynamic>, ?finish : com.field.renderers.Element->NativeVector<NativeVector<Any>>->NativeVector<NativeVector<Any>>->Void, ?elementsInList : Bool = false) {
        if (list == null) {
            for (search in _searchFor) {
                // TODO - Other environments
                #if JS_BROWSER
                    replaceElements([
                        cast js.Syntax.code("Array.prototype.slice.call({0})", js.Browser.document.getElementsByTagName(cast search.name)),
                        cast js.Syntax.code("Array.prototype.slice.call({0})", js.Browser.document.getElementsByClassName(cast search.name))
                    ], search.finish, search.elementsInList);
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
                var i : Int = 0;
                while (i < list.length) {
                    var e = list[i];
                    var header = new NativeArray<NativeArray<Any>>();
                    var rows = new NativeArray<NativeArray<Any>>();
                
                    function addTo(c : NativeArray<Any>, row : Dynamic, header : NativeArray<NativeArray<Any>>) : Void {
                        if (!!(row.children) && row.children.length > 0) {
                            var isHeader : Bool = false;
                            var e : NativeArray<Any> = new NativeArray<Any>();
                            var j : Int = 0;
                            while (j < row.children.length) {
                                var child = row.children[j];
                                var t = child.tagName.trim().toUpperCase();
                                switch (t) {
                                    case "TH":
                                        isHeader = true;
                                }
                                addTo(e, child, header);
                                j++;
                            }
                            if (isHeader) {
                                header.push(e);
                            } else {
                                c.push(e);
                            }
                        } else {
                            if (elementsInList) {
                                c.push(row);
                            } else {
                                c.push(row.innerText);
                            }
                        }
                    }
                
                    {
                        var e2 : Dynamic = e;
                        var j : Int = 0;
                        while (j < e2.children.length) {
                            var child = e2.children[j];
                            var t = child.tagName.trim().toUpperCase();
                            switch (t) {
                                case "TR", "LI":
                                    addTo(rows, child, header);
                                case "TBODY":
                                    e2 = child;
                                    j--;
                            }
                            j++;
                        }
                    }

                    finish(cast e, toVector(header), toVector(rows));
     
                    i++;
                }
            }
        }
    }
}