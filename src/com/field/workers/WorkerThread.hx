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

import com.field.AccessorFlatArraysData;
import com.field.NativeVector;
import com.field.AccessorFlatArraysData;
import com.field.AccessorInterface;

@:nativeGen
/**
    Provides access to a Thread.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
class WorkerThread
/*#if java
    implements java.lang.Runnable
#end*/
{
    #if js
        private var _thread : js.html.Worker;
    #elseif (target.threaded)
        private var _lock : sys.thread.Mutex = new sys.thread.Mutex();
        private var _queue : NativeArray<Any> = new NativeArray<Any>();
        private var _thread : sys.thread.Thread;
    #else
        private var _thread : Any;
    #end

    @:allow(WorkerThreadPool.initPool)
    @:internal
    public var _id : Int;

    private var _pool : WorkerThreadPool;

    #if js
	    private function workerInit() : Void {
            var workerScope : js.html.DedicatedWorkerGlobalScope = untyped self;
            workerScope.onmessage = #if js
                js.Syntax.code("onMessage")
            #else
                onMessage
            #end
            ;
        }
        
        private static function signedByteArray(data : Any, start : Int, size : Int) : Any {
            return new js.lib.Int8Array(cast data, start, size);
        }

        private static function unsignedByteArray(data : Any, start : Int, size : Int) : Any {
            return new js.lib.Uint8Array(cast data, start, size);
        }

        private static function signed2ByteArray(data : Any, start : Int, size : Int) : Any {
            return new js.lib.Int16Array(cast data, start, size);
        }

        private static function unsigned2ByteArray(data : Any, start : Int, size : Int) : Any {
            return new js.lib.Uint16Array(cast data, start, size);
        }

        private static function signed4ByteArray(data : Any, start : Int, size : Int) : Any {
            return new js.lib.Int32Array(cast data, start, size);
        }

        private static function unsigned4ByteArray(data : Any, start : Int, size : Int) : Any {
            return new js.lib.Uint32Array(cast data, start, size);
        }

        private static function signed8ByteArray(data : Any, start : Int, size : Int) : Any {
            return js.Syntax.code("new BigInt64Array(data, start, size)");
        }
        
        private function convertToObject(o : Any) : Any {
            return _pool.convertToObject(o);
        }

        private function addToFunctionCache(i : Int, f : Any) : Void {
            _pool.addToFunctionCache(i, f);
        }

        @:allow(WorkerThreadPool.initExports)
        @:internal        
        public function onMessage(e : js.html.MessageEvent) : Void {
            var workerScope : js.html.DedicatedWorkerGlobalScope = untyped self;
            var result : Any = null;
            var err : Any = null;
            var work : Work = cast e.data;
            var origFunc : Any = work.func;
            var origData : Any = work.data;
            
            if (work.func != null) {
                work.func = convertToObject(work.func);
                if (work.func == null) {
                    work.func = origFunc;
                    work.data = origData;
                    #if js
                        js.Syntax.code("_rerun.push({0})", e);
                    #end
                    return;
                }
            }
            if (work.data != null) {
                work.data = convertToObject(work.data);
                if (work.data == null) {
                    work.func = origFunc;
                    work.data = origData;
                    #if js
                        js.Syntax.code("_rerun.push({0})", e);
                    #end
                    return;
                }
            }
            if (work.accessor == null && work.func == null) {
                var addShared : Null<WorkAddToShared> = cast work.data;
                var key : Int = -1;
                if (addShared.k == null) {
                    #if js
                        var cache : NativeStringMap<Any> = cast js.Syntax.code("_functionCache");
                        for (entry in cache.keys()) {
                            var val : Any = cache.get(entry);
                            var accessor : Bool = cast js.Syntax.code("({0}.sliceCount > 0)", val);
                            var notInit : Bool = cast js.Syntax.code("({0}.data == null)", val);
                            if (accessor && notInit) {
                                var accessorData  : AccessorFlatArraysData = cast val;
                                js.Syntax.code("{0}.raw = {1}", val, addShared.v);
                                var locationsSize : Int = 0;
                                var i : Int = 0;
                                while (i <= 1) {
                                    var f : Any -> Int -> Int -> Any = null;
                                    var signed : Bool = (i == 0 ? accessorData.locationSigned : accessorData.spriteSigned);
                                    switch (i == 0 ? accessorData.locationSize : accessorData.spriteSize) {
                                        case 1:
                                            if (signed) {
                                                f = js.Syntax.code("Int8Array");
                                            } else {
                                                f = js.Syntax.code("Uint8Array");
                                            }
                                        case 2:
                                            if (signed) {
                                                f = js.Syntax.code("Int16Array");
                                            } else {
                                                f = js.Syntax.code("Uint16Array");
                                            }
                                        case 4:
                                            if (signed) {
                                                f = js.Syntax.code("Int32Array");
                                            } else {
                                                f = js.Syntax.code("Uint32Array");
                                            }
                                        case 8:
                                            if (signed) {
                                                f = js.Syntax.code("BigInt64Array");
                                            } else {
                                                throw "Invalid data";
                                            }
                                    }
                                    switch (i) {
                                        case 0:
                                            locationsSize = accessorData.locationAttributes.count * accessorData.width * accessorData.height;
                                            accessorData.locationMemory = js.Syntax.code("new {0}({1}, 0, {2});", f, accessorData.raw, locationsSize);
                                        case 1:
                                            var spritesSize : Int = accessorData.spriteAttributes.count * accessorData.maximumNumberOfSprites;
                                            accessorData.spriteMemory = js.Syntax.code("new {0}({1}, Math.ceil({2} / 8) * 8, {3});", f, accessorData.raw, locationsSize * accessorData.locationSize, spritesSize);
                                    }
        
                                    i++;
                                }                                
                            }
                        }
                    #else
                        // TODO?
                    #end
                } else {
                    if (
                        #if js
                            cast js.Syntax.code("Number.isInteger({0})", addShared.k)
                        #else
                            Std.is(addShared.k, Int)
                        #end
                    ) {
                        key = addShared.k;
                    } else {
                        var k : String = cast addShared.k;
                        if (k.indexOf("-") >= 0) {
                            #if js
                                key = js.Syntax.code("parseInt({0}.split(\"-\")[1])", addShared.k);
                            #else
                                key = Std.parseInt(addShared.k.split("-")[1]);
                            #end
                        }
                    }

                    if (key < 0 || key == null) {
                        var path : NativeArray<String> = cast js.Syntax.code("{0}.split(\".\")", addShared.k);
                        var i : Int = 0;
                        var curPath : String = "";
                        var cur : Any;
                        while (i < path.length()) {
                            cur = null;
                            if (curPath.length > 0) {
                                curPath += ".";
                            }
                            curPath += path.get(i);
                            try {
                                cur = js.Syntax.code("eval({0})", curPath);
                            } catch (e : Any) {
                            }
                            if (cur == null) {
                                js.Syntax.code("eval(\"globalThis.\" + {0} + \" = {}\")", curPath);
                            }
                            i++;
                        }
                        if (js.Syntax.code("!!({0}.body)", addShared.v)) {
                            js.Syntax.code("eval(\"globalThis.\" + {0} + \" = \" + convertToFunction({1}))", addShared.k, addShared.v);
                        } else {
                            js.Syntax.code("eval(\"globalThis.\" + {0} + \" = \" + {1})", addShared.k, addShared.v);
                        }
                    } else {
                        addToFunctionCache(key, addShared.v);
                    }
                }
            } else {
                #if js
                    js.Syntax.code("try {");
                #else
                    try {
                #end
                    result = processWork(work);
                #if js
                    js.Syntax.code("} catch (ex) { {0} = ex; }", err);
                #else
                    } catch(ex) {
                        err = ex;
                    }
                #end

                workerScope.postMessage(
                    #if js
                        js.Syntax.code("{ data: {0}, err: {1}, job: {2} }", result, err, work.job)
                    #else
                        new WorkResult(e, err, work.job)
                    #end
                );
            }
            #if js
                js.Syntax.code("if (_rerun.length > 0) {
                    clearTimeout();
                    setTimeout(function () {
                        onMessage(_rerun.shift());
                    });
                }");
            #end
        }
    #else
        private function convertToObject(o : Any) : Any {
            return o;
        }
    #end

    private function start() : 
        #if js
            js.html.Worker
            /* TODO
        #elseif java
            java.lang.Thread
            */
        #elseif (target.threaded)
            sys.thread.Thread
        #else
            Dynamic
        #end
    {
        #if js
            return new js.html.Worker(WorkerThreadPool._exports);
        /*#elseif java
            return new java.lang.Thread(this);
            */
        #elseif (target.threaded)
            return sys.thread.Thread.create(run);
        #else
            throw "Not supported";
        #end
    }

    private function run() : Void {
        while (true) {
            var work :
            #if js
                Dynamic = null;
                throw "Not supported";
            #elseif (target.threaded)
                Work = cast sys.thread.Thread.readMessage(true);
                processWork(work);
            #else
                Dynamic = null;
                throw "Not supported";
            #end
        }
    }

    @:allow(WorkerThreadPool.initExports)
    @:internal 
    public static function wrapAccessor(accessorData : AccessorFlatArraysData) : AccessorInterface {
        #if js
            if (accessorData.raw != null) {
                var locationsSize : Int = 0;
                var i : Int = 0;
                while (i <= 1) {
                    var f : Any -> Int -> Int -> Any = null;
                    var signed : Bool = (i == 0 ? accessorData.locationSigned : accessorData.spriteSigned);
                    switch (i == 0 ? accessorData.locationSize : accessorData.spriteSize) {
                        case 1:
                            if (signed) {
                                f = signedByteArray;
                            } else {
                                f = unsignedByteArray;
                            }
                        case 2:
                            if (signed) {
                                f = signed2ByteArray;
                            } else {
                                f = unsigned2ByteArray;
                            }
                        case 4:
                            if (signed) {
                                f = signed4ByteArray;
                            } else {
                                f = unsigned4ByteArray;
                            }
                        case 8:
                            if (signed) {
                                f = signed8ByteArray;
                            } else {
                                throw "Invalid data";
                            }
                    }
                    switch (i) {
                        case 0:
                            locationsSize = accessorData.locationAttributes.count * accessorData.width * accessorData.height;
                            accessorData.locationMemory = f(accessorData.raw, 0, locationsSize);
                        case 1:
                            accessorData.spriteMemory = f(accessorData.raw, Math.ceil(locationsSize / 8) * 8, accessorData.spriteAttributes.count * accessorData.maximumNumberOfSprites);
                    }
                    i++;
                }
            }

            return AccessorFlatArrays.wrap(accessorData);
        #elseif (target.threaded)
            // TODO
            throw "Not supported";
        #else
            throw "Not supported";
        #end
    }

    @:allow(WorkerThreadPool.initExports)
    @:internal        
    public function processWork(work : Work) : Any {
        var accessorTmp : Any = convertToObject(work.accessor);
        var accessor : AccessorInterface;
        #if js
            js.Syntax.code("if ({0}.getRows) {", accessorTmp);
        #else
            if (Std.isOfType(accessorTmp, AccessorInterface)) {
        #end
                accessor = cast accessorTmp;
        #if js
            js.Syntax.code("} else {");
        #else
            } else {
        #end
                var id : String = cast work.accessor;
                var idNum : Int;
                #if js
                    idNum = js.Syntax.code("parseInt({0}.split(\"-\")[1])", id);
                #else
                    idNum = Std.parseInt(id.split("-")[1]);
                #end
                var accessorData : AccessorFlatArraysData = cast accessorTmp;
                
                accessor = AccessorFlatArrays.wrap(accessorData);
                //addToFunctionCache(idNum, accessor);
        #if js
            js.Syntax.code("}");
        #else
            }
        #end
        var result : Any = null;
        var err : Any = null;
        var func : AccessorInterface -> Any = cast work.func;

        accessor.data(work.data);
        #if js
            js.Syntax.code("try {");
        #else
            try {
        #end
                result = func(accessor);
        #if js
            js.Syntax.code("} catch (ex) { {0} = ex; }", err);
        #else
            } catch (ex) { err = ex; } 
        #end
        accessor.clearData();
        if (err != null) {
            #if js
                js.Syntax.code("throw {0}", err);
            #else
                throw err;
            #end
        }

        return result;
    }

    @:allow(WorkerThreadPool.splitWork)
    @:internal
    public function passMessage(o : Work) : Void {
        #if js
            _thread.postMessage(o);
        #elseif (target.threaded)
            _thread.sendMessage(o);
        #else
            throw "Not supported";
        #end
    }

    @:allow(WorkerThreadPool.splitWork)
    @:internal
    public function receiveMessage(work : Work, i : Int, processors : Int, ?callback : Any -> Any -> Int -> Int -> Void) : Void {
        #if js
            // Note: Can't set value on same line at this time.  Compilation errors out.
            var receiver : Any = null;
            receiver = function (e : Dynamic) {
                var result : WorkResult = cast e.data;
                if (result.job == work.job) {
                    if (callback != null) {
                        _thread.removeEventListener("error", receiver);
                        _thread.removeEventListener("message", receiver);
                        callback(result.data, result.err, i, processors);
                    }
                }
            };
            _thread.addEventListener("error", receiver);
            _thread.addEventListener("message", receiver);
        #elseif (target.threaded)
            // TODO
            throw "Not supported";
        #else
            throw "Not supported";
        #end
    }

    @:allow(WorkerThreadPool.initPool)
    @:internal
    public function new(pool : WorkerThreadPool) {
        if (pool != null) {
            _pool = pool;
            #if js    
                if (WorkerThreadPool._exports == null) {
                    WorkerThreadPool._exports = pool.initExports(
                            js.Syntax.code("this.workerInit")
                    );
                }
            #end
            _thread = start();
        }
    }

    public static function isSupported() : Bool {
        return
        #if js
            true
        #elseif (target.threaded)
            true
        #else
            false
        #end
        ;
    }

    public static function getProcessors() : Int {
        return 0 +
        #if js
            js.Browser.window.navigator.hardwareConcurrency
        #elseif (target.threaded)
            // TODO
            1
        #else
            1
        #end
        ;
    }

    public function dispose() : Void {
        if (_thread != null) {
            #if js
                _thread.terminate();
            #end
            _thread = null;
        }
    }
}