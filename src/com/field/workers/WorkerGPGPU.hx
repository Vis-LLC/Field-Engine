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

import com.field.NativeArray;

@:nativeGen
/**
    Run a function that on the GPU.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
class WorkerGPGPU {
    private static var _gpu : Dynamic = initGPU();
    private static var _instance : Dynamic = initInstance();

    private static function initGPU() : Dynamic {
        #if js
            var g : Dynamic = null;
            js.Syntax.code("
                try {
                    {0} = eval('GPU');
                } catch (ex) { }
            ", g);
            return g;
        #else
            // TODO - Others
            return null;
        #end
    }

    private static function initInstance() : Dynamic {
        if (_gpu != null) {
            #if js
                try {
                    return js.Syntax.code("new {0}()", _gpu);
                } catch (ex : Any) {
                    js.html.Console.log(ex);
                    return null;
                }
            #else
                // TODO - Others
                return null;
            #end
        } else {
            return null;
        }
    }

    private static function initMethods() : Void {
        #if js
            js.Syntax.code("
                var gpu = {0};

                gpu.addFunction(function accessor_moveColumn(i, x) {
                    return i + x;
                }, { argumentTypes: {i: 'Number', x: 'Number'}, returnType: 'Number' });

                gpu.addFunction(function accessor_moveRow(i, y) {
                    return i + y * 10;
                }, { argumentTypes: {i: 'Number', x: 'Number'}, returnType: 'Number' });
            ", _instance);
        #else
            // TODO - Others
        #end
    }

    /**
        Determines if GPGPU code is supported.
    **/
    public static function isSupported() : Bool {
        if (_gpu == null) {
            _gpu = initGPU();
        }
        return (_gpu != null);
    }

    /**
        Checks to see if GPGPU code will actually run on a GPU.
    **/
    public static function isGPUSupported() : Bool {
        if (_gpu == null) {
            _gpu = initGPU();
        }        
        if (_gpu == null) {
            return false;
        } else {
            #if js
                return js.Syntax.code("
                    {0}.isGPUSupported
                ", _gpu);
            #else
                // TODO - Others
                return false;
            #end
        }
    }

    private static function combineKernels(stages : NativeArray<Any>, stageMethods : NativeArray<Int>, fType : Int) : Any {
        #if js
            var mega : StringBuf = new StringBuf();
            var args : NativeArray<Any> = new NativeArray<Any>();

            mega.add("(");
            mega.add("function (");
            switch (fType) {
                case 1: // Locations
                    mega.add("locationMemory, locationAttributes, width, height, params");
                case 2: // Sprites
                    mega.add("spriteMemory, spriteAttributes, width, height, maximumNumberOfSprites, params");
                case 3: // Both
                    mega.add("locationMemory, spriteMemory, locationAttributes, spriteAttributes, width, height, maximumNumberOfSprites, params");
            }
            mega.add(") { var r;");
            var i : Int = 0;
            while (i < stages.length()) {
                args.push(stages.get(i));
                mega.add("r = stages[" + i + "](");
                switch (i) {
                    case 0:
                        switch (stageMethods.get(i)) {
                            case 1: // Locations
                                mega.add("locationMemory, locationAttributes, width, height, params");
                            case 2: // Sprites
                                mega.add("spriteMemory, spriteAttributes, width, height, maximumNumberOfSprites, params");
                            case 3: // Both
                                mega.add("locationMemory, spriteMemory, locationAttributes, spriteAttributes, width, height, maximumNumberOfSprites, params");
                        }
                    default:
                        switch (stageMethods.get(i)) {
                            case 0: // Mapping
                                mega.add("r, params");
                            case 1: // Locations
                                mega.add("locationMemory, locationAttributes, width, height, params");
                            case 2: //Sprites
                                mega.add("spriteMemory, spriteAttributes, width, height, maximumNumberOfSprites, params");
                            case 3: // Both
                                mega.add("locationMemory, spriteMemory, locationAttributes, spriteAttributes, width, height, maximumNumberOfSprites, params");
                        }
                    }
                mega.add(");");
                i++;
            }
            mega.add("return r;}");
            mega.add(")");
            args.push(js.Syntax.code("eval({0})", mega.toString()));
            return js.Syntax.code("{0}.combineKernels.apply({0}, {1})", _instance, args);
        #else
            // TODO
            return null;
        #end
    }

    private static function compileKernel(f : Any, fType : Int, field : FieldInterface<Dynamic, Dynamic>, previousType, mapWidth : Null<Int>, mapHeight : Null<Int>, defines : NativeVector<Any>) : Any {
        #if js
            var k : Any = js.Syntax.code("{0}.createKernel({1})", _instance , f);
            js.Syntax.code("{0}.setPipeline(true).setImmutable(true)", k);
            if (fType == 0) {
                fType = previousType;
            }
            if (mapWidth != null && mapHeight != null) {
                js.Syntax.code("{0}.setOutput([{1}, {2}])", k, mapWidth, mapHeight);
            } else {
                switch (fType) {
                    case 1, 3: // Locations or both
                        js.Syntax.code("{0}.setOutput([{1}, {2}])", k, field.width(), field.height());
                    case 2: // Sprites
                        var sys : FieldSystemInterface<Dynamic, Dynamic> = cast field;
                        js.Syntax.code("{0}.setOutput([{1}])", k, sys.getMaximumNumberOfSprites());
                }
            }
            var i : Int = 0;
            while (i < defines.length()) {
                js.Syntax.code("{0}.addFunction({1})", k, defines.get(i));
                i++;
            }
            return k;
        #else
            // TODO
            return null;
        #end
    }

    /**
        Compile the function to a usable object that can be run.
    **/
    public static function compile(options : WorkerGPGPUOptions) : WorkerGPGPUMethod {
        if (_gpu == null) {
            _gpu = initGPU();
        }
        if (_gpu != null && _instance == null) {
            _instance = initInstance();
        }
        var stages : NativeArray<Any> = new NativeArray<Any>();
        var stageMethods : NativeArray<Int> = new NativeArray<Int>();
        var fo : NativeStringMap<Any> = options.toMap();
        var method : Null<WorkerGPGPUMethod> = null;
        var start : Int = -1;
        var field : FieldInterface<Dynamic, Dynamic>;
        var mapWidth : Null<Int> = cast fo.get("width");
        var mapHeight : Null<Int> = cast fo.get("height");
        var defines : NativeVector<Any>;
        options = null;
        {
            var count : Int = cast fo.get("defineCount");
            var functions : NativeArray<Any> = new NativeArray<Any>();
            var i : Int = 0;

            while (i < count) {
                functions.push(fo.get("define" + i));
                i++;
            }

            defines = functions.toVector();
        }
        {
            field = cast fo.get("field");
            var initializer : Any = fo.get("mapInitializer");
            if (initializer != null) {
                var initializerType : Int = cast fo.get("mapInitializerType");
                start = initializerType;
                stageMethods.push(initializerType);
                switch (initializerType) {
                    case 1: // Location
                    {
                        // locationMemory -> locationAttributes -> width -> height -> params
                        var f : NativeVector<Int> -> Int -> Int -> NativeVector<Int> -> Int = cast initializer;
                        stages.push(compileKernel(f, initializerType, field, -1, mapWidth, mapHeight, defines));
                        method = new WorkerGPGPUMethodForLocations();
                    }
                    case 2: // Sprite
                    {
                        // spriteMemory -> spriteAttributes -> width -> height -> maximumNumberOfSprites -> params
                        var f : NativeVector<Int> -> Int -> Int -> Int -> NativeVector<Int> -> Int = cast initializer;
                        stages.push(compileKernel(f, initializerType, field, -1, mapWidth, mapHeight, defines));
                        method = new WorkerGPGPUMethodForSprites();
                    }
                    case 3: // Both
                    {
                        // locationMemory -> spriteMemory -> locationAttributes -> spriteAttributes -> width -> height -> maximumNumberOfSprites -> params
                        var f : NativeVector<Int> -> NativeVector<Int> -> Int -> Int -> Int -> Int -> Int -> NativeVector<Int> -> Int = cast initializer;
                        stages.push(compileKernel(f, initializerType, field, -1, mapWidth, mapHeight, defines));
                        method = new WorkerGPGPUMethodForFields();
                    }
                }
            }
        }
        {
            var count : Int = cast fo.get("functionCount");
            var i : Int = 0;
            
            while (i < count) {
                var f : Any = fo.get("function" + i);
                var iterations : Int = cast fo.get("function" + i + "repeat");
                var fType : Int = cast fo.get("function" + i + "type");

                if (method == null) {
                    switch (fType) {
                        case 0: // Generic - TODO
                            //method = new WorkerGPGPUMethodForGeneric();
                        case 1:
                            method = new WorkerGPGPUMethodForLocations();
                        case 2:
                            method = new WorkerGPGPUMethodForSprites();
                    }
                    start = fType;
                }

                var j : Int = 0;
                while (j < iterations) {
                    stages.push(compileKernel(f, fType, field, stageMethods.get(j - 1), fType == 0 ? mapWidth : null, fType == 0 ? mapHeight : null, defines));
                    stageMethods.push(fType);
                    j++;
                }
                i++;
            }
        }

        // TODO - Finalizers?
        var ma : WorkerGPGPUMethodAbstract = cast method;
        ma.init(combineKernels(stages, stageMethods, start));
        return method;
    }
}
