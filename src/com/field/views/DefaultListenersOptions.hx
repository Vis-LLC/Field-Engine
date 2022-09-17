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
@:expose
@:nativeGen
/**
    Options for activity listeners for FieldView.
**/
class DefaultListenersOptions extends OptionsAbstract<DefaultListenersOptions> {
    public inline function new() { super(); }

    /**
        Function to call when a key is pressed that is not recognized.
    **/
    public function unknownKey(unknownKey : Int->Void) : DefaultListenersOptions {
        return set("unknownKey", unknownKey);
    }

    /**
        Function to call when gamepad activity is detected.
    **/
    public function gamepad(gamepad : Int->NativeIntMap<Int>->Void) : DefaultListenersOptions {
        return set("gamepad", gamepad);
    }

    /**
        Function to call when mouse activity is detected.
    **/
    public function mouse(mouse : String->Any->Void) : DefaultListenersOptions {
        return set("mouse", mouse);
    }

    /**
        How long to wait between calls.
    **/
    public function delayAfterInteraction(delayAfterInteraction : Int) : DefaultListenersOptions {
        return set("delayAfterInteraction", delayAfterInteraction);
    }

    /**
        How much to decrease wait by per iteration.
    **/
    public function reduceDelayIntervals(reduceDelayIntervals : Int) : DefaultListenersOptions {
        return set("reduceDelayIntervals", reduceDelayIntervals);
    }

    /**
        Noise threshold for X axis.
    **/
    public function thresholdX(thresholdX : Float) : DefaultListenersOptions {
        return set("thresholdX", thresholdX);
    }

    /**
        Noise threshold for Y axis.
    **/
    public function thresholdY(thresholdY : Float) : DefaultListenersOptions {
        return set("thresholdY", thresholdY);
    }

    /**
        Apply options to FieldView.
    **/
    public function execute(view : FieldViewInterface) : Void {
        view.startDefaultListeners(this);
    }
}
#end