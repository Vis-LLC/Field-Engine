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

package com.field;

@:expose
@:nativeGen
/**
  Allows for the setting of options for the Field class.
**/
class FieldOptions<L, S> extends OptionsAbstract<FieldOptions<L, S>> {
    public inline function new() { super(); }

    private static var _preallocated : com.field.manager.Manager<Dynamic, Dynamic, Dynamic> = new com.field.manager.Preallocated<Dynamic, Dynamic, Dynamic, Dynamic>();
    private static var _lazyPermanent : com.field.manager.Manager<Dynamic, Dynamic, Dynamic> = new com.field.manager.LazyPermanent<Dynamic, Dynamic, Dynamic, Dynamic>();
    private static var _lazyPermanentWillFill : com.field.manager.Manager<Dynamic, Dynamic, Dynamic> = new com.field.manager.LazyPermanentWillFill<Dynamic, Dynamic, Dynamic, Dynamic>();
    private static var _transientNoReuse : com.field.manager.Manager<Dynamic, Dynamic, Dynamic> = new com.field.manager.TransientNoReuse<Dynamic, Dynamic, Dynamic, Dynamic>();
    private static var _transientReuse : com.field.manager.Manager<Dynamic, Dynamic, Dynamic> = new com.field.manager.TransientReuse<Dynamic, Dynamic, Dynamic, Dynamic>();

    /**
        The width of the grid of the Field.  How many elements wide it is.
    **/
    public function width(width : Int) : FieldOptions<L, S> {
        return set("width", width);
    }

    /**
        The height of the grid of the Field.  How many elements long it is.
    **/
    public function height(height : Int) : FieldOptions<L, S> {
        return set("height", height);
    }

    /**
        The maximum number of sprites that can appear on the field.  By default this is 0.
    **/
    public function maximumNumberOfSprites(sprites : Int) : FieldOptions<L, S> {
        return set("maximumNumberOfSprites", sprites);
    }

    /**
        The CSS class that is assigned to indvidual Locations or squares in the grid of the Field.  By default this is null.
    **/
    public function locationClass(location : String) : FieldOptions<L, S> {
        return set("locationClass", location);
    }

    /**
        The CSS class that is assigned to indvidual Sprites that appear on the Field.  By default this is null.
    **/
    public function spriteClass(sprite : String) : FieldOptions<L, S> {
        return set("spriteClass", sprite);
    }    

    /**
        Attributes whose values are predefined string values for Locations on a Field.  By default this is null.
    **/
    public function locationPredefinedAttributes(o : Null<NativeStringMap<NativeArray<String>>>) : FieldOptions<L, S> {
        return set("locationPredefinedAttributes", o);
    }
    
    /**
        Attributes whose values are predefined string values for Sprites on a Field.  By default this is null.
    **/
    public function spritePredefinedAttributes(o : Null<NativeStringMap<NativeArray<String>>>) : FieldOptions<L, S> {
        return set("spritePredefinedAttributes", o);
    }

    /**
        Attributes whose values that are calculated by functions for Locations on a Field.
    **/
    public function locationCalculatedAttributes(o : Null<NativeStringMap<L->Any>>) : FieldOptions<L, S> {
        return set("locationCalculatedAttributes", o);
    }

    /**
        Attributes whose values that are calculated by functions for Sprites on a Field.
    **/
    public function spriteCalculatedAttributes(o : Null<NativeStringMap<S->Any>>) : FieldOptions<L, S> {
        return set("spriteCalculatedAttributes", o);
    }

    /**
        Attributes whose values are numbers for Locations on a Field.
    **/
    public function locationNumericalAttributes(o : NativeStringMap<Numerical>) : FieldOptions<L, S> {
        return set("locationNumericalAttributes", o);
    }

    /**
        Attributes whose values are numbers for Sprites on a Field.
    **/
    public function spriteNumericalAttributes(o : NativeStringMap<NumericalOptions>) : FieldOptions<L, S> {
        return set("spriteNumericalAttributes", o);
    }

    /**
        The memory allocation mechanism to use for Location objects for a Field.  The default is defined by the Field.
    **/
    public function locationAllocator(o : com.field.manager.Allocator<L>) : FieldOptions<L, S> {
        return set("locationAllocator", o);
    }

    /**
        The memory allocation mechanism to use for Sprite objects for a Field.  The default is defined by the Field.
    **/
    public function spriteAllocator(o : com.field.manager.Allocator<S>) : FieldOptions<L, S> {
        return set("spriteAllocator", o);
    }

    /**
        The memory manager mechanism to use for Sprite objects for a Field.  Preallocate all Sprite objects.
    **/
    public function spritePreallocated() : FieldOptions<L, S> {
        return setOnce("spriteManager", _preallocated);
    }

    /**
        The memory manager mechanism to use for Location objects for a Field.  Preallocate all Locations objects.
    **/
    public function locationPreallocated() : FieldOptions<L, S> {
        return setOnce("locationManager", _preallocated);
    }

    /**
        The memory manager mechanism to use for Location objects for a Field.  After allocating a Sprite, keep it around.
    **/
    public function spriteLazyPermanent() : FieldOptions<L, S> {
        return setOnce("spriteManager", _lazyPermanent);
    }

    /**
        The memory manager mechanism to use for Location objects for a Field.  After allocating a Location, keep it around.
    **/
    public function locationLazyPermanent() : FieldOptions<L, S> {
        return setOnce("locationManager", _lazyPermanent);
    }

    /**
        The memory manager mechanism to use for Location objects for a Field.  After allocating a Sprite, keep it around.  The intent is to eventually allocate all or most of them.
    **/
    public function spriteLazyPermanentWillFill() : FieldOptions<L, S> {
        return setOnce("spriteManager", _lazyPermanentWillFill);
    }

    /**
        The memory manager mechanism to use for Location objects for a Field.  After allocating a Location, keep it around.  The intent is to eventually allocate all or most of them.
    **/
    public function locationLazyPermanentWillFill() : FieldOptions<L, S> {
        return setOnce("locationManager", _lazyPermanentWillFill);
    }

    /**
        The memory manager mechanism to use for Location objects for a Field.  Freely create Sprite objects and do not reuse them.
    **/
    public function spriteTransientNoReuse() : FieldOptions<L, S> {
        return setOnce("spriteManager", _transientNoReuse);
    }

    /**
        The memory manager mechanism to use for Location objects for a Field.  Freely create Location objects and do not reuse them.
    **/
    public function locationTransientNoReuse() : FieldOptions<L, S> {
        return setOnce("locationManager", _transientNoReuse);
    }

    /**
        The memory manager mechanism to use for Location objects for a Field.  Freely create Sprite objects, but reuse them whenever possible.
    **/
    public function spriteTransientReuse() : FieldOptions<L, S> {
        return setOnce("spriteManager", _transientReuse);
    }

    /**
        The memory manager mechanism to use for Location objects for a Field.  Freely create Location objects, but reuse them whenever possible.
    **/
    public function locationTransientReuse() : FieldOptions<L, S> {
        return setOnce("locationManager", _transientReuse);
    }

    /**
        Loop the coordinates across the X axis.
    **/
    public function horizontalLoop() : FieldOptions<L, S> {
        return setOnce("getLoop", 2);
    }

    /**
        Loop the coordinates across the Y axis.
    **/
    public function verticalLoop() : FieldOptions<L, S> {
        return setOnce("getLoop", 1);
    }    

    /**
        Loop the coordinates across both the X axis and Y axis.
    **/
    public function horizontalVerticalLoop() : FieldOptions<L, S> {
        return setOnce("getLoop", 3);
    }

    /**
        Don't loop.
    **/
    public function defaultLoop() : FieldOptions<L, S> {
        return setOnce("getLoop", 0);
    }

    /**
        Don't reset the coordinates on loop.
    **/
    public function defaultLoopReset() : FieldOptions<L, S> {
        return setOnce("loopReset", 0);
    }

    /**
        Reset the coordinates after doubling the size of the Field.
    **/
    public function loopResetWhenDoubled() : FieldOptions<L, S> {
        return setOnce("loopReset", 1);
    }    

    /**
        Set the id of the Field.
    **/
    public function id(id : String) : FieldOptions<L, S> {
        return set("id", id);
    }

    /**
        Make Field handle a grid of hexagons.
    **/
    public function gridTypeHex() : FieldOptions<L, S> {
        return setOnce("gridType", 3);
    }

    /**
        Make Field handle a grid of squares.
    **/
    public function gridTypeSquare() : FieldOptions<L, S> {
        return setOnce("gridType", 1);
    }    

}