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
class StartGameView extends com.field.views.AbstractView {
    public var _newGame : com.field.renderers.Element;
    public var _loadGame : com.field.renderers.Element;
    public var _license : com.field.renderers.Element;
    public var _url : com.field.renderers.Element;

    public function new(title : String, version : String, copyrightNotice : String, loadGame : String, newGame : String, license : String, url : String, imageResource : String) {
        super();
        _element = createElement();
        createTitle(title, version, imageResource);
        createButtons(loadGame, newGame, license);
        createFooter(url);
    }

    private function createTitle(title : String, version : String, imageResource : String) {
        #if js
            if (title != null) {
                var h = cast js.Browser.document.createElement("h1");
                h.innerHTML = title;
                appendChild(_element, cast h);
            }
            if (version != null) {
                var h = cast js.Browser.document.createElement("h3");
                h.innerHTML = version;
                appendChild(_element, cast h);
            }
            if (imageResource != null) {
                var img = cast js.Browser.document.createImageElement();
                img.src = imageResource;
                appendChild(_element, cast img);
            }
        #end
    }

    private function createButtons(loadGame : String, newGame : String, license : String) {
        #if js
            if (loadGame != null) {
                var br = cast js.Browser.document.createElement("br");
                appendChild(_element, cast br);
                var e = js.Browser.document.createButtonElement();
                _loadGame = cast e;
                e.innerHTML = loadGame;
                appendChild(_element, cast _loadGame);
            }
            if (newGame != null) {
                var br = cast js.Browser.document.createElement("br");
                appendChild(_element, cast br);
                var e = js.Browser.document.createButtonElement();
                _newGame = cast e;
                e.innerHTML = newGame;
                appendChild(_element, cast _newGame);
            }
            if (license != null) {
                var br = cast js.Browser.document.createElement("br");
                appendChild(_element, cast br);
                var e = js.Browser.document.createButtonElement();
                _license = cast e;
                e.innerHTML = license;
                appendChild(_element, cast _license);
            }
        #end
    }

    private function createFooter(url : String) {
        #if js
            if (url != null) {
                var br = cast js.Browser.document.createElement("br");
                appendChild(_element, cast br);
                var e = js.Browser.document.createAnchorElement();
                _url = cast e;
                e.innerHTML = url;
                e.href = url;
                appendChild(_element, cast _url);
            }
        #end
    }
}