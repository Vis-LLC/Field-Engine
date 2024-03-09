package com.field.util;

@:nativeGen
class SimpleApp extends com.field.renderers.RendererAccessor {
    private static var _instances : Array<SimpleApp> = new Array<SimpleApp>();
    private var _views : Map<String, Dynamic> = new Map<String, Dynamic>();

    private function new(?add:Bool=true) {
        super();
        if (add) {
            _instances.push(this);
        }
    }

    private static function isSubClass(clazz:Dynamic, superClazz:Class<Dynamic>) : Bool {
        try {
            var superClassName : String = Type.getClassName(superClazz);
            var className : String = Type.getClassName(clazz);
            if (className == superClassName) {
                return true;
            } else if (className == "Dynamic") {
                return false;
            } else {
                return isSubClass(Type.getSuperClass(clazz), superClazz);
            }
        } catch (ex : Any) {
        }
        return false;
    }

    private static function loadInstancesOf(clazz:Class<Dynamic>) : Void {
        var classes : Array<Dynamic> = new Array<Dynamic>();
        var dontSearch : Array<String> = ["field", "sdtk"];
        #if js
            var packages : Array<Dynamic> = new Array<Dynamic>();
            {
                var value : Dynamic = cast js.Syntax.code("com");
                for (k in Reflect.fields(value)) {
                    var field = Reflect.field(value, k);
                    if (dontSearch.indexOf(k) < 0 && Reflect.isObject(field)) {
                        packages.push(field);
                    }
                }
            }
            while (packages.length > 0) {
                var packagesPrep : Array<Dynamic> = new Array<Dynamic>();
                for (value in packages) {
                    for (name in Reflect.fields(value)) {
                        var field = Reflect.field(value, name);
                        if (cast js.Syntax.code("!!({0}.__super__)", field)) {
                            if (isSubClass(field, clazz)) {
                                classes.push(field);
                            }
                        } else {
                            packagesPrep.push(field);
                        }                            
                    }
                }
                packages = packagesPrep;
            }
        #else
            // TODO
        #end

        if (classes.length > 0) {
            for (clazz in classes) {
                Type.createInstance(clazz, []);
            }
        }
    }

    #if JS_BROWSER
        private static function checkForModule(name : String, tagType : String, tagValue : String, tagValue2 : String) : Void {
            var tags = js.Browser.document.getElementsByTagName(tagType);
            for (tag in tags) {
                switch (tagType) {
                    case "link":
                        var link : js.html.LinkElement = cast tag;
                        if (link.rel.indexOf(tagValue) >= 0 && link.href.indexOf(tagValue2) >= 0) {
                            return;
                        }
                    case "script":
                        var script : js.html.ScriptElement = cast tag;
                        if (script.src.indexOf(tagValue) >= 0) {
                            return;
                        }
                }
            }
            var tag = js.Browser.document.createElement(tagType);
            switch (tagType) {
                case "link":
                    var link : js.html.LinkElement = cast tag;
                    link.rel = tagValue;
                    link.href = tagValue2;
                case "script":
                    var script : js.html.ScriptElement = cast tag;
                    script.src = tagValue;
            }
            js.Browser.document.getElementsByTagName("head")[0].appendChild(tag);
        }

        private static function checkForSheet(name:String) : Void {
            checkForModule(name, "link", "stylesheet", name);
        }

        private static function checkForScript(name:String) : Void {
            checkForModule(name, "script", name, null);
        }
    #end

    private static function initSystem() : Void {
        #if JS_BROWSER
            checkForSheet("FieldEngine.css");
            checkForSheet("FieldEngine-Defaults.css");
            checkForScript("fe-browser.js");
        #end
    }

    public static function beginLoad() : Void {
        initSystem();
        loadInstancesOf(SimpleApp);
        if (_instances.length == 1) {
            _instances[0].Load();
        }
    }

    private function Load() { }
}