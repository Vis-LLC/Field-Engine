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
    Options to compile a function for GPGPU.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
class WorkerGPGPUOptions extends OptionsAbstract<WorkerGPGPUOptions> {
    public inline function new() {
        super();
        set("functionCount", 0);
        set("defineCount", 0);
    }

    /**
        
    **/
    public function addFunction(f : Any) {
        var count : Int = cast get("defineCount");
        set("define" + count, f);
        set("defineCount", ++count);
        return this;
    }

    private function chainMethod(f : Any, repeat : Int, type : Int) {
        var count : Int = cast get("functionCount");
        set("function" + count, f);
        set("function" + count + "repeat", repeat);
        set("function" + count + "type", type);
        set("functionCount", ++count);
        return this;
    }

    // locationMemory -> locationAttributes -> width -> height -> params
    public function mapInitializerLocation(f : NativeVector<Int> -> Int -> Int -> Int -> NativeVector<Int> -> Int, width : Int, height : Int) : WorkerGPGPUOptions {
        set("mapInitializer", f);
        setOnce("mapInitializerType", 1);
        return this;
    }

    // spriteMemory -> spriteAttributes -> width -> height -> maximumNumberOfSprites -> params
    public function mapInitializerSprite(f : NativeVector<Int> -> Int -> Int -> NativeVector<Int> -> Int, width : Int, height : Int) : WorkerGPGPUOptions {
        set("mapInitializer", f);
        setOnce("mapInitializerType", 2);
        return this;
    }

    // locationMemory -> spriteMemory -> locationAttributes -> spriteAttributes -> width -> height -> maximumNumberOfSprites -> params
    public function mapInitializerBoth(f : NativeVector<Int> -> NativeVector<Int> -> Int -> Int -> Int -> Int -> Int -> NativeVector<Int> -> Int, width : Int, height : Int) {
        set("mapInitializer", f);
        setOnce("mapInitializerType", 3);
        setOnce("width", width);
        setOnce("height", height);
        return this;
    }

    // Finals
    
    

    // Operation with loop and step
    public function chainMapMethod(f : NativeVector<NativeVector<Int>> -> NativeVector<Int> -> Int, repeat : Int) {
        return chainMethod(f, repeat, 0);
    }

    // locationMemory -> locationAttributes -> width -> height -> params
    public function chainLocationMethod(f : NativeVector<Int> -> Int -> Int -> NativeVector<Int> -> Int, repeat : Int) : WorkerGPGPUOptions {
        return chainMethod(f, repeat, 1);
    }

    // spriteMemory -> spriteAttributes -> width -> height -> maximumNumberOfSprites -> params
    public function chainSpriteMethod(f : NativeVector<Int> -> Int -> Int -> NativeVector<Int> -> Int, repeat : Int) : WorkerGPGPUOptions {
        return chainMethod(f, repeat, 2);
    }

    /**
        Set the Field to use for the data.
    **/
    public function field(field : FieldInterface<Dynamic, Dynamic>) : WorkerGPGPUOptions {
        return set("field", field);
    }
}