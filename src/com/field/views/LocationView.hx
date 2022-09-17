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
    Displays a Location in an Element.
**/
class LocationView extends AbstractView implements com.field.renderers.MouseEventReceiver implements com.field.renderers.TouchEventReceiver implements com.field.Usable<Dynamic, LocationView> {
    public static var FIELD_LOCATION_STYLE : Style = cast "field_location";
    public static var FIELD_TILE_STYLE : Style = cast "field_tile";
    public static var FIELD_EFFECT_STYLE : Style = cast "field_effect";
    public static var FIELD_SELECT_STYLE : Style = cast "field_select";
    public static var FIELD_SHELL_STYLE : Style = cast "field_shell";
    private static var FIELD_LOCATION_AND_TILE_STYLE : Style = cast "field_location field_tile";
    private static var FIELD_LOCATION_AND_EFFECT_STYLE : Style = cast "field_location field_effect";
    private static var FIELD_LOCATION_AND_SELECT_STYLE : Style = cast "field_location field_select";

    private var _location : LocationInterface<Dynamic, Dynamic>;
    private var _tile : Element;
    private var _effect : Element;
    private var _select : Element;
    private var _originalStyle : Style;
    private var _shell : NativeVector<Element>;
    private var _hasText : Bool = false;

    #if js
        // Intentionally empty
    #else
        private static var _elementToView : NativeObjectMap<LocationView> = new NativeObjectMap<LocationView>();
    #end
    private var _settings : CommonSettings<LocationView>;

    // TODO - Package only
    public function new() {
        super();
    }

    /**
        Get the LocationView for a Location.
        This function is not meant to be used externally, only internally to the FieldEngine library.
    **/
    public static function get(lLocation : LocationInterface<Dynamic, Dynamic>, settings : CommonSettings<LocationView>, field : FieldViewAbstract, fixedElement : Element) : LocationView {
        if (lLocation != null) {
            var iElementCount = (settings.tileElement ? 1 : 0) + (settings.effectElement ? 1 : 0) + (settings.selectElement ? 1 : 0) + settings.shellElements;
            var view : Null<LocationView> = null;

            if (fixedElement != null) {
                #if js
                    view = toLocationView(fixedElement);
                    if (view == null) {
                        view = new LocationView();
                    }
                #else
                    // TODO
                #end
            } else if (settings.discarded != null) {
                view = settings.manager.simpleStart(settings.allocator, settings.views, settings.discarded);
            } else {
                view = new LocationView();
            }

            if (view._element == null) {
                Logger.log("Creating new Location View", Logger.locationView);
                field.elementsChanged();
                // Remove - view = new LocationView();
                if (iElementCount == 1) {
                    if (settings.tileElement) {
                        if (fixedElement == null) {
                            view._element = view.getElement(FIELD_LOCATION_AND_TILE_STYLE);
                        } else {
                            view._element = fixedElement;
                            view.setStyle(fixedElement, FIELD_LOCATION_AND_TILE_STYLE);
                        }
                        view._tile = view._element;
                        view._originalStyle = FIELD_LOCATION_AND_TILE_STYLE;
                    } else if (settings.effectElement) {
                        if (fixedElement == null) {
                            view._element = view.getElement(FIELD_LOCATION_AND_EFFECT_STYLE);
                        } else {
                            view._element = fixedElement;
                            view.setStyle(fixedElement, FIELD_LOCATION_AND_EFFECT_STYLE);
                        }
                        view._effect = view._element;
                        view._originalStyle = FIELD_LOCATION_AND_EFFECT_STYLE;
                    } else if (settings.selectElement) {
                        if (fixedElement == null) {
                            view._element = view.getElement(FIELD_LOCATION_AND_SELECT_STYLE);
                        } else {
                            view._element = fixedElement;
                            view.setStyle(fixedElement, FIELD_LOCATION_AND_SELECT_STYLE);
                        }
                        view._select = view._element;
                        view._originalStyle = FIELD_LOCATION_AND_SELECT_STYLE;
                    }
                    setLocationView(view._element, view);
                } else {
                    if (fixedElement == null) {
                        view._element = view.getElement(FIELD_LOCATION_STYLE);
                    } else {
                        view._element = fixedElement;
                        view.setStyle(fixedElement, FIELD_LOCATION_STYLE);
                    }
                    view._originalStyle = FIELD_LOCATION_STYLE;
                    var innerMostShell : Element = view._element;
                    setLocationView(view._element, view);
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
                        setLocationView(innerMostShell, view);
                        i++;
                    }
                    if (shell != null) {
                        view._shell = shell.toVector();
                    }

                    if (settings.tileElement) {
                        view._tile = view.getElement(FIELD_TILE_STYLE, innerMostShell);
                        setLocationView(view._tile, view);
                    }
                    if (settings.effectElement) {
                        view._effect = view.getElement(FIELD_EFFECT_STYLE, innerMostShell);
                        setLocationView(view._effect, view);
                    }
                    if (settings.selectElement) {
                        view._select = view.getElement(FIELD_SELECT_STYLE, innerMostShell);
                        setLocationView(view._select, view);
                    }
                }
                view._settings = settings;
                if (settings.tabIndex) {
                    view.setTabIndex(view._element, 0);
                }
                if (settings.willChange && fixedElement == null) {
                    view.willChange(view._element);
                }
                if (settings.click) {
                    view.setOnClick(view._element, view);
                    view.setOnTouchEnd(view._element, view);
                }
                if (settings.setOnMouseOver) {
                    view.setOnMouseOver(view._element, view);
                }
            } else {
                Logger.log("Reusing Location View", Logger.locationView);
            }

            view.update(lLocation);
            lLocation.nowInUse();

            // TODO
            //_location.State(Field.LocationStateDisplayed);
            //_location.State().onUpdate(this);

            return view;
        } else {
            return null;
        }
        /*
                        log("Reusing Location Element", log.locationView);
                dLocation = dDiv;
                if (iDivCount == 1) {
                    if (bTileDiv) {
                        dTile = dLocation;
                    }
                    if (bTileEffectDiv) {
                        dTileEffect = dLocation;
                    }
                    if (bSelectDiv) {
                        dSelect = dLocation;
                    }
                } else {
                    var i = 0;
                    if (bTileDiv) {
                        dTile = dDiv.childNodes[i++];
                    }
                    if (bTileEffectDiv) {
                        dTileEffect = dDiv.childNodes[i++];
                    }
                    if (bSelectDiv) {
                        dSelect = dDiv.childNodes[i++];
                    }
                }
                */
    }

    private static function setLocationView(o : Element, l : LocationView) : Void {
        #if js
            js.Syntax.code("{0}.locationView = {1}", o, l);
        #else
            _elementToView.set(o, l);
        #end
    }

    /**
        Get the LocationView for a given Element.
    **/
    public static function toLocationView(o : Element) : LocationView {
        #if js
            var view : LocationView = null;
            js.Syntax.code("if ((!!{0}.location)) {1} = {0}; else {1} = {0}.locationView", o, view);
            return view;
        #else
            return _elementToView.get(o);
        #end
    }

    /**
        Get the Location that the LocationView represents.
        Note: Call doneWith on the Location when done.
    **/
    public function location() : LocationInterface<Dynamic, Dynamic> {
        _location.nowInUse();
        return _location;
    }
    
    /**
        Update the LocationView with the latest data.
    **/
    public function update(lNew : Null<LocationInterface<Dynamic, Dynamic>>) : Void {
        if (lNew != null) {
            _location = lNew;
        }

        if (_location != null) {
            if (_location.hasValue()) {
                var v : Dynamic = getLocationValue(_location);
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
                    if (getTextContent(_tile) != s) {
                        _hasText = true;
                        now(function () {
                            setTextContent(_tile, s);
                        });
                    }
                }
            } else if (_location.hasDataSource()) {
                var ext : LocationExtendedInterface = cast _location;
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
                        setTextContent(_tile, "");
                    }
                });
            }
    
            /*
            if (_location.changed()) {
                ChangeStyle();
            }
            */
            
            if (_location.changed()) {
                var sArea = getStyleString(getStylePart(getStyle(_element), "area_x_"));
                now(function () {
                    setStyle(_element, combineStyles(combineStyles(getOriginalStyle(_element), getStyleFor(_location.attributes(_settings.calculatedAttributes))), getStyleFor(sArea)));
                });
            }
        }
    }

    /**
        Clear the LocationView.
    **/
    public function clear() : Void {
        _location = null;
        now(function () {
            if (hasChildren(_tile)) {
                removeChildren(_tile);
            }
            //setTextContent(_tile, "");
        });
    }

    /**
        Clear and remove the LocationView.
        This function is not meant to be used externally, only internally to the FieldEngine library.
    **/
    public function discard() : Void {
        //dDiv.remove();
        if (!(_settings.noHideShow)) {
            hideElement(_element);
        }
        /*
        domUpdate.now(function () {						
            dDiv.className = "field_location";
        });
        */
        if (_location != null) {
            _location.doneWith();
            _location = null;
        }
        clear();
        _settings.manager.doneWith(this, _settings.views, _settings.discarded);
    }

    /**
        Has the Location been changed.
    **/
    public function changed() : Bool {
        return _location.changed();
    }
    
    private function generateSelectInfo(button : Int) : EventInfo<Dynamic, Dynamic, Dynamic> {
        return EventInfo.locationEvent(_location, _element, getParent(getParent(getParent(_element))), Events.locationSelect(), button);
    }

    /**

    **/
    public function onclick(e : EventInfoInterface) : Void {
        var view : LocationView;
        #if js
            view = toLocationView(cast this);
        #else
            view = this;
        #end
        if (view._location != null) {
            Logger.dispatch(function () : EventInfo<Dynamic, Dynamic, Dynamic> { return view.generateSelectInfo(e.buttons());}, view._location.field(), Logger.locationView + Logger.locationSelect);
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
        return EventInfo.locationEvent(_location, _element, getParent(getParent(getParent(_element))), Events.locationHover(), null);
    }

    public function onmouseover(e : EventInfoInterface) : Void {
        var view : LocationView;
        #if js
            view = toLocationView(cast this);
        #else
            view = this;
        #end
        if (view._location != null) {
            Logger.dispatch(generateHoverInfo, view._location.field(), Logger.locationView + Logger.locationHover);
        }
    }

    /**
        Check to see if the LocationView has a value that can be edited or change whether it can be edited.
    **/
    public function editable(?bEditable : Null<Bool>) : Bool {
        if (bEditable != null)
        {
            return hasChildren(_tile);
        }
        else if (bEditable && !hasChildren(_tile))
        {
            var sText : String;

            setTextContent(_tile, "");

            if (_location.hasActualValue())
            {
                var ext : LocationExtendedInterface = cast _location;
                sText = ext.actualValue();
            }
            else if (_location.hasValue())
            {
                var ext : LocationExtendedInterface = cast _location;
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
        The Style from when the LocationView was first allocated.
    **/
    public function originalStyle() : Style {
        return _originalStyle;
    }

    private static var _allocator : LocationViewAllocator = new LocationViewAllocator();

    /**
        Used to create LocationViews.
        This function is not meant to be used externally, only internally to the FieldEngine library.   
    **/
    public static function getAllocator() : com.field.manager.AllocatorSprite<LocationView> {
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
    
    public function init(newField : Dynamic, newX : Int, newY : Int) : LocationView {
        return this;
    }
}

@:nativeGen
/**
    Used to create LocationViews.
    This function is not meant to be used externally, only internally to the FieldEngine library.   
**/
class LocationViewAllocator extends com.field.manager.AllocatorSprite<LocationView> {
    public function new() { }

    public override function allocate() : LocationView {
        return new LocationView();
    }
}
#end