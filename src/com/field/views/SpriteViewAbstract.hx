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
import com.field.Logger;
import com.field.renderers.Element;
import com.field.renderers.EventInfoInterface;
import com.field.renderers.RendererMode;
import com.field.renderers.Style;

@:expose
@:nativeGen
/**
    Displays a Sprite in an Element.
**/
class SpriteViewAbstract<F, S> extends AbstractView implements com.field.renderers.MouseEventReceiver implements com.field.renderers.TouchEventReceiver implements com.field.Usable<F, S> {
    public static var FIELD_SPRITE_STYLE : Style = cast "field_sprite";
    public static var FIELD_TILE_STYLE : Style = cast "field_tile";
    public static var FIELD_EFFECT_STYLE : Style = cast "field_effect";
    public static var FIELD_SELECT_STYLE : Style = cast "field_select";
    public static var FIELD_SHELL_STYLE : Style = cast "field_shell";
    private static var FIELD_SPRITE_AND_TILE_STYLE : Style = cast "field_sprite field_tile";
    private static var FIELD_SPRITE_AND_EFFECT_STYLE : Style = cast "field_sprite field_effect";
    private static var FIELD_SPRITE_AND_SELECT_STYLE : Style = cast "field_sprite field_select";

    private var _sprite : SpriteInterface<Dynamic, Dynamic>;
    private var _tile : Element;
    private var _effect : Element;
    private var _select : Element;
    private var _settings : #if cs CommonSettings<Any> #else CommonSettings<SpriteViewAbstract<F, S>> #end;
    private var _originalStyle : Style;
    private var _shell : NativeVector<Element>;
    private var _hasText : Bool = false;
    private var _field : FieldViewAbstract;

    #if js
        // Intentionally empty
    #else
        private static var _elementToView : NativeObjectMap<SpriteViewAbstract<Dynamic, Dynamic>> = new NativeObjectMap<SpriteViewAbstract<Dynamic, Dynamic>>();
    #end

    // TODO - Package only
    public function new() {
        super();
    }

    /**
        Get the SpriteView for a Location.
        This function is not meant to be used externally, only internally to the FieldEngine library.
    **/
    public static function getI(sSprite : SpriteInterface<Dynamic, Dynamic>, settings : CommonSettings<SpriteViewAbstract<Dynamic, Dynamic>>, field : FieldViewAbstract) : SpriteViewAbstract<Dynamic, Dynamic> {
        if (sSprite != null) {
            var iElementCount = (settings.tileElement ? 1 : 0) + (settings.effectElement ? 1 : 0) + (settings.selectElement ? 1 : 0) + settings.shellElements;
            var view : Null<SpriteViewAbstract<Dynamic, Dynamic>> = null;

            if (settings.discarded != null) {
                view = settings.manager.simpleStart(settings.allocator, settings.views, settings.discarded);
                view.setRenderer(field._renderer);
            }

            if (view._element == null) {
                Logger.log("Creating new Sprite View", Logger.spriteView);
                field.elementsChanged();
                // Remove - view = new SpriteView();
                if (iElementCount == 1) {
                    if (settings.tileElement) {
                        view._element = view.getElement(FIELD_SPRITE_AND_TILE_STYLE);
                        view._tile = view._element;
                        view._originalStyle = FIELD_SPRITE_AND_TILE_STYLE;
                    } else if (settings.effectElement) {
                        view._element = view.getElement(FIELD_SPRITE_AND_EFFECT_STYLE);
                        view._effect = view._element;
                        view._originalStyle = FIELD_SPRITE_AND_EFFECT_STYLE;
                    } else if (settings.selectElement) {
                        view._element = view.getElement(FIELD_SPRITE_AND_SELECT_STYLE);
                        view._select = view._element;
                        view._originalStyle = FIELD_SPRITE_AND_SELECT_STYLE;
                    }
                    setSpriteView(view._element, view);
                } else {
                    view._element = view.getElement(FIELD_SPRITE_STYLE);
                    view._originalStyle = FIELD_SPRITE_STYLE;
                    var innerMostShell : Element = view._element;
                    setSpriteView(view._element, view);
                    var i : Int = 0;
                    var shell : NativeArray<Element> = null;
                    while (i < settings.shellElements) {
                        if (shell == null) {
                            shell = new NativeArray<Element>();
                        }
                        switch (i) {
                            case 0, 1:
                                innerMostShell = view.getElement(FIELD_SHELL_STYLE, innerMostShell);
                            case 2:
                                innerMostShell = view.createElement("span");
                                view.setStyle(innerMostShell, FIELD_SHELL_STYLE);
                                view.appendChild(shell.get(i - 1), innerMostShell);
                        }
                        shell.push(innerMostShell);
                        setSpriteView(innerMostShell, view);
                        i++;
                    }
                    if (shell != null) {
                        view._shell = shell.toVector();
                    }
                    if (settings.tileElement) {
                        view._tile = view.getElement(FIELD_TILE_STYLE, innerMostShell);
                        setSpriteView(view._tile, view);
                    }
                    if (settings.effectElement) {
                        view._effect = view.getElement(FIELD_EFFECT_STYLE, innerMostShell);
                        setSpriteView(view._effect, view);
                    }
                    if (settings.selectElement) {
                        view._select = view.getElement(FIELD_SELECT_STYLE, innerMostShell);
                        setSpriteView(view._select, view);
                    }
                }
                if (settings.draggable) {
                    // TODO
                    #if js
                        js.Syntax.code("{0}.onmousedown = {1}", view._element, view.onStartDrag);
                    #end
                }
                if (settings.resizable) {
                    // TODO
                    #if js
                        js.Syntax.code("{0}.style.resize = \"both\"", view._element);
                        js.Syntax.code("{0}.resizeObserver = {1}", view._element, view.getResize());
                        js.Syntax.code("{0}.resizeObserver.observe({0})", view._element);
                        js.Syntax.code("{0}.style.maxHeight = \"none\"", view._element);
                        js.Syntax.code("{0}.style.maxWidth = \"none\"", view._element);
                    #end
                }
                if (sSprite.hasValue()) {
                    // TODO
                    #if js                    
                        var ta : Element = js.Syntax.code("document.createElement(\"textarea\")");
                        js.Syntax.code("{0}.style = {1}", ta, "width: 100%; height: 100%; resize:none;background: none;");
                        js.Syntax.code("{0}.onchange = {1}", ta, view.onChangeValue);
                        js.Syntax.code("{0}.appendChild({1})", view._tile == null ? view._element : view._tile, ta);
                    #end
                }
                view._field = field;
                view._settings = settings;
                view.setTabIndex(view._element, 0);
                view.willChange(view._element);
                view.setOnClick(view._element, view);
                view.setOnTouchEnd(view._element, view);
                if (settings.setOnMouseOver) {
                    view.setOnMouseOver(view._element, view);
                }
            } else {
                Logger.log("Reusing Sprite View", Logger.spriteView);
            }

            view._sprite = sSprite;
            view._sprite.nowInUse();

            // TODO
            //_location.State(Field.LocationStateDisplayed);
            //_location.State().onUpdate(this);
            return view;
        } else {
            return null;
        }
    }

    private function onChangeValue(e : EventInfoInterface) : Void {

    }

    private function getResize() : Dynamic {
        #if JS_BROWSER
            var onResize : Dynamic = js.Syntax.code("{0}", this.onResize);
            return js.Syntax.code("new ResizeObserver((entries) => { for (var entry of entries) { if (entry.target == {0}) { if ({0}.skipResize) { {0}.skipResize = false; return; } if ({0}.resize != null) { clearTimeout({0}.resize); } {0}.resize = setTimeout(function () { {1}(entry.contentRect.width, entry.contentRect.height);}, 1); } } })", _element, onResize);
        #else
            return null;
        #end
    }

    private function onResize(width : Int, height : Int) : Void {
        //js.Syntax.code("{0}.style.resize = \"none\"", _element); 
        var tileWidth : Int = 0;
        var tileHeight : Int = 0;
        #if js
            if (js.Syntax.code("{0}.tileWidth", _settings) == null) {
                var l : LocationInterface<Dynamic, Dynamic> = _sprite.getField().get(0, 0);
                var l2 : LocationView = _field.findViewForLocation(l);
                var originX : Int = cast js.Syntax.code("{0}.getClientRects()[0].x", l2.toElement());
                var originY : Int = cast js.Syntax.code("{0}.getClientRects()[0].y", l2.toElement());
                l.doneWith();
                l = _sprite.getField().get(1, 0);
                l2 = _field.findViewForLocation(l);
                l.doneWith();
                l = null;
                tileWidth = cast js.Syntax.code("{0}.getClientRects()[0].x", l2.toElement()) - originX;
                l = _sprite.getField().get(0, 1);
                l2 = _field.findViewForLocation(l);
                l.doneWith();
                l = null;
                tileHeight = cast js.Syntax.code("{0}.getClientRects()[0].y", l2.toElement()) - originY;
                js.Syntax.code("{0}.tileWidth = {1}", _settings, tileWidth);
                js.Syntax.code("{0}.tileHeight = {1}", _settings, tileHeight);
            } else {
                tileWidth = cast js.Syntax.code("{0}.tileWidth", _settings);
                tileHeight = cast js.Syntax.code("{0}.tileHeight", _settings);
            }
        #end

        var l : LocationInterface<Dynamic, Dynamic> = _sprite.getField().get(Math.round(width / tileWidth) + _sprite.getX(null), Math.round(height / tileHeight) + _sprite.getY(null));
        var l2 : LocationView = _field.findViewForLocation(l);
        l.doneWith();
        l = null;
        #if js
            var r2 : Dynamic = js.Syntax.code("{0}.getClientRects()", l2.toElement());
            var r1 : Dynamic = js.Syntax.code("{0}.getClientRects()", _element);
            var width2 : String = (r2[0].x - r1[0].x) + "px";
            var height2 : String = (r2[0].y - r1[0].y) + "px";
            if (js.Syntax.code("Math.floor({0}.style.width.replace(\"px\", \"\")) != Math.floor({1}.replace(\"px\", \"\"))", _element, width2) || js.Syntax.code("Math.floor({0}.style.height.replace(\"px\", \"\")) != Math.floor({1}.replace(\"px\", \"\"))", _element, height2)) {
                js.Syntax.code("{0}.skipResize = true", _element);
                js.Syntax.code("{0}.style.width = {1}", _element, width2);
                js.Syntax.code("{0}.style.height = {1}", _element, height2);
            }
        #end
    }

    private function onStartDrag(e : EventInfoInterface) : Void {
        // TODO
        #if js
            js.Syntax.code("{0}.onmouseup = {1}", _element, onEndDrag);
            js.Syntax.code("{0}.onmousemove = {1}", _element, onContinueDrag);
        #end
    }

    private function onEndDrag(e : EventInfoInterface) : Void {
        // TODO
        #if js
            js.Syntax.code("{0}.onmouseup = null", _element);
            js.Syntax.code("{0}.onmousemove = null", _element);
        #end
    }    

    private function onContinueDrag(e : EventInfoInterface) : Void {
        // TODO
    }    

    /**
        Update the SpriteView with the latest data.
    **/
    public function update(sNew : SpriteInterface<Dynamic, Dynamic>) : Void {
        _sprite = sNew;

        if (_sprite != null) {
            if (_sprite.hasValue()) {
                var v : Dynamic = getSpriteValue(_sprite);
                var s : String;
                if (v == null) {
                    s = "";
                } else {
                    s = "" + v;
                }
                if (_settings.rawText) {
                    if (getRawContent(_tile) != s) {
                        _hasText = true;
                        now(function () {
                            setRawContent(_tile, s);
                        });
                    }
                } else {
                    if (getText(_tile) != s) {
                        _hasText = true;
                        now(function () {
                            setText(_tile, s);
                        });
                    }
                }
            } else if (_sprite.hasDataSource()) {
                var ext : SpriteExtendedInterface = cast _sprite;
                var o : Any = ext.dataSource();
                now(function () {
                    setDataSource(_tile, o);
                });
            } else if (_hasText) {
                _hasText = false;
                now(function () {
                    if (_settings.rawText) {
                        setRawContent(_tile, "");
                    } else {
                        setText(_tile, "");
                    }
                });
            }
    
            /*
            if (_sprite.changed()) {
                ChangeStyle();
            }
            */
        }
    }

    /**
        Check to see if the SpriteView has a value that can be edited or change whether it can be edited.
    **/
    public function editable(?bEditable : Null<Bool>) : Bool {
        if (bEditable != null)
        {
            return hasChildren(_tile);
        }
        else if (bEditable && !hasChildren(_tile))
        {
            var sText : String;

            setText(_tile, "");

            if (_sprite.hasActualValue())
            {
                var ext : SpriteExtendedInterface = cast _sprite;
                sText = ext.actualValue();
            }
            else if (_sprite.hasValue())
            {
                var ext : SpriteExtendedInterface = cast _sprite;
                sText = ext.value();
            }

            var iInput = createElement("input");
            setType(iInput, "text");
            
            appendChild(_tile, iInput);
            return true;
        }
        else if (!bEditable && hasChildren(_tile))
        {
            removeChildren(_tile);
            update(null);
            return false;
        } else {
            return false;
        }
    }

    /**
        Get the Sprite that the SpriteView represents.
        Note: Call doneWith on the Sprite when done.
    **/
    public function sprite() : SpriteInterface<Dynamic, Dynamic> {
        _sprite.nowInUse();
        return _sprite;
    }

    public function changed() : Bool {
        return _sprite.changed();
    }

    /**
        Clear and remove the SpriteView.
        This function is not meant to be used externally, only internally to the FieldEngine library.
    **/
    public function discard() : Void {
        //dDiv.remove();
        hideElement(_element);
        now(function () {
            setStyle(_element, FIELD_SPRITE_STYLE);
        });
        if (_sprite != null) {
            _sprite.doneWith();
            _sprite = null;
        }
        //clear();
        _settings.manager.doneWith(cast this, _settings.views, _settings.discarded);
        /*
                    dDiv.remove();
                    //if (!bNoHideShow) {
                        fmFieldsMode.hide(dDiv);
                    //}
                    domUpdate.now(function () {
                        dSprite.className = FIELD_SPRITE_STYLE;
                    });
                    */        
    }

    private static function setSpriteView(o : Element, s : SpriteViewAbstract<Dynamic, Dynamic>) : Void {
        #if js
            js.Syntax.code("{0}.spriteView = {1}", o, s);
        #else
            _elementToView.set(o, s);
        #end
    }

    public static function toSpriteView(o : Any) : SpriteViewAbstract<Dynamic, Dynamic> {
        #if js
            var view : SpriteViewAbstract<Dynamic, Dynamic> = null;
            js.Syntax.code("if ((!!{0}.sprite)) {1} = {0}; else {1} = {0}.spriteView", o, view);
            return view;
        #else
            return _elementToView.get(o);
        #end
    }

    private function generateSelectInfo(button : Int) : EventInfo<Dynamic, Dynamic, Dynamic> {
        return EventInfo.spriteEvent(_sprite, _element, getParent(getParent(getParent(_element))), Events.spriteSelect(), button);
    }

    public function onclick(e : EventInfoInterface) : Void {
        var view : SpriteViewAbstract<F, S>;
        #if js
            view = cast toSpriteView(cast this);
        #else
            view = cast this;
        #end        
        if (view._sprite != null) {
            Logger.dispatch(function () : EventInfo<Dynamic, Dynamic, Dynamic> { return view.generateSelectInfo(e.buttons());}, _sprite.field(), Logger.spriteView + Logger.locationSelect);
        }
    }

    public function onwheel(e : EventInfoInterface) : Void { }
    public function ondblclick(e : EventInfoInterface) : Void { }
    public function onmousedown(e : EventInfoInterface) : Void { }
    public function onmouseup(e : EventInfoInterface) : Void  { }
    public function ontouchstart(e : EventInfoInterface) : Void { }
    public function ontouchcancel(e : EventInfoInterface) : Void { }
    public function ontouchmove(e : EventInfoInterface) : Void { }

    public function ontouchend(e : EventInfoInterface) : Void {
        e.preventDefault();
        if (AbstractView.getSkipTouches() > 0) {
            AbstractView.skipTouchesDec();
        } else {
            if (e.buttons() > 0) {
                AbstractView.setSkipTouches(e.buttons());
            }
            onclick(e);
        }
    }

    private function generateHoverInfo() : EventInfo<Dynamic, Dynamic, Dynamic> {
        return EventInfo.spriteEvent(_sprite, _element, getParent(getParent(getParent(_element))), Events.spriteHover(), null);
    }

    public function onmouseover(e : EventInfoInterface) : Void {
        var view : SpriteViewAbstract<F, S>;
        #if js
            view = cast toSpriteView(cast this);
        #else
            view = cast this;
        #end        
        if (view._sprite != null) {
            Logger.dispatch(generateHoverInfo, view._sprite.field(), Logger.spriteView + Logger.locationHover);
        }
    }    

    /**
        The Style from when the SpriteView was first allocated.
    **/
    public function originalStyle() : Style {
        return _originalStyle;
    }    

    private var _inUse : Int = 0;

    public function nowInUse() : Int {
        return ++_inUse;
    }

    public function notInUse() : Int {
        if (_inUse <= 0) {
            return 0;
        } else {
            return --_inUse;
        }
    }

    public function useCount() : Int {
        return _inUse;
    }

    public function field() : Dynamic {
        return null;
    }

    public function init(newField : F, newX : Int, newY : Int) : S {
        return cast this;
    }
}
#end