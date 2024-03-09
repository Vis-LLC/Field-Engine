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
class LicenseView extends com.field.views.AbstractView {
    public var _close : Array<com.field.renderers.Element>;
    public var _loading : Array<com.field.renderers.Element>;

    private function addLines(lines : Array<String>) {
        for (line in lines) {
            addLine(line);
        }
    }

    private function addHeader(text : String) {
        #if js
            var h = cast js.Browser.document.createElement("h3");
            h.innerHTML = text;
            appendChild(_element, cast h);
        #end
    }

    private function addLine(line : String) {
        #if js
            var p = cast js.Browser.document.createElement("p");
            p.innerHTML = line;
            appendChild(_element, cast p);
        #end
    }

    private function addAssets(assets : Array<String>) {
        #if js
            var table = cast js.Browser.document.createElement("table");
            var i : Int = 0;
            while (i < assets.length) {
                var tr = cast js.Browser.document.createElement("tr");
                var td = cast js.Browser.document.createElement("td");
                appendChild(tr, cast td);
                td.innerText = assets[i + 0];
                td = cast js.Browser.document.createElement("td");
                td.innerText = assets[i + 1];
                appendChild(tr, cast td);
                appendChild(table, cast tr);
                i += 2;
            }
            appendChild(_element, cast table);
        #end
    }

    private function initClose() {
        #if js
            var b1 : js.html.ButtonElement = cast js.Browser.document.createButtonElement();
            var b2 : js.html.ButtonElement = cast js.Browser.document.createButtonElement();
            _close = [cast b1, cast b2 ];
            b1.innerText = "Close";
            b2.innerText = b1.innerText;
        #end
    }

    private function initLoading() {
        #if js
            var l1 = cast js.Browser.document.createDivElement();
            var l2 = cast js.Browser.document.createDivElement();
            _loading = [cast l1, cast l2];
            l1.innerText = "Loading...";
            l2.innerText = l1.innerText;
        #end
    }

    public function new(text : Array<Dynamic>, assetTextStart : String, assets : Array<String>, assetTextEnd : String) {
        super();
        _element = createElement();
        initClose();
        initLoading();
        appendChild(_element, cast _close[0]);
        appendChild(_element, cast _loading[0]);
        for (line in text) {
            if (Std.isOfType(line, Array)) {
                addLines(cast line);
            } else if (Std.isOfType(line, String)) {
                addHeader(cast line);
            }
        }
        addHeader(assetTextStart);
        addAssets(assets);
        addLine(assetTextEnd);
        appendChild(_element, cast _close[1]);
        appendChild(_element, cast _loading[1]);
    }
}