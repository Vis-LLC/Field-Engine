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

package com.field.workers;

@:nativeGen
/**
    A compiled routine that can be run.  This runs across the whole Field data structure.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
class WorkerGPGPUMethodForFields extends WorkerGPGPUMethodAbstract {
    public function new() {
        super();
    }
    // TODO - More?
    public override function execute(field : FieldInterface<Any, Any>, initParams : Null<NativeVector<Int>>, methodParams : Null<NativeVector<Int>>, finalParams : Null<NativeVector<Int>>, callback : WorkerGPGPUResult -> Void) : Void {
        #if js
            var f : NativeVector<Int> -> NativeVector<Int> -> Int -> Int -> Int -> Int -> Int -> NativeVector<Int> -> Any = cast _kernel;
            var sys : FieldSystemInterface<Any, Any> = cast field;
            callback(cast f(sys.getLocationMemory(), sys.getSpriteMemory(), sys.getLocationAttributeCount(), sys.getSpriteAttributeCount(), sys.getMaximumNumberOfSprites(), field.width(), field.height(), methodParams));
        #else
            // TODO
        #end
    }
}