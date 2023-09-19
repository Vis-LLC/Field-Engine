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

package com.field.search;

import com.field.workers.WorkerGPGPU;
import com.field.workers.WorkerGPGPUMethod;
import com.field.workers.WorkerGPGPUOptions;
import com.field.workers.WorkerGPGPUResult;
import com.field.NativeArray;

@:expose
@:nativeGen
/**
  Finds a set of paths from one location in a Field to another.
**/
class FindPaths {
    private static function myMin(lowest : Int, check : Int) : Int {
        if (check <= 0) {
            return lowest;
        } else if (lowest <= 0) {
            return check;
        } else if (check > lowest) {
            return lowest;
        } else {
            return check;
        }
    }

    private static function findInMap(map : NativeVector<NativeVector<Int>>, params : NativeVector<Int>) : Int {
        var thread_x : Int = 0;
        var thread_y : Int = 0;
        var width : Int = params.get(0);
        var height : Int = params.get(1);
        var curX : Int = thread_x;
        var curY : Int = thread_y % height;
        var dest : Int = params.get(2);
        var impassable : Int = params.get(3);
        var current : Int = map.get(curY).get(curX);
        var section : Int = Math.floor(thread_y / height);

        if (current != 0) {
            return current;
        } else {
            var above : Int = 0;
            var left : Int = 0;
            var right : Int = 0;
            var below : Int = 0;

            if (curY <= 0) {
                above = impassable;
            } else {
                above = map.get(curY - 1).get(curX);
            }
            if (curY >= height) {
                below = impassable;
            } else {
                below = map.get(curY).get(curX);
            }
            if (curX <= 0) {
                left = impassable;
            } else {
                left = map.get(curY).get(curX - 1);
            }
            if (curX >= width) {
                right = impassable;
            } else {
                right = map.get(curY).get(curX + 1);
            }

            if (above == dest || below == dest || left == dest || right == dest) {
                return 1;
            } else {
                var lowest = myMin(myMin(myMin(myMin(impassable, above), below), left), right);

                if (lowest < 0) {
                    return 0;
                } else {
                    return lowest + 1;
                }
            }
        }
    }

    private static function paramList(width : Int, height : Int, dest : Int, impassable : Int) : NativeVector<Null<Int>> {
        var arr : NativeArray<Null<Int>> = new NativeArray<Null<Int>>();
        arr.push(width);
        arr.push(height);
        arr.push(dest);
        arr.push(impassable);
        return arr.toVector();
    }

    private static function initParamList(width : Int, height : Int, dest : Int, impassable : Int, dests : NativeArray<Null<Int>>) : NativeVector<Null<Int>> {
        var arr : NativeArray<Null<Int>> = new NativeArray<Null<Int>>();
        arr.push(width);
        arr.push(height);
        arr.push(dest);
        arr.push(impassable);
        arr = arr.concat(dests);
        return arr.toVector();
    }    
   
    private static function initMap(locationMemory : NativeVector<Null<Int>>, locationAttributes : Int, fieldWidth : Int, fieldHeight : Int, params : NativeVector<Null<Int>>) : Int {
        var thread_x : Int = 0;
        var thread_y : Int = 0;
        var width : Int = params.get(0);
        var height : Int = params.get(1);
        var curX : Int = thread_x;
        var curY : Int = thread_y % height;
        var dest : Int = params.get(2);
        var impassable : Int = params.get(3);
        var section : Int = Math.floor(thread_y / height);
        var sectionIndex : Int = section * 5 + 4;
        var sectionX : Int = params.get(sectionIndex + 0);
        var sectionY : Int = params.get(sectionIndex + 1);
        var attributeToCheck : Int = params.get(sectionIndex + 2);
        var attributeValue : Int = params.get(sectionIndex + 3);
        var attributeOperation : Int = params.get(sectionIndex + 4);

        if ((curX * 2) < width && ((curX + 1) * 2) > width) {
            return dest;
        } else {
            var i : Int = ((sectionY + curY) * fieldWidth + sectionX + curX) * locationAttributes + attributeToCheck;
            var value : Int = locationMemory.get(i);
            if (
                (attributeOperation == 1 && attributeValue == value)
                || (attributeOperation == 0 && attributeValue != value)
            ) {
                return impassable;
            } else {
                return 0;
            }
        }
    }

    public static function execute(options : FindPathsOptions) : Void {
        var fo : NativeStringMap<Any> = options.toMap();
        options = null;
        var hopLimit : Int = cast fo.get("hopLimit");
        var dests : NativeArray<Int> = cast fo.get("dests");
        var callback : FindPathsResult -> Void = cast fo.get("callback");
        var width : Int = hopLimit * 2 + 1;
        var dest : Int = -2;
        var impassable : Int = -1;
        var cache : Null<NativeStringMap<WorkerGPGPUMethod>> = cast fo.get("cache");
        var field : FieldInterface<Dynamic, Dynamic> = cast fo.get("field");
        fo = null;

        var key : String = "" + hopLimit + "-" + (dests.length() / 5);
        var code : Null<WorkerGPGPUMethod> = null;

        if (cache != null) {
            code = cast cache.get(key);
        }

        if (code == null) {
            var gpuOptions : WorkerGPGPUOptions = new WorkerGPGPUOptions();

            gpuOptions.mapInitializerLocation(initMap, width, Math.floor(width * dests.length() / 5));
            gpuOptions.chainMapMethod(findInMap, hopLimit);
            gpuOptions.addFunction(myMin);
            gpuOptions.field(field);
    
            code = WorkerGPGPU.compile(gpuOptions);

            if (cache != null) {
                cache.set(key, code);
            }
        }

        var pl1 : NativeVector<Null<Int>> = initParamList(width, width, dest, impassable, dests);
        var pl2 : NativeVector<Null<Int>> = paramList(width, width, dest, impassable);

        #if java
            var pl1b : NativeVector<Int> = new NativeVector<Int>(pl1.length());
            var pl2b : NativeVector<Int> = new NativeVector<Int>(pl2.length());
        
            var i : Int = 0;
            while (i < pl1.length()) {
                pl1b.set(i, pl1.get(i));
                i++;
            }
            i = 0;
            while (i < pl2.length()) {
                pl2b.set(i, pl2.get(i));
                i++;
            }
        #else
            var pl1b : NativeVector<Int> = cast pl1;
            var pl2b : NativeVector<Int> = cast pl2;
        #end

        code.execute(field, pl1b, pl2b, null, function (result : WorkerGPGPUResult) {
            var result2 : FindPathsResult = new FindPathsResult();
            callback(result2);
        });
    }

    /*
        pipeline1.addFunction(function myMin(lowest, check) {
            if (check <= 0) {
                return lowest;
            } else if (lowest <= 0) {
                return check;
            } else if (check > lowest) {
                return lowest;
            } else {
                return check;
            }
        }, { argumentTypes: {lowest: 'Number', check: 'Number'}, returnType: 'Number' });

        const pipeline1 = gpu.createKernel(function (a, b, c, cLength, accessor) {
            const current = a[this.thread.y][this.thread.x];
            if (current != 0) {
                return current;
            } else {
                let above = 0;
                let left = 0;
                let right = 0;
                let below = 0;

                if (this.thread.y <= 0) {
                    above = -1;
                } else {
                    above = a[this.thread.y - 1][this.thread.x];
                }
                if (this.thread.y >= accessor.getHeight()) {
                    below = -1;
                } else {
                    below = a[this.thread.y + 1][this.thread.x];
                }
                if (this.thread.x <= 0) {
                    left = -1;
                } else {
                    left = a[this.thread.y][this.thread.x - 1];
                }
                if (this.thread.x >= accessor.getWidth()) {
                    right = -1;
                } else {
                    right = a[this.thread.y][this.thread.x + 1];
                }

                if (above == b || below == b || left == b || right == b) {
                    return 1;
                } else {
                    const lowest = myMin(myMin(myMin(myMin(-1, above), below), left), right);

                    if (lowest < 0) {
                        return 0;
                    } else {
                        return lowest + 1;
                    }
                }
            }
        }, /*{
            argumentTypes: { a: 'Array', b: 'Number', c: 'Number' }
        }/)
        .setPipeline(true)
        .setImmutable(true)
        .setOutput([10, 10]);


        const mega = gpu.combineKernels(pipeline1, function (a, b, c, cLength, accessor) {
            let r = a;
            let iterations = accessor.getWidth() * accessor.getHeight();
            for (let i = 0; i < iterations; i++) {
                r = pipeline1(r, b, c, cLength, accessor);
            }
            return r;
        });
    
        result = mega(result, -2, [-3, -4, -5], 3, accessor);
    */

    public static function options() : FindPathsOptions {
        return new FindPathsOptions();
    }
}