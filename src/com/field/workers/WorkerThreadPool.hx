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

import haxe.display.Display.Package;

@:nativeGen
/**
    Provides routines that allow for management of Thread Pools.
    These functions are not meant to used externally, only internally to the FieldEngine library.
**/
class WorkerThreadPool implements WorkerThreadPoolInterface {
    // TODO - PHP
    #if js
        public var _cacheCount : Int = 0;
        public var _functionCache : NativeIntMap<Any> = new NativeIntMap<Any>();
        public var _reverseFunctionCache : NativeObjectMap<Int> = new NativeObjectMap<Int>();
        public var _reverseFunctionCacheString : NativeStringMap<Int> = new NativeStringMap<Int>();
        public static var _exports : Dynamic = null;
        public var _funcData : NativeObjectMap<FuncData> = new NativeObjectMap<FuncData>();
        private var _registered : NativeStringMap<Any> = new NativeStringMap<Any>();
    #end

    private var _accessors : NativeVector<NativeVector<Any>>;
    private var _accessorIds : NativeVector<NativeVector<String>>;
    public var _workers : NativeVector<WorkerThread>;
    private var _count : Int = 0;
    private var _wrapped : Int = 0;

    public function new(defaultAccessorData : AccessorFlatArraysData) {
        if (defaultAccessorData != null) {
            _accessors = initAccessors(defaultAccessorData);
        }
        initPool();
    }

    public function initAccessors(defaultAccessorData : AccessorFlatArraysData) : NativeVector<NativeVector<Any>> {
        var processors : Int = WorkerThread.getProcessors();
        var accessors : NativeVector<NativeVector<Any>> = new NativeVector<NativeVector<Any>>(processors);
        var i : Int = 0;

        while (i < processors) {
            var set : NativeVector<Any> = new NativeVector<Any>(i + 1);
            accessors.set(i, set);
            var j : Int = 0;
            while (j <= i) {
                var accessor : AccessorFlatArraysData = new AccessorFlatArraysData(j, i + 1, true);
                accessor.raw = defaultAccessorData.raw;
                accessor.locationMemory = defaultAccessorData.locationMemory;
                accessor.spriteMemory = defaultAccessorData.spriteMemory;
                accessor.locationAttributes = defaultAccessorData.locationAttributes;
                accessor.spriteAttributes = defaultAccessorData.spriteAttributes;
                accessor.directions = defaultAccessorData.directions;
                accessor.locationSize = defaultAccessorData.locationSize;
                accessor.locationSigned = defaultAccessorData.locationSigned;
                accessor.spriteSize = defaultAccessorData.spriteSize;
                accessor.spriteSigned = defaultAccessorData.spriteSigned;
                accessor.height = defaultAccessorData.height;
                accessor.width = defaultAccessorData.width;
                accessor.maximumNumberOfSprites = defaultAccessorData.maximumNumberOfSprites;
                accessor.data = null;

                set.set(j, accessor);
                j++;
            }
            i++;
        }

        return accessors;
    }

    public function setupAccessors(accessors : NativeVector<NativeVector<Any>>) : NativeVector<NativeVector<String>> {
        #if js
            var processors : Int = WorkerThread.getProcessors();
            var accessorIds : NativeVector<NativeVector<String>> = new NativeVector<NativeVector<String>>(processors);
            var raw : Any = null;
            var i : Int = 0;

            while (i < processors) {
                accessorIds.set(i, new NativeVector<String>(i + 1));
                var j : Int = 0;
                while (j <= i) {
                    var accessorToSend = accessors.get(i).get(j);
                    js.Syntax.code("raw = {0}.raw; var locationMemory = {0}.locationMemory; var spriteMemory = {0}.spriteMemory; {0}.raw = null; {0}.locationMemory = null; {0}.spriteMemory = null", accessorToSend);
                    accessorIds.get(i).set(j, addToCacheIfNotFound(accessorToSend, false));
                    js.Syntax.code("{0}.raw = raw; {0}.locationMemory = locationMemory; {0}.spriteMemory = spriteMemory", accessorToSend);
                    j++;
                }
                i++;
            }

            addSharedMemory(raw);

            return accessorIds;
        #else
            // TODO
            return null;
        #end
    }

    private function initPool() : Void {
        var processors : Int = WorkerThread.getProcessors();
        _workers = new NativeVector<WorkerThread>(processors);
        var i : Int = 0;

        while (i < processors) {
            var worker : WorkerThread = new WorkerThread(this);
            worker._id = i;
            _workers.set(i, worker);
            i++;
        }

        #if js
            i = getCacheCount();
            registerObjectToGlobal("com_field_SpriteAbstract.getAttribute");
            
            setCacheCount(i + 1);        
            if (_accessors != null) {
                _accessorIds = setupAccessors(_accessors);
            }
        #end
    }

    #if js
        private function getFuncData() : NativeObjectMap<FuncData> {
            return _funcData;
        }

        private function convertFunction(f : Any) : FuncData {
            var data : Null<FuncData> = getFuncData().get(f);
            if (data == null) {
                var sF : Null<String> = js.Syntax.code("{0}.toString()", f);
                if (sF == "[object Object]") {
                    sF = haxe.Json.stringify(f);
                }
                
                var iArgList : Int = sF.indexOf("(") + 1;
                var iArgEnd : Int = sF.indexOf(")", iArgList);
                var iFunction : Int = sF.indexOf("{", iArgEnd) + 1;
                var iFunctionEnd : Int = sF.lastIndexOf("}");
                data = new FuncData(StringTools.trim(sF.substring(iArgList, iArgEnd)), StringTools.replace(StringTools.trim(sF.substring(iFunction, iFunctionEnd)), "com.field.SpriteAbstract.getAttribute", "com_field_SpriteAbstract.getAttribute"));
                getFuncData().set(f, data);
            }
            return data;
        }

        private function convertMemberFunctions(o : Dynamic, isArray : Bool) : Any {
            var n : Any;
            if (isArray) {
                var arrSrc : NativeArray<Dynamic> = cast o;
                var arrDest : NativeVector<Dynamic> = new NativeVector<Dynamic>(arrSrc.length());
                n = arrDest;

                var i : Int = 0;
                while (i < arrSrc.length()) {
                    arrDest.set(i, convertObject(arrSrc.get(i)));
                    i++;
                }
            } else {
                var mapSrc : NativeStringMap<Dynamic> = cast o;
                var mapDest : NativeStringMap<Dynamic> = new NativeStringMap<Dynamic>();
                n = mapDest;

                for (i in mapSrc.keys()) {
                    mapDest.set(i, convertObject(mapSrc.get(i)));
                }
            }
            return n;
        }

        /// TODO - Optimize
        private function searchCacheFor(o : Any, ?storeId : Null<Bool>) : Null<Int> {
            if (o != null) {
                if (storeId == true) {
                    #if js
                        js.Syntax.code("if ({0}[\"cacheId\"] !== undefined) {
                            return {0}.cacheId;
                        }", o);
                    #end
                }
                var id : Null<Int> = getReverseFunctionCache().get(o);
                if (id == null || getFunctionCache().get(id) != o) {
                    var s : Null<String> = js.Syntax.code("{0}.toString()", o);
                    if (s == "[object Object]") {
                        s = haxe.Json.stringify(o);
                    }
                    id = getReverseFunctionCacheString().get(s);
                }
                return id;
            } else {
                return null;
            }
        }

        private static function getTypeString(o : Any) : String {
            return js.Lib.typeof(o);
        }

        private static function convertToFunction(func : FuncData) : Any {
            /*
            var func = _functionCache[f.body];
            if (!func) {
                */
                js.Syntax.code("{0} = new Function({0}.args, {0}.body)", func);
                /*
                _functionCache[f.body] = func;
            }*/
            return func;
        }
        
        private function convertMemberToFunctions(o : NativeStringMap<Dynamic>) : Void {
            for (i in o.keys()) {
                o.set(i, convertToObject(o.get(i)));
            }
        }
        
        private function getFunctionCache() : NativeIntMap<Any> {
            return _functionCache;
        }

        private function getReverseFunctionCache() : NativeObjectMap<Int> {
            return _reverseFunctionCache;
        }

        private function getReverseFunctionCacheString() : NativeStringMap<Int> {
            return _reverseFunctionCacheString;
        }        

        private function getCacheCount() : Int {
            return _cacheCount;
        }

        private function setCacheCount(cacheCount) : Int {
            _cacheCount = cacheCount;
            return cacheCount;
        }

        @:internal
        public function convertToObject(o : Any) : Any {
            var convert : Bool;
            var t : String = getTypeString(o);
            switch (t) {
                case "string":
                    var s : String = #if js
                        js.Syntax.code("{0}.toString()", o);
                    #else
                        Std.string(o);
                    #end
                    if (s.indexOf("FEFC-") == 0) {
                        o = getFunctionCache().get(
                            #if js
                                js.Syntax.code("parseInt")
                            #else
                                Std.parseInt
                            #end
                            (s.split("-")[1]));
                        convert = false;
                    } else {
                        convert = true;
                    }
                default:
                    convert = true;
            }
            if (convert) {
                switch (t) {
                    case "function":
                        throw "Invalid data";
                    case "string":
                        // Intentionally left blank
                    case "number":
                        // Intentionally left blank
                    case "boolean":
                        // Intentionally left blank
                    case "undefined":
                        // Intentionally left blank
                    default:
                        js.Syntax.code("
                            if (o === null) {
                                // Intentionally left blank
                            } else if (o instanceof Array) {
                                convertMemberToFunctions(o);
                            } else if (o instanceof Date) {
                                // Intentionally left blank
                            } else if (o instanceof RegExp) {
                                // Intentionally left blank
                            } else if (o instanceof String) {
                                // Intentionally left blank
                            } else if (o instanceof Number) {
                                // Intentionally left blank
                            } else if (o instanceof Boolean) {
                                // Intentionally left blank
                            } else {
                                if (!!(o[\"args\"]) && !!(o[\"body\"])) {
                                    return convertToFunction(o);
                                } else {
                                    convertMemberToFunctions(o);
                                }
                            }
                        ");
                }
            }
        
            return o;
        }

        @:internal
        public function initExports(workerInit : Void -> Void) : Dynamic {
            var dummyThread = new WorkerThread(null);
            var workerExport = new NativeStringMap<Dynamic>();

            function setWorkerExport(k : String, v : Any) : Void {
                workerExport.set(k, v);
            }

            function accessorClassExport(n : String, c : Any) {
                #if js
                    js.Syntax.code("
                        {0}({1}, {2}.toString());
                        {0}({1} + \".__name__\", {2}.__name__);
                        var proto = {2}.prototype;
                        var send = \"{\\n\";
                        for (var k in proto) {
                            send += k + \": \" + proto[k].toString() + \",\\n\";
                        }
                        send += \"\\n}\";
                        {0}({1} + \".prototype\", send);
                        if (!!({2}.wrap)) {
                            {0}({1} + \".wrap\", {2}.wrap.toString());
                        }
                        if (!!({2}.__super__)) {
                            {0}({1} + \".__super__\", {2}.__super__.toString());
                        }
                        if ({2}.PREDEFINED != undefined) {
                            {0}({1} + \".PREDEFINED\", {2}.PREDEFINED);
                        }
                        if ({2}.RAW != undefined) {
                            {0}({1} + \".RAW\", {2}.RAW);
                        }
                        if ({2}.FLOAT != undefined) {
                            {0}({1} + \".FLOAT\", {2}.FLOAT);
                        }
                        if ({2}.CALCULATED != undefined) {
                            {0}({1} + \".CALCULATED\", {2}.CALCULATED);
                        }
                    ", setWorkerExport, n, c, convertObject);
                #end
            }

            accessorClassExport("com_field_AccessorFlatArrays",
                #if js
                    js.Syntax.code("{0}", AccessorFlatArrays)
                #else
                    AccessorFlatArrays
                #end
            );
            accessorClassExport("com_field_AccessorFlatArraysAttributes",
                #if js
                    js.Syntax.code("{0}", AccessorFlatArraysAttributes)
                #else
                    AccessorFlatArraysAttributes
                #end
            );
            accessorClassExport("com_field_AccessorFlatArraysData",
                #if js
                    js.Syntax.code("{0}", AccessorFlatArraysData)
                #else
                    AccessorFlatArraysData
                #end
            );
            accessorClassExport("com_field_AccessorFlatArraysGeneric",
                #if js
                    js.Syntax.code("{0}", AccessorFlatArraysGeneric)
                #else
                    AccessorFlatArraysGeneric
                #end
            );
            accessorClassExport("com_field_AccessorFlatArraysH1",
                #if js
                    js.Syntax.code("{0}", AccessorFlatArraysH1)
                #else
                    AccessorFlatArraysH1
                #end
            );            
            accessorClassExport("com_field_AccessorFlatArraysH1L1",
                #if js
                    js.Syntax.code("{0}", AccessorFlatArraysH1L1)
                #else
                    AccessorFlatArraysH1L1
                #end
            );            
            accessorClassExport("com_field_AccessorFlatArraysL1",
                #if js
                    js.Syntax.code("{0}", AccessorFlatArraysL1)
                #else
                    AccessorFlatArraysL1
                #end
            );            
            accessorClassExport("com_field_AccessorFlatArraysW1",
                #if js
                    js.Syntax.code("{0}", AccessorFlatArraysW1)
                #else
                    AccessorFlatArraysW1
                #end
            );            
            accessorClassExport("com_field_AccessorFlatArraysW1L1",
                #if js
                    js.Syntax.code("{0}", AccessorFlatArraysW1L1)
                #else
                    AccessorFlatArraysW1L1
                #end
            );            
            setWorkerExport("convertFunction",
                #if js
                    js.Syntax.code("this.convertFunction")
                #else
                    convertFunction
                #end
            );
            setWorkerExport("convertMemberFunctions",
                #if js
                    js.Syntax.code("this.convertMemberFunctions")
                #else
                    convertMemberFunctions
                #end
            );
            setWorkerExport("convertObject",
                #if js
                    js.Syntax.code("this.convertObject")
                #else
                    convertObject
                #end
            );
            setWorkerExport("convertToFunction",
                #if js
                    js.Syntax.code("com_field_workers_WorkerThreadPool.convertToFunction")
                #else
                    convertToFunction
                #end
            );
            setWorkerExport("convertMemberToFunctions",
                #if js
                    js.Syntax.code("this.convertMemberToFunctions")
                #else
                    convertMemberToFunctions
                #end
            );
            setWorkerExport("convertToObject",
                #if js
                    js.Syntax.code("this.convertToObject")
                #else
                    convertToObject
                #end
            );
            setWorkerExport("addToFunctionCache",
                #if js
                    js.Syntax.code("this.addToFunctionCache")
                #else
                    addToFunctionCache
                #end
            );
            setWorkerExport("getTypeString",
                #if js
                    js.Syntax.code("com_field_workers_WorkerThreadPool.getTypeString")
                #else
                    getTypeString
                #end
            );            
            setWorkerExport("processWork",
                #if js
                    js.Syntax.code("{0}.processWork", dummyThread)
                #else
                    dummyThread.processWork
                #end
            );
            setWorkerExport("onMessage",
                #if js
                    js.Syntax.code("{0}.onMessage", dummyThread)
                #else
                    dummyThread.onMessage
                #end
            );
            /*
            setWorkerExport("wrapAccessor",
                #if js
                    js.Syntax.code("com_field_workers_WorkerThread.wrapAccessor")
                #else
                    dummyThread.wrapAccessor
                #end
            );
            */            
            setWorkerExport("getFunctionCache",
                #if js
                    js.Syntax.code("this.getFunctionCache")
                #else
                    getFunctionCache
                #end
            );
            setWorkerExport("getReverseFunctionCache",
                #if js
                    js.Syntax.code("this.getReverseFunctionCache")
                #else
                    getReverseFunctionCache
                #end
            );            
            setWorkerExport("getReverseFunctionCacheString",
                #if js
                    js.Syntax.code("this.getReverseFunctionCacheString")
                #else
                    getReverseFunctionCacheString
                #end
            );
            
            var sExports = "var _rerun = new Array();\nvar _functionCache = { };\nvar _reverseFunctionCache = { };\nvar _reverseFunctionCacheString = { };\n\n";
            for (i in workerExport.keys()) {
                var o : Any = workerExport.get(i);
                var s : Null<String> = null;
                if (i.indexOf("__name__") >= 0) {
                    s = haxe.Json.stringify(o);
                } else {
                    if (getTypeString(o) == "string") {
                        js.Syntax.code("{0} = {1}", s, o);
                    } else {
                        s = js.Syntax.code("{0}.toString()", o);
                    }
                    if (s == "[object Object]") {
                        s = haxe.Json.stringify(o);
                    }
                }
                if (i.indexOf(".") >= 0) {
                    sExports += 
                    #if js
                        "" + i + " = ";
                    #end
                } else {
                    sExports += 
                    #if js
                        "var " + i + " = ";
                    #end                    
                }
                sExports += StringTools.replace(StringTools.replace(/*StringTools.replace(s, "this.", "")*/ s, "com_field_workers_WorkerThreadPool.", ""), "com_field_workers_WorkerThread.", "") + ";\n\n";
            }

            sExports += convertFunction(workerInit).body;
            var bExports = new js.html.Blob([sExports]);
            var uExports = js.html.URL.createObjectURL(bExports);
            return uExports;
        }

        private function addToAllNamespaces(k : String, f : Dynamic, ?convert : Null<Bool>) : Void {
            if (convert == null) {
                convert = true;
            }
            var sendFunc : Dynamic;
            if (convert) {
                sendFunc = convertObject(f);
            } else {
                sendFunc = f;
            }

            var job : Int = Std.parseInt(Date.now().toString().substring(5)) + Math.floor(Math.random() * 10000);
            var o : Work = new Work(null, new WorkAddToShared(k, sendFunc), null, job);

            // Couldn't do for on Vector in Haxe at the time.
            var worker : Int = 0;
            while (worker < _workers.length()) {
                _workers.get(worker).passMessage(o);
                worker++;
            }
        }

        private function addSharedMemory(f : Dynamic) : Void {
            var job : Int = Std.parseInt(Date.now().toString().substring(5)) + Math.floor(Math.random() * 10000);
            var o : Work = new Work(null, new WorkAddToShared(null, f), null, job);

            // Couldn't do for on Vector in Haxe at the time.
            var worker : Int = 0;
            while (worker < _workers.length()) {
                _workers.get(worker).passMessage(o);
                worker++;
            }
        }

        public function registerObjectToGlobal(k : String) {
            if (_registered.get(k) == null) {
                // TODO - Cleanup string.  Make sure it's an object name.
                var v : Any = null;
                try {
                    v = js.Syntax.code("eval({0})", k);
                } catch (ex) { }
                if (v != null) {
                    addToAllNamespaces(k, v);
                    if (k.indexOf(".") >= 0) {
                        registerObjectToGlobal(StringTools.replace(k, ".", "_"));
                    }
                    _registered.set(k, v);
                }
            }
        }

        private function addToAllFunctionCaches(i : Int, f : Dynamic, ?convert : Null<Bool>) : Void {
            if (convert == null) {
                convert = true;
            }
            var sendFunc : Dynamic;
            if (convert) {
                sendFunc = convertObject(f);
            } else {
                sendFunc = f;
            }

            var job : Int = Std.parseInt(Date.now().toString().substring(5)) + Math.floor(Math.random() * 10000);
            addToFunctionCache(i, f);
            var o : Work = new Work(null, new WorkAddToShared(i, sendFunc), null, job);

            // Couldn't do for on Vector in Haxe at the time.
            var worker : Int = 0;
            while (worker < _workers.length()) {
                _workers.get(worker).passMessage(o);
                worker++;
            }
        }

        private function addToCacheIfNotFound(o : Dynamic, ?convert : Null<Bool>, ?storeId : Null<Bool>) : Any {
            var i : Null<Int> = searchCacheFor(o, storeId);

            if (i == null) {
                i = getCacheCount();
                addToAllFunctionCaches(i, o, convert);
                setCacheCount(i + 1);
                if (storeId == true) {
                    o.cacheId = i;
                }
            }

            return "FEFC-" + i;
        }

        @:internal
        public function addToFunctionCache(i : Int, f : Any) : Void {
            var s : Null<String> = js.Syntax.code("{0}.toString()", f);
            if (s == "[object Object]") {
                s = haxe.Json.stringify(f);
            }
            getFunctionCache().set(i, f);
            getReverseFunctionCache().set(f, i);
            getReverseFunctionCacheString().set(s, i);
        }

        private function convertObject(o : Any) : Any {
            var i : Null<Int> = searchCacheFor(o);

            if (i != null) {
                o = "FEFC-" + i;
            } else {
                switch (getTypeString(o)) {
                    case "function":
                        return convertFunction(o);
                    case "string":
                        // Intentionally left blank
                    case "number":
                        // Intentionally left blank
                    case "boolean":
                        // Intentionally left blank
                    case "undefined":
                        // Intentionally left blank
                    case "null":
                        // Intentionally left blank
                    default:
                        js.Syntax.code("
                            if (o === null) {
                                // Intentionally left blank
                            } else if (o instanceof Array) {
                                return this.convertMemberFunctions(o, true);
                            } else if (o instanceof Date) {
                                // Intentionally left blank
                            } else if (o instanceof RegExp) {
                                // Intentionally left blank
                            } else if (o instanceof String) {
                                // Intentionally left blank
                            } else if (o instanceof Number) {
                                // Intentionally left blank
                            } else if (o instanceof Boolean) {
                                // Intentionally left blank
                            } else {
                                return this.convertMemberFunctions(o, false);
                            }
                        ");
                }
            }

            return o;
        }
    #else
        public function registerObjectToGlobal(k : String) {
        }

        private function addToCacheIfNotFound(o : Dynamic, ?convert : Null<Bool>, ?storeId : Null<Bool>) : Any {
            return o;
        }

        private function convertObject(o : Any) : Any {
            return o;
        }
    #end

    public function splitWork(processors : Null<Int>, f : AccessorInterface -> Any, callback : Null<Any->Any->Int->Int->Void>, whenDone : NativeVector<Any>->NativeVector<Any>->NativeVector<Int>->Int->Void, data : Any, ?cleanDivide : Null<Int>) : Void {
        if (processors == null) {
            processors = WorkerThread.getProcessors();
        }

        var start : Date = Date.now();
        var fToSend : Any = addToCacheIfNotFound(f, null, true);
        var dataToSend : Any = convertObject(data);

        if (cleanDivide != null) {
            var i : Int = processors;
            while (i > 0) {
                if ((cleanDivide / i) == Math.floor(cleanDivide / i)) {
                    processors = i;
                    break;
                }
                i--;
            }
        }

        var finished : Int = 0;
        var allData : NativeVector<Any> = new NativeVector<Any>(processors);
        var allErrors : NativeVector<Any> = new NativeVector<Any>(processors);
        var completionOrder : NativeVector<Int> = new NativeVector<Int>(processors);
        var jobId : Int = Math.floor(start.getTime()) % 100000 + Math.floor(Math.random() * 10000);
        var i : Int = 0;

        while (i < processors) {
            var worker : WorkerThread = _workers.get(i);
            var accessorToSend = #if js
                _accessorIds.get(processors - 1).get(i)
            #else
                _accessors.get(processors - 1).get(i)
            #end
            ;
            var work : Work = new Work(accessorToSend, dataToSend, fToSend, jobId);
            worker.passMessage(work);
            worker.receiveMessage(work, i, processors, 
                function (result : Any, err : Any, i : Int, processors : Int) : Void {
                    if (callback != null) {
                        callback(result, err, i, processors);
                    }
                    completionOrder.set(finished, i);
                    allErrors.set(i, err);
                    allData.set(i, result);
                    finished++;
                    if (finished == processors) {
                        var end : Date = Date.now();
                        var duration : Int = Math.floor(end.getTime() - start.getTime());
                        #if js
                            js.html.Console.log("Task Done Duration: " + duration);
                        #else
                            // TODO
                            throw "Not supported";
                        #end
                        if (whenDone != null) {
                            whenDone(allData, allErrors, completionOrder, processors);
                        }
                    }
                }
            );
            i++;
        }
    }

    public function dispose() : Void {
        var i : Int = 0;
        while (i < _workers.length()) {
            _workers.get(i).dispose();
            i++;
        }
        _workers = null;
    }

    public function isDisposed() : Bool {
        return (_workers == null);
    }

    public function wrapped() : Void {
        _wrapped++;
    }

    public function notWrapped() : Void {
        _wrapped--;
        if (_wrapped <= 0) {
            dispose();
            _wrapped = 0;
        }
    }
}