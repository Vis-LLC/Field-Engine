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
class SpriteView extends AbstractView implements com.field.renderers.MouseEventReceiver implements com.field.renderers.TouchEventReceiver implements com.field.Usable<Dynamic, SpriteView> {
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
    private var _settings : CommonSettings<SpriteView>;
    private var _originalStyle : Style;
    private var _shell : NativeVector<Element>;

    #if js
        // Intentionally empty
    #else
        private static var _elementToView : NativeObjectMap<SpriteView> = new NativeObjectMap<SpriteView>();
    #end

    // TODO - Package only
    public function new() {
        super();
    }

    /**
        Get the SpriteView for a Location.
        This function is not meant to be used externally, only internally to the FieldEngine library.
    **/
    public static function get(sSprite : SpriteInterface<Dynamic, Dynamic>, settings : CommonSettings<SpriteView>, field : FieldViewAbstract) : SpriteView {
        if (sSprite != null) {
            var iElementCount = (settings.tileElement ? 1 : 0) + (settings.effectElement ? 1 : 0) + (settings.selectElement ? 1 : 0) + settings.shellElements;
            var view : Null<SpriteView> = null;

            if (settings.discarded != null) {
                view = settings.manager.simpleStart(settings.allocator, settings.views, settings.discarded);
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
                view._settings = settings;
            } else {
                Logger.log("Reusing Sprite View", Logger.spriteView);
            }

            view._sprite = sSprite;
            view._sprite.nowInUse();

            view.setTabIndex(view._element, 0);
            view.willChange(view._element);
            view.setOnClick(view._element, view);
            view.setOnTouchEnd(view._element, view);

            if (settings.setOnMouseOver) {
                view.setOnMouseOver(view._element, view);
            }

            // TODO
            //_location.State(Field.LocationStateDisplayed);
            //_location.State().onUpdate(this);
            return view;
        } else {
            return null;
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
        Update the SpriteView with the latest data.
    **/
    public function update(sNew : SpriteInterface<Dynamic, Dynamic>) : Void {
        _sprite = sNew;
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
        _settings.manager.doneWith(this, _settings.views, _settings.discarded);
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

    private static function setSpriteView(o : Element, s : SpriteView) : Void {
        #if js
            js.Syntax.code("{0}.spriteView = {1}", o, s);
        #else
            _elementToView.set(o, s);
        #end
    }

    public static function toSpriteView(o : Any) : SpriteView {
        #if js
            var view : SpriteView = null;
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
        var view : SpriteView;
        #if js
            view = toSpriteView(cast this);
        #else
            view = this;
        #end        
        if (view._sprite != null) {
            Logger.dispatch(function () : EventInfo<Dynamic, Dynamic, Dynamic> { return view.generateSelectInfo(e.buttons());}, _sprite.field(), Logger.spriteView + Logger.locationSelect);
        }
    }

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
        var view : SpriteView;
        #if js
            view = toSpriteView(cast this);
        #else
            view = this;
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

    private static var _allocator : SpriteViewAllocator = new SpriteViewAllocator();

    /**
        Used to create SpriteViews.
        This function is not meant to be used externally, only internally to the FieldEngine library.   
    **/
    public static function getAllocator() : com.field.manager.AllocatorSprite<SpriteView> {
        return _allocator;
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

    public function init(newField : Dynamic, newX : Int, newY : Int) : SpriteView {
        return this;
    }
}

@:nativeGen
/**
    Used to create SpriteViews.
    This function is not meant to be used externally, only internally to the FieldEngine library.   
**/
class SpriteViewAllocator extends com.field.manager.AllocatorSprite<SpriteView> {
    public function new() { }

    public override function allocate() : SpriteView {
        return new SpriteView();
    }
}