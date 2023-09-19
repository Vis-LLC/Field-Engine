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
import com.field.navigator.DirectionInterface;
import com.field.navigator.NavigatorCoreInterface;
import com.field.navigator.NavigatorInterface;
import com.field.navigator.NavigatorStandard;
import com.field.renderers.Element;
import com.field.renderers.LeftStyle;
import com.field.renderers.TopStyle;
import com.field.renderers.Style;

// TODO - Put dInnerDiv.style.zIndex = 0; in style
// TODO - Put dInnerDiv2.style.zIndex = -1; in style
// TODO - Put dInnerDiv3.style.zIndex = -2; in style

@:expose
@:nativeGen
/**
    Base class for FieldView.
**/
class FieldViewAbstract extends AbstractView implements FieldViewInterface implements MirrorableInterface {
    public static var FIELD_VIEW_STYLE : Style = cast "field_view";
    public static var FIELD_VIEW_HEX : Style = cast "hex_grid";
    public static var TRANSITIONS_ENABLED_STYLE : Style = cast "transitions_enabled";
    public static var FIELD_VIEW_INNER_STYLE : Style = cast "field_view_inner";
    public static var FIELD_VIEW_INNER_STYLE2 : Style = cast "field_view_inner background";
    public static var FIELD_VIEW_INNER_STYLE3 : Style = cast "field_view_inner background2";
    public static var FULLSCREEN : Style = cast "field_view_fullscreen";
    public static var FIELD_VIEW_FRAME : Style = cast "field_view_frame";
    public static var FIELD_VIEW_FRAME_TOP : Style = cast "field_view_frame_top";
    public static var FIELD_VIEW_FRAME_BOTTOM : Style = cast "field_view_frame_bottom";
    public static var FIELD_VIEW_FRAME_LEFT : Style = cast "field_view_frame_left";
    public static var FIELD_VIEW_FRAME_RIGHT : Style = cast "field_view_frame_right";
    public static var FIELD_VIEW_FRAME_LT : Style = cast "field_view_frame_lt";
    public static var FIELD_VIEW_FRAME_RT : Style = cast "field_view_frame_rt";
    public static var FIELD_VIEW_FRAME_LB : Style = cast "field_view_frame_lb";
    public static var FIELD_VIEW_FRAME_RB : Style = cast "field_view_frame_rb";
    public static var FIELD_VIEW_OVERLAY : Style = cast "field_view_overlay";

    public static var FIELD_VIEW_ISOMETRIC_STRAIGHT : Style = cast "isometric_straight";
    public static var FIELD_VIEW_ISOMETRIC_DEEP : Style = cast "isometric_deep";
    public static var FIELD_VIEW_ISOMETRIC_CLOCK : Style = cast "isometric_clock";
    public static var FIELD_VIEW_ISOMETRIC_COUNTER : Style = cast "isometric_counter";

    /* TODO - 
            this.style.position = "absolute";
        this.style.minWidth = "100%";
        this.style.minHeight = "100%";
        this.style.maxWidth = "100%";
        this.style.maxHeight = "100%";
        this.style.width = "100%";
        this.style.height = "100%";
    */

    private static var _fieldViewCount : Int = 0;


    private var _field : FieldInterface<Dynamic, Dynamic>;
    private var _style : Style;
    private var _addOverlay : Bool;
    private var _specifiedTileWidth : Float;
    private var _specifiedTileHeight : Float;
    private var _tileWidth : Float;
    private var _tileHeight : Float;
    private var _tileBuffer : Float;
    private var _id : String;
    private var _scrollOnMove : Null<Bool>;
    private var _selectOnMove : Null<Bool>;
    private var _selectOnTouch : Null<Bool>;
    private var _gamepadOnTouch : Null<Bool>;
    private var _gamepadOnMouse : Null<Bool>;
    private var _clearOnHide : Bool;
    private var _transitionsEnabled : Bool = true; /// TODO
    private var _locationSettings : CommonSettings<LocationView> = new CommonSettings<LocationView>();
    private var _spriteSettings : CommonSettings<SpriteView> = new CommonSettings<SpriteView>();
    private var _uiUpdates : NativeArray<Void -> Void> = new NativeArray<Void -> Void>();
    private var _autoUpdate : Null<Bool>;

    private var _innerElement : Element;
    private var _innerElement2 : Element;
    private var _innerElement3 : Element;
    private var _overlay : Element;

    private var _locationToViews : NativeIntMap<LocationView>;
    private var _mainSprite : Null<SpriteInterface<Dynamic, Dynamic>> = null;
    private var _spriteMoverActual : DirectionInterface->Int->Bool;
    private var _spriteMoverNull : DirectionInterface->Int->Bool;
    private var _moveSprite : DirectionInterface->Int->Bool;

    private var _ox : Null<Float>;
    private var _oy : Null<Float>;
    private var _lastUpdateX : Null<Float> = null;
    private var _lastUpdateY : Null<Float> = null;
    private var _rectHeight : Float;
    private var _rectWidth : Float;
    private var _lockSquareOrientation : Bool;
    private var _lockViewSize : Bool;

    private var _inputSettings : Null<InputSettings>;
    private var _frame : Element;
    private var _frameLeft : Element;
    private var _frameRight : Element;
    private var _frameTop : Element;
    private var _frameBottom : Element;
    private var _frameLT : Element;
    private var _frameRT : Element;
    private var _frameLB : Element;
    private var _frameRB : Element;
    private var _gridType : Int;

    private var _fieldSheet : Element = null;
    private var _spriteToViews : NativeIntMap<SpriteView> = new NativeIntMap<SpriteView>();
    private var _spritesAdded : NativeArray<SpriteInterface<Dynamic, Dynamic>> = new NativeArray<SpriteInterface<Dynamic, Dynamic>>();
    private var _onmove : Null<DirectionInterface->Int->FieldInterface<Dynamic, Dynamic>->FieldInterface<Dynamic, Dynamic>->FieldInterface<Dynamic, Dynamic>->Void>;

    private var _cachedOffsetHeight : Null<Float>;
    private var _cachedOffsetWidth : Null<Float>;
    private var _hasSprites : Bool;
    private var _isometric : Null<Int>;

    private var _lastFieldHeight : Int = -1;
    private var _lastFieldWidth : Int = -1;

    private var _lastMajorChange : Dynamic = null;
    private var _onEndOfUpdate : Void->Void = null;

    private var _canMove : DirectionInterface->Int->FieldViewAbstract->Bool;
    private var _spriteStubValid : FieldViewAbstractSpriteStubValid;
    private var _onScroll : Null<FieldViewAbstract -> Float -> Float -> Void>;
    private var _childrenAsVector : NativeVector<Element> = null;
    private var _noAddLocation : Bool = false;
    private var _skipScroll : Bool = false;
    private var _shiftYLimit : Null<Int> = null;
    private var _shiftXLimit : Null<Int> = null;
    private var _noBackground : Bool = false;
    private var _noExtraFrame : Bool = false;
    private var _fixedGrid : Bool;
    private var _fixedGridElements : NativeVector<NativeVector<Element>>;
    private var _scrollOnWheel : Bool;
    private var _mirrors : NativeArray<MirrorViewInterface> = null;

    public function attachMirror(mirror : MirrorViewInterface) : Void {
        if (_mirrors == null) {
            _mirrors = new NativeArray<MirrorViewInterface>();
        }
        _mirrors.push(mirror);
    }

    private function loadFieldSheet() : Element {
        #if js
            return createElement("style");
        #end
        return null;
    }

    private static function withDefault(v : Any, d : Any) : Any {
        if (v == null) {
            return d;
        } else {
            return v;
        }
    }

    private function new(fo : NativeStringMap<Any>) {
        super();

        _spriteStubValid = new FieldViewAbstractSpriteStubValid(this);

        var show : Bool;
        var parentElement : Element;
        {
            // TODO - Use or remove reuseElements
            var reuseElements : Null<Bool> = cast fo.get("");
            if (reuseElements || reuseElements == null) {
                //discardedElements = new NativeArray<Element>();
            }

            if (fo.get("renderer") != null) {
                setRenderer(cast fo.get("renderer"));
            }

            show = cast fo.get("show");
            parentElement = fo.get("parent");

            _canMove = cast withDefault(fo.get("canMove"), movementForAny);
            _onEndOfUpdate = cast withDefault(fo.get("onEndOfUpdate"), function () { });
            _id = cast fo.get("id");
            _field = cast fo.get("field");
            _tileWidth = cast fo.get("tileWidth");
            _tileHeight = cast fo.get("tileHeight");
            _specifiedTileWidth = _tileWidth;
            _specifiedTileHeight = _tileHeight;
            _tileBuffer = cast fo.get("tileBuffer");
            if (_field == null) {
                _field = FieldStandard.create(
                    FieldStandard.options()
                    .width(Math.floor(_tileWidth + _tileBuffer * 2))
                    .height(Math.floor(_tileHeight + _tileBuffer * 2))
                );
            }
            _gridType = cast withDefault(fo.get("gridType"), 1);
            switch (_gridType) {
                case 3:
                    //_tileHeight *= 2;
                    //_tileWidth /= 2/3;
                    _tileWidth *= 1.5;
                    _tileBuffer *= 2;
            }
            {
                var s : FieldSystemInterface<Dynamic, Dynamic> = cast _field;
                _hasSprites = s.getMaximumNumberOfSprites() > 0;
            }
            _lockSquareOrientation = cast withDefault(fo.get("lockSquareOrientation"), true);
            _lockViewSize = true; cast withDefault(fo.get("lockViewSize"), true);

            _gamepadOnMouse = cast fo.get("gamepadOnMouse");
            _gamepadOnTouch = cast fo.get("gamepadOnTouch");
            _scrollOnMove = cast fo.get("scrollOnMove");
            _selectOnMove = cast fo.get("selectOnMove");
            _selectOnTouch = cast fo.get("selectOnTouch");
            _autoUpdate = cast fo.get("autoUpdate");
            _style = cast fo.get("style");
            _addOverlay = cast fo.get("addOverlay");
            _clearOnHide = cast fo.get("clearOnHide");
            _shiftXLimit = cast fo.get("shiftXLimit");
            _shiftYLimit = cast fo.get("shiftYLimit");
            _noBackground = cast withDefault(fo.get("noBackground"), false);
            _noExtraFrame = cast withDefault(fo.get("noExtraFrame"), false);
            _fixedGrid = cast withDefault(fo.get("fixedGrid"), false);

            _locationSettings.noHideShow = cast withDefault(fo.get("locationNoHideShow"), false);
            var reuseLocationViews : Null<Bool> = cast fo.get("reuseLocationViews");
            if (reuseLocationViews || reuseLocationViews == null) {
                _locationSettings.manager = new com.field.manager.TransientReuse<LocationView, Dynamic, Dynamic, Dynamic>();
            }
            _locationSettings.allocator = LocationView.getAllocator();
            _locationSettings.views = _locationSettings.manager.preallocate(_locationSettings.allocator, null, _field.width(), _field.height());
            _locationSettings.discarded = _locationSettings.manager.allocateDiscard(_locationSettings.allocator);

            _locationSettings.effectElement = cast withDefault(fo.get("locationEffectElement"), true);
            _locationSettings.selectElement = cast withDefault(fo.get("locationSelectElement"), true);
            _locationSettings.tileElement = cast withDefault(fo.get("locationTileElement"), true);
            _locationSettings.tileStyle = fo.get("tileStyle");
            _locationSettings.effectStyle = fo.get("effectStyle");
            _locationSettings.selectStyle = fo.get("selectStyle");
            _locationSettings.style = fo.get("locationStyle");
            _locationSettings.triggerFocusOnElement = cast fo.get("triggerFocusOnElement");
            _locationSettings.noAreaXY = cast fo.get("noAreaXY");
            _locationSettings.setOnMouseOver = cast fo.get("locationSetOnMouseOver");
            _locationSettings.click = cast withDefault(fo.get("click"), true);
            _locationSettings.tabIndex = cast withDefault(fo.get("tabIndex"), true);
            _locationSettings.calculatedAttributes = cast withDefault(fo.get("calculatedAttributes"), true);
            _locationSettings.willChange = cast withDefault(fo.get("willChange"), true);
            _locationSettings.rawText = cast withDefault(fo.get("locationRawText"), false);
            if (_gridType == 3) {
                //_locationSettings.shellElements = 3;
                _locationSettings.shellElements = 0;
            } else {
                _locationSettings.shellElements = 0;
            }

            _spriteSettings.noHideShow = cast withDefault(fo.get("spriteNoHideShow"), false);
            var reuseSpriteViews : Null<Bool> = cast fo.get("reuseSpriteViews");

            if (reuseSpriteViews || reuseSpriteViews == null) {
                _spriteSettings.manager = new com.field.manager.TransientReuse<SpriteView, Dynamic, Dynamic, Dynamic>();
            }
            _spriteSettings.allocator = SpriteView.getAllocator();
            var fs : FieldSystemInterface<Dynamic, Dynamic> = cast _field;
            _spriteSettings.views = _spriteSettings.manager.preallocate(_spriteSettings.allocator, null, fs.getMaximumNumberOfSprites() , 1);
            _spriteSettings.discarded = _spriteSettings.manager.allocateDiscard(_spriteSettings.allocator);

            _spriteSettings.effectElement = cast withDefault(fo.get("spriteEffectElement"), true);
            _spriteSettings.selectElement = cast withDefault(fo.get("spriteSelectElement"), true);
            _spriteSettings.tileElement = cast withDefault(fo.get("spriteTileElement"), true);
            _spriteSettings.tileStyle = fo.get("tileStyle");
            _spriteSettings.effectStyle = fo.get("effectStyle");
            _spriteSettings.selectStyle = fo.get("selectStyle");
            _spriteSettings.style = fo.get("spriteStyle");
            _spriteSettings.triggerFocusOnElement = cast fo.get("triggerFocusOnElement");
            _spriteSettings.noAreaXY = cast fo.get("noAreaXY");
            _spriteSettings.setOnMouseOver = cast fo.get("spriteSetOnMouseOver");
            _spriteSettings.draggable = cast withDefault(fo.get("spritesDraggable"), false);
            _spriteSettings.resizable = cast withDefault(fo.get("spritesResizable"), false);

            if (_gridType == 3) {
                //_spriteSettings.shellElements = 3;
                _spriteSettings.shellElements = 0;
            } else {
                _spriteSettings.shellElements = 0;
            }

            _onmove = cast fo.get("onMove");
            _isometric = cast fo.get("isometric");
            _onScroll = cast fo.get("onScroll");
            _scrollOnWheel = cast withDefault(fo.get("scrollOnWheel"), false);
            fo = null;
        }

        if (_gamepadOnTouch == null) {
            _gamepadOnTouch = false;
        }

        if (_gamepadOnMouse == null) {
            _gamepadOnMouse = false;
        }			
        
        if (_selectOnMove == null) {
            _selectOnMove = false;
        }

        if (_autoUpdate == null) {
            _autoUpdate = true;
        }

        if (_locationSettings.triggerFocusOnElement == null) {
            _locationSettings.triggerFocusOnElement = false;
        }

        if (_spriteSettings.triggerFocusOnElement == null) {
            _spriteSettings.triggerFocusOnElement = false;
        }

        if (_scrollOnMove == null) {
            _scrollOnMove = true;
        }

        if (_autoUpdate == false) {
            _uiUpdates = new NativeArray<Void -> Void>();
        }

        _fieldViewCount++;
        if (_id == null) {
            _id = "FieldView" + _fieldViewCount;
        }

        _frame = createElement();
        setStyle(_frame, FIELD_VIEW_FRAME);
        
        if (!_noExtraFrame) {
            _frameLeft = createElement();
            setStyle(_frameLeft, FIELD_VIEW_FRAME_LEFT);
            _frameRight = createElement();
            setStyle(_frameRight, FIELD_VIEW_FRAME_RIGHT);
            _frameTop = createElement();
            setStyle(_frameTop, FIELD_VIEW_FRAME_TOP);
            _frameBottom = createElement();
            setStyle(_frameBottom, FIELD_VIEW_FRAME_BOTTOM);
            _frameLT = createElement();
            setStyle(_frameLT, FIELD_VIEW_FRAME_LT);
            _frameRT = createElement();
            setStyle(_frameRT, FIELD_VIEW_FRAME_RT);
            _frameLB = createElement();
            setStyle(_frameLB, FIELD_VIEW_FRAME_LB);
            _frameRB = createElement();
            setStyle(_frameRB, FIELD_VIEW_FRAME_RB);
        }
        if (!renderer().fixedSizing()) {
            setTimeout(resizeFrame, 1);
        }

        if (_addOverlay) {
            _overlay = createElement();
            setStyle(_overlay, FIELD_VIEW_OVERLAY);
        }

        _spriteMoverActual = function (direction : DirectionInterface, distance : Int) : Bool { return _mainSprite.navigator().navigate(direction.oppositeAny(), distance); };
        _spriteMoverNull = function (direction : DirectionInterface, distance : Int) : Bool { return true; };
        _moveSprite = _spriteMoverNull;
        _element = getElement();
        setTabIndex(_element, 0);

        // TODO - Move
        #if js
            js.Syntax.code("{0}.id = {1}", _element, _id);
        #else
        #end

        addStyle(_element, FIELD_VIEW_STYLE);
        switch (_gridType) {
            case 3:
                addStyle(_element, FIELD_VIEW_HEX);
        }
        switch (_isometric) {
            case 1:
                addStyle(_element, FIELD_VIEW_ISOMETRIC_STRAIGHT);
            case 2:
                addStyle(_element, FIELD_VIEW_ISOMETRIC_DEEP);
            case 3:
                addStyle(_element, FIELD_VIEW_ISOMETRIC_CLOCK);
            case 4:
                addStyle(_element, FIELD_VIEW_ISOMETRIC_COUNTER);
        }
        if (_transitionsEnabled) {
            addStyle(_element, TRANSITIONS_ENABLED_STYLE);
        }
        if (_style != null) {
            addStyle(_element, _style);
        }
        if (parentElement != null) {
            appendChild(parentElement, _element);
        }
        if (show) {
            showElement(_element);
        }

        fullRefresh();
    }

    public function getOverlay() : Element {
        return _overlay;
    }

    public function width() : Float {
        return _tileWidth;
    }

    public function height() : Float {
        return _tileHeight;
    }

    private static function isElementALocation(e : Element) : Bool {
        return LocationView.toLocationView(e) != null;
    }

    private static function isElementASprite(e : Element) : Bool {
        return SpriteView.toSpriteView(e) != null;
    }    

    public function clear() : Void {
        while (_uiUpdates.length() > 0) {
            _uiUpdates.pop()();
        }

        if (_childrenAsVector == null) {
            _childrenAsVector = getChildrenAsVector(_innerElement);
        }
        var children : NativeArray<Element> = _childrenAsVector.toArray();
        var i : Int = 0;
        while (children.length() > 0) {
            var e : Element = children.pop();
            if (isElementALocation(e)) {
                var l : Null<LocationView> = LocationView.toLocationView(e);
                if (l != null && l.useCount() > 0) {
                    var l2 : Null<LocationInterface<Dynamic, Dynamic>> = l.location();
                    if (l2 != null) {
                        _locationToViews.remove(l2.getI());
                        l2.doneWith();
                    }
                    l.discard();
                }
            } else if (isElementASprite(e)) {
                var s : Null<SpriteView> = SpriteView.toSpriteView(e);
                if (s != null && s.useCount() > 0) {
                    var s2 : Null<SpriteInterface<Dynamic, Dynamic>> = s.sprite();
                    if (s2 != null) {
                        _spriteToViews.remove(s2.getI());
                        s2.doneWith();
                    }
                    s.discard();
                }
            }
        }
    }

    public function fullRefresh() : Void {
        if (renderer().fixedSizing()) {
            resizeFrame();
            forceWidth(_element, "" + getActualPixelWidth(_frame));
            forceHeight(_element, "" + getActualPixelHeight(_frame));
        }
        if (_field.isDynamic()) {
            var s : FieldSystemInterface<Dynamic, Dynamic> = cast _field;
            _hasSprites = s.getMaximumNumberOfSprites() > 0;
        }
        
        _lastFieldHeight = _field.height();
        _lastFieldWidth = _field.width();
        _lastMajorChange = _field.lastMajorChange();
        _spritesAdded = new NativeArray<SpriteInterface<Dynamic, Dynamic>>();
        _locationToViews = new NativeIntMap<LocationView>();

        start();

        while (_uiUpdates.length() > 0) {
            _uiUpdates.pop()();
        }

/* TODO
            var dTileBuffer = g("tile-buffer");
            var dTileHeight = g("tile-height");
            var dTileWidth = g("tile-width");
            */
        var ox : Float = originX() - _tileBuffer;
        var oy : Float = originY() - _tileBuffer;
        {
            if (_cachedOffsetHeight == null) {
                var parentElement = getParent(_element);
                if (parentElement == null) {
                    parentElement = renderer().defaultParent();
                }
                _cachedOffsetHeight = getOffsetHeight(parentElement);
                _cachedOffsetWidth = getOffsetWidth(parentElement);
            }
            var squareHeight : Float = _cachedOffsetHeight / _tileHeight;
            var squareWidth : Float = _cachedOffsetWidth / _tileWidth;
/*
            switch (_gridType) {
                case 3:
                    //squareHeight *= 2;
                    //squareWidth /= 2/3;
                    squareHeight *= 2/3;
                    squareWidth *= 2/3;
            }
            */

            if (_lockSquareOrientation) {
                var squareSize = squareHeight < squareWidth ? squareHeight : squareWidth;
                _rectHeight = squareSize;
                _rectWidth = squareSize;
            } else {
                _rectHeight = squareHeight;
                _rectWidth = squareWidth;
            }
        }

        if (_innerElement != null) {
            if (renderer().fixedSizing()) {
                forceWidth(_innerElement, "" + Math.floor(getActualPixelWidth(_element) * _field.width() / _tileWidth));
                forceHeight(_innerElement, "" + Math.floor(getActualPixelHeight(_element) * _field.height() / _tileHeight));
                renderer().initBufferForInner(_innerElement);
            }
            clear();
        } else {
            _innerElement = getElement();
            if (renderer().fixedSizing()) {
                forceWidth(_innerElement, "" + Math.floor(getActualPixelWidth(_element) * _field.width() / _tileWidth));
                forceHeight(_innerElement, "" + Math.floor(getActualPixelHeight(_element) * _field.height() / _tileHeight));
            }
            willChange(_innerElement);
            if (!_noBackground) {
                _innerElement2 = getElement();
                _innerElement3 = getElement();
            }

            #if js
                if (_fieldSheet == null) {
                    _fieldSheet = loadFieldSheet();
                }
                appendChild(_element, _fieldSheet);
            #end
            appendChild(_element, _frame);

            if (!_noExtraFrame) {            
                appendChild(_element, _frameLeft);
                appendChild(_element, _frameRight);
                appendChild(_element, _frameTop);
                appendChild(_element, _frameBottom);
                appendChild(_element, _frameLT);
                appendChild(_element, _frameRT);
                appendChild(_element, _frameLB);
                appendChild(_element, _frameRB);
            }

            if (_overlay != null) {
                appendChild(_element, _overlay);                
            }

            appendChild(_frame, _innerElement);
            renderer().initBufferForInner(_innerElement);

            if (!_noBackground) {            
                appendChild(_frame, _innerElement2);
                appendChild(_frame, _innerElement3);
            }
            setStyle(_innerElement, FIELD_VIEW_INNER_STYLE);

            if (!_noBackground) {            
                now(function () {
                    setStyle(_innerElement2, FIELD_VIEW_INNER_STYLE2);
                    setStyle(_innerElement3, FIELD_VIEW_INNER_STYLE3);
                });
            }

            if (_fixedGrid) {
                _fixedGridElements = createStaticRectGrid(_innerElement, cast _tileHeight, cast _tileWidth);
                if (_locationSettings.click || _locationSettings.setOnMouseOver) {
                    var j : Int = 0;
                    var i : Int = 0;
                    var k : Int = 0;
                    for (row in _fixedGridElements) {
                        i = 0;
                        for (l in row) {
                            var view : LocationView = LocationView.get(_field.get(i, j), _locationSettings, this, l);
                            _locationToViews.set(k, view);
                            i++;
                        }
                        j++;
                        k++;
                    }
                }
                var children : NativeArray<Element> = getChildrenAsVector(_frame).toArray();
                var i : Int = 0;
                while (children.length() > 0) {
                    var e : Element = children.pop();
                    if (isElementASprite(e)) {
                        var s : Null<SpriteView> = SpriteView.toSpriteView(e);
                        if (s != null && s.useCount() > 0) {
                            var s2 : Null<SpriteInterface<Dynamic, Dynamic>> = s.sprite();
                            if (s2 != null) {
                                _spriteToViews.remove(s2.getI());
                                s2.doneWith();
                            }
                            s.discard();
                        }
                    }
                }                
            }
        }


        // TODO - Remove or Optional?
        if (!_skipScroll) {
            var scrollX : Float = originX();
            var scrollY : Float = originY();
            var oddRow : Bool = Math.abs(Math.floor(oy) % 2) == 1;
            switch (_gridType) {
                case 3:
                    scrollX *= 1.5;
                    if (oddRow)
                    {
                        scrollX += 0.75;
                    }
                    scrollY *= 0.5;
            }

            scrollX -= getFieldX(_innerElement, _rectWidth, _tileWidth);
            scrollY -= getFieldY(_innerElement, _rectHeight, _tileHeight);
/*
            switch (_gridType) {
                case 3:
                    scrollX -= 1.75;
                    scrollY -= 1.5;
            }
*/
            scroll(_innerElement, scrollX, scrollY, _rectWidth, _rectHeight, _tileWidth, _tileHeight, null, null);
        }

        var fullHeight : Int = Math.floor(_tileHeight + _tileBuffer * 2);
        // TODO - *2?
        var fullWidth : Int = Math.floor(_tileWidth + _tileBuffer);
        var leftCache : NativeVector<LeftStyle>;
        if (!_fixedGrid) {
            leftCache = new NativeVector<LeftStyle>(fullWidth);
        } else {
            leftCache = null;
        }

        var j : Int = 0;
        var oddRow : Bool = Math.abs(Math.floor(j + oy) % 2) == 1;
        var fragment : Dynamic = null;

        while (j < fullHeight) {
            var j2o : Int = Math.floor(j + oy);
            var j2 : Float = j2o;
            switch (_gridType) {
                case 3:
                    j2 /= 2;
            }
            var top : TopStyle;
            if (!_fixedGrid) {
                top = this.top(j2, _rectHeight, _tileBuffer, _tileHeight);
            } else {
                top = null;
            }
            var i : Int = 0;

            while (i < fullWidth) {
                var i2o : Int = Math.floor(i + ox);
                var i2 : Float = i2o;
                switch (_gridType) {
                    case 3:
                        i2 *= 1.5;
                        if (oddRow) {
                            i2 += 0.75;
                        }                        
                }
                var left : LeftStyle = null;
                if (!_fixedGrid) {
                    switch (_gridType) {
                        case 3:
                        default:
                            left = leftCache.get(i2o);
                    }
                    if (left == null) {
                        // TODO - Move into renderer
                        left = this.left(i2, _rectWidth, _tileBuffer, _tileWidth);
                        switch (_gridType) {
                            case 3:
                            default:
                                leftCache.set(i2o, left);
                        }
                    }
                } else {
                    left = null;
                }

                var location : LocationInterface<Dynamic, Dynamic> = cast _field.get(i2o, j2o);
                if (location != null) {
                    //var newSprites : NativeVector<SpriteInterface<Dynamic, Dynamic>> = cast _field.findSpritesForLocation(location);
                    var lvLocation : LocationView;
                    if (!_fixedGrid) {
                        lvLocation = LocationView.get(location, _locationSettings, this, null);
                    } else {
                        lvLocation = LocationView.get(location, _locationSettings, this, _fixedGridElements.get(j).get(i));
                    }
                    var eLocation : Element = lvLocation.toElement();
    
                    if (eLocation != null) {
                        if (!(_locationSettings.noHideShow)) {
                            hideElement(eLocation, null, com.field.renderers.Immediate._instance);
                        }
                        
                        if (getParent(eLocation) == null) {
                            if (fragment == null) {
                                if (_fixedGrid) {
                                    fragment = createFragment(_frame);
                                } else {
                                    fragment = createFragment(_innerElement);
                                }
                            }
                            appendChild(fragment, eLocation);
                        }
    
                        var pos : Coordinate = _field.getLoop(i2o, j2o);
                        var attr : Style = getStyleFor(location.attributes(_locationSettings.calculatedAttributes));
                        now(function () {
                            var area : Style;
                            if (_locationSettings.noAreaXY) {
                                area = null;
                            } else {
                                area = combineStyles(getStyleFor("area_x_" + pos.x), getStyleFor("area_y_" + pos.y));
                            }
                            setStyle(eLocation, combineStyles(lvLocation.originalStyle(), combineStyles(attr, area)));
                        });
    
                        if (!(_locationSettings.noHideShow)) {
                            showElement(eLocation);
                        }
                    }
    
                    if (!_fixedGrid) {
                        if (_shiftXLimit != null || _shiftYLimit != null) {
                            var shiftX : Null<Int> = location.attribute("shiftX");
                            var shiftY : Null<Int> = location.attribute("shiftY");
                            if (shiftX == null) {
                                shiftX = 0;
                            }
                            if (shiftY == null) {
                                shiftY = 0;
                            }
                            if (shiftX != 0 || shiftY != 0) {
                                if (_transitionsEnabled) {
                                    if (hasStyle(getStyle(_element), TRANSITIONS_ENABLED_STYLE)) {
                                        removeStyle(_element, TRANSITIONS_ENABLED_STYLE);
                                    }
                                }
                                moveTo(eLocation, i2 - shiftX, j2 - shiftY, _rectWidth, _rectHeight, _tileBuffer, _tileWidth, _tileHeight, shiftX == 0 ? left : null, shiftY == 0 ? top : null,/* function() {
                                    if (_transitionsEnabled) {
                                        if (!hasStyle(getStyle(_element), TRANSITIONS_ENABLED_STYLE)) {
                                            addStyle(_element, TRANSITIONS_ENABLED_STYLE);
                                        }
                                    }
                                    later(function () {
                                        later(function() {
                                            moveTo(eLocation, i2, j2, _rectWidth, _rectHeight, _tileBuffer, _tileWidth, _tileHeight, left, top, null, null);
                                        });
                                    });
                                }*/ null, null);
                                // TODO - Adjust - Call after queue is done.
                                setTimeout(function() {
                                    if (_transitionsEnabled) {
                                        if (!hasStyle(getStyle(_element), TRANSITIONS_ENABLED_STYLE)) {
                                            addStyle(_element, TRANSITIONS_ENABLED_STYLE);
                                        }
                                    }
                                    moveTo(eLocation, i2, j2, _rectWidth, _rectHeight, _tileBuffer, _tileWidth, _tileHeight, left, top, null, null);
                                }, 100);
                            } else {
                                moveTo(eLocation, i2, j2, _rectWidth, _rectHeight, _tileBuffer, _tileWidth, _tileHeight, left, top, null, null);
                            }
                        } else {
                            moveTo(eLocation, i2, j2, _rectWidth, _rectHeight, _tileBuffer, _tileWidth, _tileHeight, left, top, null, null);
                        }
                    }
                    _locationToViews.set(location.getI(), lvLocation);

                    if (_hasSprites) {
                        fragment = addSpritesForLocation(location, eLocation, fragment, true);
                    }
                    /*
                    while (k < newSprites.length()) {
                        var sprite : SpriteInterface<Dynamic, Dynamic> = newSprites.get(k);
                        var svSprite : SpriteView = SpriteView.get(sprite, _spriteSettings);
                        var eSprite : Element = svSprite.toElement();
                        _spriteToViews.set(sprite.getI(), svSprite);
                        if (eSprite != null) {
                            if (!(_spriteSettings.noHideShow)) {
                                hideElement(eSprite, null, immediate());
                            }
                            if (getParent(eSprite) == null) {
                                appendChild(_innerElement, eSprite);
                            }
                            var attr : Style = getStyleFor(sprite.attributes());
                            moveSpriteTo(eSprite, eLocation, function () {
                                later(function () {
                                    setStyle(eSprite, combineStyles(svSprite.originalStyle(), attr));
                                    if (!(_spriteSettings.noHideShow)) {
                                        showElement(eSprite);
                                    }                                    
                                });
                            });
                        }
                        k++;
                    }*/
    
                    location.doneWith();
                }
                i++;
            }

            j++;
            oddRow = !oddRow;
        }

        if (fragment != null) {
            if (_fixedGrid) {
                mergeFragment(_frame, fragment);
            } else {
                mergeFragment(_innerElement, fragment);
            }
            fragment = null;
        }

        updateStyles();
        now(function () {
            renderer().doDisplay();
            if (_onEndOfUpdate != null) {
                _onEndOfUpdate();
            }
        });
        end();

        _lastUpdateX = originX();
        _lastUpdateY = originY();
    }

    public function clearOverlay() : Void {
        removeChildren(_overlay);
    }

    public function findViewForLocation(l : LocationInterface<Dynamic, Dynamic>) {
        return _locationToViews.get(l.getI());
    }

    public function originX(?x : Float = null) : Float {
        if (x == null) {
            if (_ox == null || Std.string(_ox).toUpperCase() == "NAN") {
                _ox = 0;
                return 0;
            } else {
                return _ox;
            }
        } else {
            _ox = x;
            return _ox;
        }
    }

    public function originY(?y : Float = null) : Float {
        if (y == null) {
            if (_oy == null || Std.string(_oy).toUpperCase() == "NAN") {
                _oy = 0;
                return 0;
            } else {
                return _oy;
            }
        } else {
            _oy = y;
            return _oy;
        }
    }

    public function fullScreen() : Void {
        setStyle(toElement(), FULLSCREEN);
    }

    public function updateStyles() : Void {
        var fHeight = 100.0 / _specifiedTileHeight;
        var fWidth = 100.0 / _specifiedTileWidth;
        var actualHeight = getActualPixelHeight(this._element);
        /*
        switch (_gridType) {
            case 3:
                //fHeight *= 2;
                //fWidth /= 2/3;
                fHeight *= 2/3;
                fWidth *= 2/3;
        }
        */
        var sHeight;
        switch (_gridType) {
            case 3:
                // TODO
                // sHeight = fHeight + "%"; //(fHeight * 1.03) + "%";
                //sHeight = (fHeight * this._cachedOffsetHeight / 100.0) + "px";
                if (actualHeight == 0) {
                    sHeight = (fHeight * 2) + "%";
                } else {
                    sHeight = (fHeight * actualHeight * 2 / 100.0) + "px";
                }
            default:
                // TODO
                // sHeight = fHeight + "%";
                //sHeight = (fHeight * this._cachedOffsetHeight / 100.0) + "px";
                if (actualHeight == 0) {
                    sHeight = fHeight + "%";
                } else {
                    sHeight = (fHeight * actualHeight / 100.0) + "px";
                }
        }
        var sShift : String = "";
        if (_shiftXLimit != null) {
            var i : Int = 0 - _shiftXLimit;
            var sb : StringBuf = new StringBuf();
            while (i <= _shiftXLimit) {
                sb.add(" #" + _id + ".transitions_enabled .shiftX-" + i + " {transition: transform 0.25s; }");
                i++;
            }
            sShift += sb.toString();
        }
        if (_shiftYLimit != null) {
            var i : Int = 0 - _shiftYLimit;
            var sb : StringBuf = new StringBuf();
            while (i <= _shiftYLimit) {
                sb.add(" #" + _id + ".transitions_enabled .shiftY-" + i + " {transition: transform 0.25s; }");
                i++;
            }
            sShift += sb.toString();
        }        
        var sWidth = fWidth + "%";
        now(function() {
            #if js
            try {
                // TODO - Add font size
                setText(_fieldSheet, "#" + _id + " tr { min-height: " + sHeight + "; max-height: " + sHeight + "; height: " + sHeight + ";} #" + _id + " ." + LocationView.FIELD_LOCATION_STYLE + ", #" + _id + " ." + SpriteView.FIELD_SPRITE_STYLE + " { min-height: " + sHeight + "; max-height: " + sHeight + "; height: " + sHeight + "; min-width: " + sWidth + "; max-width: " + sWidth + "; width: " + sWidth + "; line-height: " + _rectHeight + "px; }" + sShift + getAdditionalFieldStyleSheet());
            } catch (ex : Any) {

            }
            #end
        });
    }

    private function getAdditionalFieldStyleSheet() : String {
        return "";
    }

    public function scrollView(x : Float, y : Float) : Void {
        var ox : Float = originX() - _tileBuffer;
        var oy : Float = originY() - _tileBuffer;        
        //var oddRow : Bool = Math.abs(Math.floor(y + oy) % 2) == 1;
        var x2 : Float = x;
        var y2 : Float = y;
        switch (_gridType) {
            case 3:
                x2 *= 1.5;
                //if (oddRow)
                {
                    x2 += 0.75;
                }
                y2 *= 0.5;
        }
        var update : Void->Void = function () {
            start();
            switch (_gridType) {
                case 3:
                    _tileHeight *= 2;
                    _tileWidth /= 2/3;
            }

            scroll(_innerElement, -x2, -y2, _rectWidth, _rectHeight, _tileWidth, _tileHeight, null, null);
            if (_onScroll != null) {
                _onScroll(this, x, y);
            }

            originX(originX() - x);
            originY(originY() - y);

            // TODO - dispatch(createEvent(_id, x.toString() + "," + y.toString()));
            if (_autoUpdate) {
                _skipScroll = true;
                if (Math.abs(x) >= width() || Math.abs(y) >= height()) {
                    fullRefresh();
                } else {
                    update();
                }
                _skipScroll = false;
            }
            end();
        };
        if (_uiUpdates != null || _uiUpdates.length() == 0) {
            update();
        } else {
            _uiUpdates.push(update);
        }
    }

    public function zoom(t : Float) : Void {
        _tileHeight = _tileHeight * t;
        _tileWidth = _tileWidth * t;
        //createFieldLocations();

        // TODO - dispatch(createEvent(_id, t));
        if (_autoUpdate) {
            update();
        }
    }

    public function rotate(d : Float) : Void {
        var update : Void->Void = function () {
            setStyleRotate(_element, d);
            // TODO - dispatch(createEvent(_id, d));
        };
        if (_uiUpdates == null || _uiUpdates.length() == 0) {
            update();
        } else {
            _uiUpdates.push(update);
        }
    }   

    public function show() : Void {
        if (_clearOnHide) {
            fullRefresh();
        }

        showElement(_element);

        // TODO - dispatch(createEvent(_id));
    }

    public function hide() : Void {
        hideElement(_element);

        if (_clearOnHide) {
            removeChildren(_element);

        }

        // TODO - dispatch(createEvent(_id));
    }

    public function elementsChanged() : Void {
        _childrenAsVector = null;
    }

    private function overrideXY(eSprite : Element, sSprite : SpriteInterface<Dynamic, Dynamic>, f : Null<Void -> Void>) {
        var x : Float = sSprite.attribute("overrideX");
        var y : Float = sSprite.attribute("overrideY");
        var oddRow : Bool = Math.abs(Math.floor(y) % 2) == 1;
        switch (_gridType) {
            case 3:
                y /= 2;
                x *= 1.5;
                //if (oddRow) {
                //    x -= 0.75;
                //}
        }
        //x = getActualPixelWidth(this._frame) / _tileWidth * x;
        //y = getActualPixelHeight(this._frame) / _tileHeight * y;

        moveTo(eSprite, x, y, _rectWidth, _rectHeight, _tileBuffer, _tileWidth, _tileHeight, null, null, f, null);
    }

    private function addSpritesForLocation(lLocation : LocationInterface<Dynamic, Dynamic>, ?eLocation : Null<Element>, fragment : Dynamic, ?update : Bool = false) : Dynamic {
        var sNewSprites : NativeVector<SpriteInterface<Dynamic, Dynamic>> = cast _field.findSpritesForLocation(lLocation);
        //dLocation.className += " " + sRows[j - dTileBuffer] + " " + sColumns[i - dTileBuffer];

        var k : Int = 0;
        while (k < sNewSprites.length()) {
            var sSprite : Null<SpriteInterface<Dynamic, Dynamic>> = sNewSprites.get(k);
            if (sSprite != null) {
                var svSprite : Null<SpriteView> = _spriteToViews.get(sSprite.getI());
                if (svSprite == null || (update == true && sSprite.changed())) {
                    if (svSprite == null) {
                        svSprite = SpriteView.get(sSprite, _spriteSettings, this);
                    }
                    if (svSprite != null) {
                        if (eLocation == null) {
                            var lvLocation : LocationView = _locationToViews.get(lLocation.getI());
                            eLocation = lvLocation.toElement();
                        }
                        var sAttributes : Style = getStyleFor(sSprite.attributes());
                        var eSprite : Element = svSprite.toElement();
                        _spriteToViews.set(sSprite.getI(), svSprite);
                        /*
                        dSprite.style.opacity = "0 !important";
                        */
                        if (!(_spriteSettings.noHideShow)) {
                            hideElement(eSprite, null, immediate());
                        }
                        if (getParent(eSprite) == null) {
                            if (fragment == null) {
                                if (_fixedGrid) {
                                    fragment = createFragment(_frame);    
                                } else {
                                    fragment = createFragment(_innerElement);
                                }
                            }
                            appendChild(fragment, eSprite);
                        }
                        if (sSprite.attribute("overrideXY") == true) {
                            overrideXY(eSprite, sSprite, function () {
                                setStyle(eSprite, combineStyles(svSprite.originalStyle(), sAttributes));
                                if (!(_spriteSettings.noHideShow)) {
                                    showElement(eSprite);
                                }
                            });
                        } else {
                            moveSpriteTo(eSprite, eLocation, function () {
                                later(function () {
                                    setStyle(eSprite, combineStyles(svSprite.originalStyle(), sAttributes));
                                    if (_fixedGrid) {
                                        #if js
                                            var l : Dynamic = js.Syntax.code("{0}.getClientRects()", eLocation);
                                            var l2 : Dynamic = js.Syntax.code("{0}.getClientRects()", _fixedGridElements.get(0).get(0));
                                            js.Syntax.code("{0}.style.left = ({1}[0].x - {2}[0].x) + \"px\"", eSprite, l, l2);
                                            js.Syntax.code("{0}.style.top = ({1}[0].y - {2}[0].y) + \"px\"", eSprite, l, l2);
                                        #end
                                    }
                                    if (!(_spriteSettings.noHideShow)) {
                                        showElement(eSprite);
                                    }
                                });
                            });
                        }
                        /*
                        domUpdate.now(function() {
                            dSprite.style.transition = "";
                            dSprite.style.opacity = "";
                        });
                        */
                    }
                }
            }
            k++;
        }

        return fragment;
    }

    private function AddLocation(i : Float, j : Float, sTop : TopStyle, sLeft : LeftStyle, ox : Float, oy : Float, fragment : Dynamic) : Dynamic {
        var lLocation : LocationInterface<Dynamic, Dynamic> = _field.get(Math.floor(i + ox), Math.floor(j + oy));
        if (lLocation != null) {
            var lvLocation : LocationView = LocationView.get(lLocation, _locationSettings, this, null);

            if (lvLocation != null)
            {
                var eLocation = lvLocation.toElement();
                if (getParent(eLocation) == null)
                {
                    if (!(_locationSettings.noHideShow)) {
                        hideElement(eLocation, null, immediate());
                    }
                    if (fragment == null) {
                        if (_fixedGrid) {
                            fragment = createFragment(_frame);
                        } else {
                            fragment = createFragment(_innerElement);
                        }
                    }                    
                    appendChild(fragment, eLocation);
    
                }
                var pos : Coordinate = _field.getLoop(Math.floor(i + ox), Math.floor(j + oy));
                var sAttr : String = lLocation.attributes(_locationSettings.calculatedAttributes);
                var sArea : Null<Style>;
                if (_locationSettings.noAreaXY) {
                    sArea = null;
                } else {
                    sArea = combineStyles(getStyleFor("area_x_" + pos.x), getStyleFor("area_y_" + pos.y));
                }
    
                if (_shiftXLimit != null || _shiftYLimit != null) {
                    var shiftX : Null<Int> = lLocation.attribute("shiftX");
                    var shiftY : Null<Int> = lLocation.attribute("shiftY");
                    if (shiftX == null) {
                        shiftX = 0;
                    }
                    if (shiftY == null) {
                        shiftY = 0;
                    }
                    
                    if (shiftX != 0 || shiftY != 0) {
                        moveTo(eLocation, i + ox - shiftX, j + oy - shiftY, _rectWidth, _rectHeight, _tileBuffer, _tileWidth, _tileHeight, shiftX == 0 ? sLeft : null, shiftY == 0 ? sTop : null, null, null);
                        // TODO - Adjust - Call after queue is done.
                        setTimeout(function() {
                            moveTo(eLocation, i + ox, j + oy, _rectWidth, _rectHeight, _tileBuffer, _tileWidth, _tileHeight, sLeft, sTop, null, null);
                        }, 100);
                    } else {
                        moveTo(eLocation, i + ox, j + oy, _rectWidth, _rectHeight, _tileBuffer, _tileWidth, _tileHeight, sLeft, sTop, null, null);
                    }
                } else {
                    moveTo(eLocation, i + ox, j + oy, _rectWidth, _rectHeight, _tileBuffer, _tileWidth, _tileHeight, sLeft, sTop, null, null);
                }                
                var sAreaStyle : Null<String> = getStyleString(sArea);
                if (sAttr.length > 0 || (sAreaStyle != null && sAreaStyle.length > 0)) {
                    now(function() {
                        setStyle(eLocation, combineStyles(lvLocation.originalStyle(), combineStyles(getStyleFor(sAttr), sArea)));
                    });
                }
    
                if (!(_locationSettings.noHideShow)) {
                    showElement(eLocation);
                }
                //dLocation.className += " view_x_" + i;
                //dLocation.className += " view_y_" + j;
    
                //dLocation.className = "field_location " + sRows[j - dTileBuffer] + " " + sColumns[i - dTileBuffer];
                if (_hasSprites) {
                    fragment = addSpritesForLocation(lLocation, eLocation, fragment);
                }
                _locationToViews.set(lLocation.getI(), lvLocation);
            }
            var sResult : String;
            if (lvLocation != null) {
                sResult = getStyleString(getStyle(lvLocation.toElement()));
            }
            else {
                sResult = "null";
            }
            Logger.log(function () { return "Added " + (i + ox) + "," + (j + oy) + "=" + sResult; }, Logger.fieldView + Logger.locationAdded);
            lLocation.doneWith();
        }

        return fragment;
    }

    private function AddRow(j : Float, dFirstX : Float, dLastX : Float, ox : Float, oy : Float, fragment : Dynamic) : Dynamic {
        var dInnerX : Float = ox;//getFieldX(_innerElement, _rectWidth, _tileWidth);
        var dInnerY : Float = oy;//getFieldY(_innerElement, _rectHeight, _tileWidth);
        var j2 : Float = j + dInnerY;
        switch (_gridType) {
            case 3:
                j2 /= 2;
        }
        var sTop : TopStyle = top(j2, _rectHeight, _tileBuffer, _tileHeight);
        var i2 : Float = dLastX;
        var i : Float = dFirstX;
        var oddRow : Bool = Math.abs(Math.floor(j) % 2) == 1;

        while (i <= i2) {
            var i3 : Float = i + dInnerX;
            switch (_gridType) {
                case 3:
                    i3 *= 1.5;
                    if (oddRow) {
                        i3 += 0.75;
                    }
            }
            var sLeft : LeftStyle = left(i3, _rectWidth, _tileBuffer, _tileWidth);
            fragment = AddLocation(i, j, sTop, sLeft, ox, oy, fragment);
            i++;
        }

        return fragment;
    }

    private function AddColumn(i : Float, dFirstY : Float, dLastY : Float, ox : Float, oy : Float, fragment : Dynamic) : Dynamic {
        var dInnerX : Float = ox;//getFieldX(_innerElement, _rectWidth, _tileWidth);
        var dInnerY : Float = oy;//getFieldY(_innerElement, _rectHeight, _tileWidth);
        var i2 : Float = i + dInnerX;
        var j2 : Float = dLastY;
        var j : Float = dFirstY;
        var sLeft : NativeArray<LeftStyle> = new NativeArray<LeftStyle>();
        switch (_gridType) {
            case 3:
                i2 *= 1.5;
                var oddRow : Bool = Math.abs(Math.floor(j) % 2) == 1;
                if (oddRow) {
                    i2 += 0.75;
                }
                var sLeft2 : LeftStyle = left(i2, _rectWidth, _tileBuffer, _tileWidth);
                sLeft.push(sLeft2);
                if (!oddRow) {
                    i2 += 0.75;
                } else {
                    i2 -= 0.75;
                }
                sLeft2 = left(i2, _rectWidth, _tileBuffer, _tileWidth);
                sLeft.push(sLeft2);
            default:
                var sLeft2 : LeftStyle = left(i2, _rectWidth, _tileBuffer, _tileWidth);
                sLeft.push(sLeft2);
                sLeft.push(sLeft2);
        }
        var left : Int = 0;

        while (j <= j2) {
            var j3 : Float = j + dInnerY;
            switch (_gridType) {
                case 3:
                    j3 /= 2;
            }

            var sTop : TopStyle = top(j3, _rectHeight, _tileBuffer, _tileHeight);
            fragment = AddLocation(i, j, sTop, sLeft.get(left), ox, oy, fragment);
            j++;
            left = 1 - left;
        }

        return fragment;
    }

    private override function getX(e : Element, dRectWidth : Float, dTileWidth : Float, scale : Float) : Float {
        var x : Float = super.getX(e, dRectWidth, dTileWidth, scale);
        switch (_gridType) {
            case 3:
        }
        return x;
    }

    private override function getY(e : Element, dRectHeight : Float, dTileHeight : Float, scale : Float) : Float {
        var y : Float = super.getY(e, dRectHeight, dTileHeight, scale);
        switch (_gridType) {
            case 3:
        }        
        return y;
    }

    private override function getFieldX(e : Element, dRectWidth : Float, dTileWidth : Float) : Float {
        var x : Float = super.getFieldX(e, dRectWidth, dTileWidth);
        switch (_gridType) {
            case 3:
        }        
        return x;
    }

    private override function getFieldY(e : Element, dRectHeight : Float, dTileHeight : Float) : Float {
        var y : Float = super.getFieldY(e, dRectHeight, dTileHeight);
        switch (_gridType) {
            case 3:
        }        
        return y;
    }

    public function update() : Void {
        if (_fixedGrid) {
            fullRefresh();
            return;
        }
        Logger.log("Field View Update", Logger.fieldView);
        start();

        if (_uiUpdates != null) {
            while (_uiUpdates.length() > 0) {
                _uiUpdates.pop()();
            }
        }

        var ox : Float = originX();
        var oy : Float = originY();

        {
            var iOX : Int = Math.floor(ox);
            var iOY : Int = Math.floor(oy);
            if (_field.loopReset(iOX, iOY)) {
                var pos : Coordinate = _field.getLoop(iOX, iOY);
                ox = pos.x;
                oy = pos.y;
                originX(ox);
                originY(oy);
                fullRefresh();
                end();
                return;
            } else if (_lastUpdateX == null || _lastUpdateY == null) {
                fullRefresh();
                end();
                return;
            } else if (Math.abs(ox - _lastUpdateX) > _tileWidth || Math.abs(oy - _lastUpdateY) > _tileHeight) {
                fullRefresh();
                end();
                return;
            } else if (_lastFieldHeight != _field.height() || _lastFieldWidth != _field.width() || _lastMajorChange != _field.lastMajorChange()) {
                fullRefresh();
                end();
                return;
            }
        }

        _lastUpdateX = ox;
        _lastUpdateY = oy;

        {
            if (_cachedOffsetHeight == null) {
                var parentElement = getParent(_element);
                _cachedOffsetHeight = getOffsetHeight(parentElement);
                _cachedOffsetWidth = getOffsetWidth(parentElement);
            }
            var squareHeight : Float = _cachedOffsetHeight / _tileHeight;
            var squareWidth : Float = _cachedOffsetWidth / _tileWidth;
            if (_lockSquareOrientation) {
                var squareSize = squareHeight < squareWidth ? squareHeight : squareWidth;
                _rectHeight = squareSize;
                _rectWidth = squareSize;
            } else {
                _rectHeight = squareHeight;
                _rectWidth = squareWidth;
            }
        }

        var tileBuffer : Float = _tileBuffer * (_gridType == 3 ? 2 : 1);
        var dTop : Float = 0 - tileBuffer;
        var dLeft : Float = 0 - tileBuffer;
        var dBottom : Float = _tileHeight + tileBuffer;
        var dRight : Float = _tileWidth + tileBuffer;
        var dFirstY : Float = dBottom + 1;
        var dFirstYDiv : Null<Float> = null;
        var dLastY : Float = dTop - 1;
        var dLastYDiv : Null<Float> = null;
        var dFirstX : Float = dRight + 1;
        var dFirstXDiv : Null<Float> = null;
        var dLastX : Float = dLeft + 1;
        var dFirstXElement : Element = null;
        var dLastXElement : Element = null;
        var dFirstYElement : Element = null;
        var dLastYElement : Element = null;
        var dInnerX : Float = ox;//getFieldX(_innerElement, _rectWidth, _tileWidth);
        var dInnerY : Float = oy;//getFieldY(_innerElement, _rectHeight, _tileHeight);
        // TODO - Remove or Optional?


        if (!_skipScroll) {
            var scrollX : Float = ox;
            var scrollY : Float = oy;
            var oddRow : Bool = Math.abs(Math.floor(oy) % 2) == 1;
            switch (_gridType) {
                case 3:
                    scrollX *= 1.5;
                    if (oddRow)
                    {
                        scrollX += 0.75;
                    }
                    scrollY *= 0.5;
            }

            scrollX -= getFieldX(_innerElement, _rectWidth, _tileWidth);
            scrollY -= getFieldY(_innerElement, _rectHeight, _tileHeight);
/*
            switch (_gridType) {
                case 3:
                    scrollX -= 1.75;
                    scrollY -= 1.5;
            }
*/
            scroll(_innerElement, scrollX, scrollY, _rectWidth, _rectHeight, _tileWidth, _tileHeight, null, null);
        }

        /* TODO -
        if (_onScroll != null) {
            _onScroll(this, scrollX, scrollY);
        }
        */

        if (_noAddLocation == false) {
            var eSprites : NativeArray<Element> = new NativeArray<Element>();


            // for (var i = dInnerDiv.childNodes.length - 1; i >= 0 ; i--)
            if (_childrenAsVector == null) {
                _childrenAsVector = getChildrenAsVector(_innerElement);
            }        
            var children : NativeVector<Element> = _childrenAsVector;
            var i : Int = 0;
            var yMultiplier : Float;
            switch (_gridType) {
                case 3:
                    yMultiplier = 2;
                default:
                    yMultiplier = 1;
            }
            while (i < children.length()) {
                var e : Element = children.get(i);
                if (SpriteView.toSpriteView(e) != null) {
                    eSprites.push(e);
                } else {
                    var lvView : Null<LocationView> = LocationView.toLocationView(e);
                    if (lvView != null && lvView.useCount() > 0) {
                        var y : Float = Math.round(getY(e, _rectHeight, _tileWidth, 1) - dInnerY) * yMultiplier;
                        var x : Float = Math.round(getX(e, _rectWidth, _tileWidth, 1) - dInnerX);
                        switch (_gridType) {
                            case 3:
                                var oddRow = Math.abs(Math.floor(y) % 2) == 1;
                                if (oddRow)
                                {
                                    x -= 0.75;
                                }
                        }

                        if (x < dLeft || x >= dRight || y < dTop || y >= dBottom) {
                            var lLocation : LocationInterface<Dynamic, Dynamic> = lvView.location();
                            if (lLocation != null) {
                                _locationToViews.remove(lLocation.getI());                        
                                lLocation.doneWith();
                            }
                            lvView.discard();
                        } else {
                            lvView.update(null);

                            if (x < dFirstX) {
                                dFirstX = x;
                                dFirstXElement = e;
                            } else if (x > dLastX) {
                                dLastX = x;
                                dLastXElement = e;
                            }

                            if (y < dFirstY) {
                                dFirstY = y;
                                dFirstYElement = e;
                            } else if (y > dLastY) {
                                dLastY = y;
                                dLastYElement = e;
                            }
                        }
                    }
                }
                i++;
            }


            dFirstY = Math.round(dFirstY);
            dLastY = Math.round(dLastY);
            dFirstX = Math.round(dFirstX);
            dLastX = Math.round(dLastX);

            var fragment : Dynamic = null;

            if (_hasSprites) {
                var i : Int = Math.floor(dFirstX + ox);
                var j : Int = Math.floor(dLastX + ox);
                var iFirst : Int = Math.floor(dFirstY + oy);
                var iLast : Int = Math.floor(dLastY + oy);

                while (i <= j) {
                    var lLocation : LocationInterface<Dynamic, Dynamic> = _field.get(i, iFirst);
                    fragment = addSpritesForLocation(lLocation, null, fragment);
                    lLocation.doneWith();
                    lLocation = _field.get(i, iLast);
                    fragment = addSpritesForLocation(lLocation, null, fragment);
                    lLocation.doneWith();
                    i++;
                }
                i = Math.floor(dFirstY + oy);
                j = Math.floor(dLastY + oy);
                iFirst = Math.floor(dFirstX + ox);
                iLast = Math.floor(dLastX + ox);
                while (i <= j) {
                    var lLocation : LocationInterface<Dynamic, Dynamic> = _field.get(iFirst, i);
                    fragment = addSpritesForLocation(lLocation, null, fragment);
                    lLocation.doneWith();
                    lLocation = _field.get(iLast, i);
                    fragment = addSpritesForLocation(lLocation, null, fragment);
                    lLocation.doneWith();
                    i++;
                }
            }

            while (dFirstY > dTop) {
                fragment = AddRow(dFirstY - 1, dFirstX, dLastX, ox, oy, fragment);
                dFirstY -= 1;
            }
    
            while (dLastY < dBottom - 1) {
                fragment = AddRow(dLastY + 1, dFirstX, dLastX, ox, oy, fragment);
                dLastY += 1;
            }
    
            while (dFirstX > dLeft) {
                fragment = AddColumn(dFirstX - 1, dFirstY, dLastY, ox, oy, fragment);
                dFirstX -= 1;
            }
    
            while (dLastX < dRight - 1) {
                fragment = AddColumn(dLastX + 1, dFirstY, dLastY, ox, oy, fragment);
                dLastX += 1;
            }

            if (fragment != null) {
                if (_fixedGrid) {
                    mergeFragment(_frame, fragment);
                } else {
                    mergeFragment(_innerElement, fragment);
                }
                fragment = null;
            }

            if (_hasSprites) {
                while (_spritesAdded.length() > 0) {
                    var sSprite : SpriteInterface<Dynamic, Dynamic> = _spritesAdded.pop();
                    var lLocation : LocationInterface<Dynamic, Dynamic> = _field.get(sSprite.getX(_field), sSprite.getY(_field));
                    var dLocation : LocationView = findViewForLocation(lLocation);
        
                    if (_spriteToViews.get(sSprite.getI()) == null) {
                        var dSprite : SpriteView = SpriteView.get(sSprite, _spriteSettings, this);
                        if (dSprite != null)
                        {
                            var e : Element = dSprite.toElement();
                            _spriteToViews.set(sSprite.getI(), dSprite);
                            if (!(_spriteSettings.noHideShow)) {
                                hideElement(e, null, immediate());
                            }
                            if (getParent(e) == null) {
                                appendChild(_innerElement, e);
                            }
                            var sAttr : String = sSprite.attributes();
                            var fDone : Void->Void = function () {
                                later(function () {
                                    setStyle(e, combineStyles(dSprite.originalStyle(), getStyleFor(sAttr)));
                                    if (!(_spriteSettings.noHideShow)) {
                                        showElement(e);
                                    }
                                });
                            };
                            if (sSprite.attribute("overrideXY") == true) {
                                overrideXY(e, sSprite, fDone);
                            } else {
                                moveSpriteTo(e, dLocation.toElement(), fDone);
                            }
                        }
                    }
        
                    _spritesAdded = new NativeArray<SpriteInterface<Dynamic, Dynamic>>();
                }
        
                var i : Int = eSprites.length() - 1;
                while (i >= 0) {
                    try {
                        var e : Element = eSprites.get(i);
                        var v : SpriteView = SpriteView.toSpriteView(e);
                        if (v.useCount() > 0) {
                            var s : SpriteInterface<Dynamic, Dynamic> = v.sprite();
                            if (s != null) {
                                var lLocation : Null<LocationInterface<Dynamic, Dynamic>> = _field.findLocationForSprite(s);
                                var eLocation : LocationView = null;
                
                                if (lLocation != null) {
                                    eLocation = findViewForLocation(lLocation);
                                    if (eLocation != null) {
                                        if (s.attribute("overrideXY") == true) {
                                            overrideXY(e, s, null);
                                        } else {
                                            moveSpriteTo(e, eLocation.toElement());
                                        }
                                    }
                                    lLocation.doneWith();
                                    lLocation = null;
                                }
                
                                if (eLocation == null) {
                                    _spriteToViews.remove(s.getI());
                                    v.discard();
                                }
                
                                if (s.changed()) {
                                    setStyle(e, combineStyles(v.originalStyle(), getStyleFor(s.attributes())));
                                }

                                s.doneWith();
                            }
                        }
                    } catch (ex) {
                    }
                    i--;
                }
            }
        }

        //updateStyles();
        now(function () {
            renderer().doDisplay();
            if (_onEndOfUpdate != null) {
                _onEndOfUpdate();
            }
        });
        end();
    }

    private function ReduceDelay() : Void {
        _inputSettings._delay -= _inputSettings._reduceDelayIntervals;
        if (_inputSettings._delay > 0)
        {
            setTimeout(ReduceDelay, _inputSettings._reduceDelayIntervals);
        }
    }

    public function diagonal() : NavigatorInterface {
        var s : FieldSystemInterface<Dynamic, Dynamic> = cast _field;
        var navigator : NavigatorCoreInterface = s.navigator();
        var next : NavigatorCoreInterface = navigator.diagonal();
        if (next == navigator) {
            return this;
        } else {
            return new NavigatorStandard(cast _mainSprite, next);
        }
    }

    public function allDirections() : NavigatorInterface {
        var s : FieldSystemInterface<Dynamic, Dynamic> = cast _field;
        var navigator : NavigatorCoreInterface = s.navigator();
        var next : NavigatorCoreInterface = navigator.allDirections();
        if (next == navigator) {
            return this;
        } else {
            return new NavigatorStandard(cast _mainSprite, next);
        }
    }

    public function standard() : NavigatorInterface {
        var s : FieldSystemInterface<Dynamic, Dynamic> = cast _field;
        var navigator : NavigatorCoreInterface = s.navigator();
        var next : NavigatorCoreInterface = navigator.standard();
        if (next == navigator) {
            return this;
        } else {
            return new NavigatorStandard(cast _mainSprite, next);
        }
    }

    public function unlocked() : NavigatorInterface {
        var s : FieldSystemInterface<Dynamic, Dynamic> = cast _field;
        return new NavigatorStandard(cast _mainSprite, s.unlockedNavigator());
    }

    public function directionCount() : Int {
        return directions().length();
    }

    public function directions() : NativeVector<DirectionInterface> {
            var s : FieldSystemInterface<Dynamic, Dynamic> = cast _field;
            return s.navigator().directions();
    }

    private function roundX(oddRow : Bool, x : Float) {
        if (oddRow) {
            if (x < 0) {
                if (x > -1/10000.0) {
                    return 0;
                } else {
                    return Math.floor(x);                    
                }
            } else {
                if (x < 1/10000.0) {
                    return 0;
                } else {
                    return Math.ceil(x);
                }
            }
        } else {
            if (x < 0) {
                return Math.ceil(x);
            } else {
                return Math.floor(x);
            }
        }
    }

    private function navigateI(direction : DirectionInterface, distance : Int) : Bool {
        var fPrevious : Null<FieldInterface<Dynamic, Dynamic>> = null;
        var fCurrent : Null<FieldInterface<Dynamic, Dynamic>> = null;
        var bScroll : Bool = _scrollOnMove;
        var bEvent : Bool = true;

        if (_mainSprite != null) {
            fPrevious = _field.getSubfieldForSprite(_mainSprite, 0);
            if (_moveSprite(direction, distance)) {
                fCurrent = _field.getSubfieldForSprite(_mainSprite, 0);
                if (_selectOnMove) {
                    var fv : FieldViewFullInterface = cast this;
                    fv.findViewForSprite(_mainSprite).onclick(null);
                }
            } else {
                bScroll = false;
                bEvent = false;
            }
        }
        
        if (!_canMove(direction, distance, this)) {
            bScroll = false;
            bEvent = false;
        }

        var xy : NativeVector<Float> = direction.xy();
        var oddRow = Math.abs(Math.floor(_oy) % 2) == 1;
        var x : Int = roundX(oddRow, (xy.get(0) - direction.shiftX()) * direction.distanceMultiplierX());
        var y : Int = Math.round((xy.get(1) - direction.shiftY()) * direction.distanceMultiplierY());

        if (_locationSettings.triggerFocusOnElement) {
            var e  : Element = getActiveElement();
            if (e != null && hasStyle(getStyle(e), LocationView.FIELD_LOCATION_STYLE) && containsElement(_element, e)) {
                var l : LocationInterface<Dynamic, Dynamic> = _field.get(Math.floor(getX(e, _rectWidth, _tileWidth, 1) - x),  Math.floor(getY(e, _rectHeight, _tileWidth, 1) - y));
                if (l == null) {
                    bScroll = false;
                    bEvent = false;
                } else {
                    var d : LocationView = findViewForLocation(l);
                    focusOnElement(d.toElement());
                    if (_selectOnMove) {
                        d.onclick(null);
                    }
                    l.doneWith();
                }
            } else {
                focusOnElement(getElementsWithStyle(_element, LocationView.FIELD_LOCATION_STYLE).get(0));
            }
        }

        if (bEvent) {
            if (_onmove != null) {
                _onmove(direction.oppositeAny(), distance, _field, fCurrent, fPrevious);
            }
        }

        if (bScroll) {
            if (_autoUpdate) {
                scrollView(x, y);
            } else {
                _ox -= x;
                _oy -= y;
            }
        }

        _inputSettings._delay += _inputSettings._delayAfterInteraction;
        setTimeout(ReduceDelay, _inputSettings._reduceDelayIntervals);

        return bEvent;
    }

    private function navigateInDegreesI(direction : Float, distance : Int) : Bool {
        var s : FieldSystemInterface<Dynamic, Dynamic> = cast _field;
        return navigateI(s.navigator().directionForDegrees(direction), distance);
    }

    public function navigate(direction : DirectionInterface, distance : Int) : Bool {
        if (distance != 0) {
            return navigateI(direction, distance);
        } else {
            return true;
        }
    }

    public function navigateInDegrees(direction : Float, distance : Int) : Bool {
        if (distance != 0) {
            return navigateInDegreesI(direction, distance);
        } else {
            return true;
        }
    }

    public function navigateInRadians(direction : Float, distance : Int) : Bool {
        if (distance != 0) {
            return navigateInDegreesI(direction / Math.PI * 180.0, distance);
        } else {
            return true;
        }
    }

    public function navigateInClock(direction : Float, distance : Int) : Bool {
        if (distance != 0) {
            return navigateInDegreesI(direction / -12.0 * 360.0 + 90.0, distance);
        } else {
            return true;
        }
    }

    public function navigateInXY(x : Int, y : Int) : Bool {
        if (x != 0 || y != 0) {
            return navigateInDegreesI(Math.atan2(y, x) / Math.PI * 180.0, Math.round(Math.sqrt(x * x + y * y)));
        } else {
            return true;
        }
    }

/*
    public function move(x : Null<Float>, y : Null<Float>) {
        if ((x != null && x != 0) || (y != null && y != 0))
        {
            var fPrevious : Null<FieldInterface<Dynamic, Dynamic>> = null;
            var fCurrent : Null<FieldInterface<Dynamic, Dynamic>> = null;
            var bScroll : Bool = _scrollOnMove;
            var bEvent : Bool = true;

            if (_mainSprite != null) {
                fPrevious = _field.getSubfieldForSprite(_mainSprite, 0);
                if (_moveSprite(Math.floor(-x), Math.floor(-y))) {
                    fCurrent = _field.getSubfieldForSprite(_mainSprite, 0);
                    if (_selectOnMove) {
                        findViewForSprite(_mainSprite).onclick(null);
                    }
                } else {
                    bScroll = false;
                    bEvent = false;
                }
            } 

            if (_locationSettings.triggerFocusOnElement) {
                var e  : Element= getActiveElement();
                if (e != null && hasStyle(getStyle(e), LocationView.FIELD_LOCATION_STYLE) && containsElement(_element, e)) {
                    x = getX(e, _rectWidth, _tileWidth, null) - x;
                    y = getY(e, _rectHeight, _tileWidth, null) - y;
                    var l : LocationInterface<Dynamic, Dynamic> = _field.get(Math.floor(x), Math.floor(y));
                    if (l == null) {
                        bScroll = false;
                        bEvent = false;
                    } else {
                        var d : LocationView = findViewForLocation(l);
                        focusOnElement(d.toElement());
                        if (_selectOnMove) {-
                            d.onclick(null);
                        }
                        l.doneWith();
                    }
                } else {
                    focusOnElement(getElementsWithStyle(_element, LocationView.FIELD_LOCATION_STYLE).get(0));
                }
            }

            if (bEvent) {
                if (_onmove != null) {
                    _onmove(Math.floor(-x), Math.floor(-y), _field, fCurrent, fPrevious);
                }
            }
            if (bScroll) {
                //scroll(_innerElement, x, y, _rectWidth, _rectHeight, _tileWidth, _tileHeight, null, null);
                _ox -= x;
                _oy -= y;
            }

            _inputSettings._delay += _inputSettings._delayAfterInteraction;
            setTimeout(ReduceDelay, _inputSettings._reduceDelayIntervals);
        }
    }*/

    private function reportButtons(i : Int, o : Null<NativeIntMap<Float>>) : Void {
        if (o == null) {
            o = new NativeIntMap<Float>();
        }
        var unchanged : NativeArray<Int> = new NativeArray<Int>();
        var changed : NativeArray<Int> = new NativeArray<Int>();
        var myOldState : NativeIntMap<Float> = _inputSettings._oldGPState.get(i);
        var keys : Iterator<Int> = o.keys();

        for (j in keys) {
            if (myOldState.get(j) == o.get(j)) {
                unchanged.push(j);
            } else {
                changed.push(j);
            }
        }
        keys = myOldState.keys();
        for (j in keys) {
            if (myOldState.get(j) != o.get(j)) {
                changed.push(j);
            }
        }
        for (j in changed) {
            var k : Int = changed.get(j);
            var v : Null<Float> = o.get(k);
            if (v != null) {
                myOldState.remove(k);
            } else {
                myOldState.set(k, v);
            }
        }
        if (changed.length() > 0) {
            _inputSettings._gamepad(i, o);
        }
    }

    private function resizeFrame() : Void {
        var rect : Style = getStyleFor("rect");
        var landscape : Style = getStyleFor("landscape");
        var portrait : Style = getStyleFor("portrait");

        if (_tileWidth == _tileHeight && _lockSquareOrientation) {
            var sAspect : Style;
            var sSize : String;
            var parent : Element = getParent(_element);
            if (parent == null) {
                parent = renderer().defaultParent();
            }            
            var actualWidth : Int = getActualPixelWidth(parent);
            var actualHeight : Int = getActualPixelHeight(parent);
            var left : Int;
            var top : Int;

            if (actualWidth == actualHeight) {
                sAspect = rect;
                sSize = "100%";
                left = 0;
                top = 0;
            }
            else if (actualWidth > actualHeight) {
                sAspect = landscape;
                sSize = actualHeight + "px";
                left = Math.floor((actualWidth - actualHeight) / 2);
                top = 0;
            }
            else {
                sAspect = portrait;
                sSize = actualWidth + "px";
                left = 0;
                top = Math.floor((actualHeight - actualWidth) / 2);
            }

            removeStyle(_element, rect);
            removeStyle(_element, landscape);
            removeStyle(_element, portrait);
            addStyle(_element, sAspect);

            setElementX(_frame, left);
            setElementY(_frame, top);
            forceWidth(_frame, sSize);
            forceHeight(_frame, sSize);

            if (_overlay != null) {
                forceWidth(_overlay, sSize);
                forceHeight(_overlay, sSize);
                setElementX(_overlay, left);
                setElementY(_overlay, top);
            }
            var fs : FieldSystemInterface<Dynamic, Dynamic> = cast _field;
            fs.setScaleXY(1);
        }
        else {
            var sAspect : Style;
            var sWidth : String;
            var sHeight : String;
            var parent : Element = getParent(_element);
            var actualWidth : Int = getActualPixelWidth(parent);
            var actualHeight : Int = getActualPixelHeight(parent);
            var left : Int;
            var top : Int;

            var tileHeight : Int = Math.floor(actualHeight / _tileHeight);
            var tileWidth : Int = Math.floor(actualWidth / _tileWidth);
            switch (_gridType) {
                case 3:
                    tileHeight = tileHeight * 2;
            }

            var width : Int;
            var height : Int;

            if (_lockSquareOrientation) {
                var tileSquare : Int = (tileHeight > tileWidth ? tileWidth : tileHeight);
                width = Math.floor(tileSquare * _tileWidth);
                height = Math.floor(tileSquare * _tileHeight);
                var fs : FieldSystemInterface<Dynamic, Dynamic> = cast _field;
                fs.setScaleXY(1);
            } else {
                width = Math.floor(_tileWidth * tileWidth);
                height = Math.floor(_tileHeight * tileHeight);
                var fs : FieldSystemInterface<Dynamic, Dynamic> = cast _field;
                fs.setScaleXY(tileWidth / tileHeight);
            }

            left = Math.floor((actualWidth - width) / 2);
            switch (_gridType) {
                case 3:
                    height = Math.floor(height / 2);
            }

            sWidth = width + "px";
            sHeight = height + "px";

            top = Math.floor((actualHeight - height) / 2);

            removeStyle(_element, rect);
            removeStyle(_element, landscape);
            removeStyle(_element, portrait);

            //addStyle(_element, sAspect);

            setElementX(_frame, left);
            setElementY(_frame, top);
            forceWidth(_frame, sWidth);
            forceHeight(_frame, sHeight);

            if (_overlay != null) {
                forceWidth(_overlay, sWidth);
                forceHeight(_overlay, sHeight);
                setElementX(_overlay, left);
                setElementY(_overlay, top);
            }
        }

        updateStyles();
    }

    public function startDefaultListenersOptions() : DefaultListenersOptions {
        return new DefaultListenersOptions();
    }

    public function startDefaultListeners(options : DefaultListenersOptions) : Void {
        {
            _inputSettings = new InputSettings(this, _gamepadOnMouse, _gamepadOnTouch, _gridType);
            var fo : NativeStringMap<Any> = options.toMap();
            options = null;

            _inputSettings._unknownKey = cast fo.get("unknownKey");
            _inputSettings._gamepad = cast fo.get("gamepad");
            _inputSettings._mouse = cast fo.get("mouse");
            _inputSettings._delayAfterInteraction = cast fo.get("delayAfterInteraction");
            _inputSettings._reduceDelayIntervals = cast fo.get("reduceDelayIntervals");
            _inputSettings._thresholdX = cast fo.get("thresholdX");
            _inputSettings._thresholdY = cast fo.get("thresholdY");

            fo = null;
        }


        _inputSettings._delay = 0;
        _inputSettings._gamepads = 0;
        _inputSettings._oldGPState = new NativeIntMap<NativeIntMap<Float>>();

        if (_inputSettings._unknownKey == null) {
            _inputSettings._unknownKey = function (key : Int) : Void { };
        }

        if (_inputSettings._gamepad == null) {
            _inputSettings._gamepad = function (gamepad : Int, buttons : NativeIntMap<Float>) : Void { };
        }

        if (_inputSettings._mouse == null) {
            _inputSettings._mouse = function (event : String, e : Element) : Void { };
        }

        if (_inputSettings._delayAfterInteraction == null) {
            _inputSettings._delayAfterInteraction = 100;
        }

        if (_inputSettings._reduceDelayIntervals == null) {
            _inputSettings._reduceDelayIntervals = 100;
        }

        if (_inputSettings._thresholdX == null) {
            _inputSettings._thresholdX = 0.1;
        }

        if (_inputSettings._thresholdY == null) {
            _inputSettings._thresholdY = 0.1;
        }        


        // TODO
/*
        try {
            if (!!Leap) {
                var controllerOptions;
                Leap.loop(controllerOptions, function(frame) {
                    frame.toString();
                });					
            }
        } catch (ex) { }
        */


        setOnClick(_element, _inputSettings);
        setOnDblClick(_element, _inputSettings);
        setOnTouchStart(_element, _inputSettings);
        setOnTouchCancel(_element, _inputSettings);
        setOnTouchMove(_element, _inputSettings);
        setOnTouchEnd(_element, _inputSettings);
        setOnMouseDown(_element, _inputSettings);
        setOnMouseUp(_element, _inputSettings);
        setOnMouseOver(_element, _inputSettings);
        setOnKeyDown(_element, _inputSettings);
        setOnGamepadConnected(_element, _inputSettings);
        setOnGamepadDisconnected(_element, _inputSettings);
        if (_scrollOnWheel) {
            setOnWheel(_element, _inputSettings);
        }
    }

    public static function movementForValidOnly(direction : DirectionInterface, distance : Int, view : FieldViewAbstract) : Bool {
        var fs : FieldSystemInterface<Dynamic, Dynamic> = cast view.field();
        return fs.navigator().navigate(view._spriteStubValid, direction.oppositeAny(), distance);
    }

    public static function movementForAny(direction : DirectionInterface, distance : Int, view : FieldViewAbstract) : Bool {
        return true;
    }
    
    public function field(?fNew : Null<FieldInterface<Dynamic, Dynamic>>) : FieldInterface<Dynamic, Dynamic> {
        if (fNew == null) {
            return _field;
        } else {
            _field = fNew;
            var s : FieldSystemInterface<Dynamic, Dynamic> = cast fNew;
            _hasSprites = s.getMaximumNumberOfSprites() > 0;
            fullRefresh();
            return fNew;
        }
    }

    private var _autoScroll : Dynamic = null;
    private var _autoScrollEach : Void->Void = null;

    // TODO - Adjust
    public function autoScroll(x : Float, y : Float, ms : Int, noAddLocation: Bool) {
        _noAddLocation = noAddLocation;
        var f : Void->Void = function () {
            scrollView(x, y);
            if (_mainSprite != null) {
                _mainSprite.set(Math.floor(_mainSprite.getX(null) - x), Math.floor(_mainSprite.getY(null) - y));
            }
            if (_autoScrollEach != null) {
                _autoScrollEach();
            }
        };
        f();
        #if js
            _autoScroll = js.Syntax.code("setInterval({0}, {1})", f, ms);
        #end
    }

    public function endAutoScroll() {
        #if js
            js.Syntax.code("clearInterval({0})", _autoScroll);
        #end
        _noAddLocation = false;
    }
}

@:nativeGen
class FieldViewAbstractSpriteStubValid implements SpriteSystemInterface<Dynamic> {
    private var _view : FieldViewAbstract;

    public function new(view : FieldViewAbstract) {
        _view = view;
    }

    public function move(x : Int, y : Int) : Bool {
        var field : Null<FieldInterface<Dynamic, Dynamic>> = _view.field();
        if (field == null) {
            return false;
        } else {
            var l : Null<LocationInterface<Dynamic, Dynamic>> = cast field.get(cast (x + _view.originX()), cast (y + _view.originY()));
            if (l == null) {
                return false;
            } else {
                l.notInUse();
                return true;
            }
        }
    }

    public function field() : Dynamic {
        return _view.field();
    }
}
#end