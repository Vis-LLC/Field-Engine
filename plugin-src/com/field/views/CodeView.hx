/*
    Copyright (C) 2020-2023 Vis LLC - All Rights Reserved

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
import com.sdtk.calendar.CalendarInvite;

@:expose
@:nativeGen
class CodeView extends com.field.views.AbstractView {
    private var _language : String;
    private var _hardCodeResult : Bool;
    private var _result : Dynamic;
    private var _resultFormat : String;
    private var _executor : com.sdtk.api.ExecutorAPI;
    private var _reader : com.sdtk.table.DataTableReader;
    private var _hardCodeValues : Bool;
    private var _values : Map<String, String>;
    private var _code : String;
    private var _source : String;
    private var _codeElement : com.field.renderers.Element;
    private var _resultElement : com.field.views.FieldView;

    private static function withDefault(v : Any, d : Any) : Any {
        if (v == null) {
            return d;
        } else {
            return v;
        }        
    }

    private function new(options : CodeViewOptions, options2 : FieldViewOptions) {
        super();
        var fo : NativeStringMap<Any> = options.toMap();
        var fo2 : NativeStringMap<Any> = options2.toMap();
        _code = cast fo.get("code");
        _language = cast fo.get("language");
        _result = cast fo.get("result");
        _hardCodeResult = (_result != null);
        _resultFormat = cast fo.get("resultFormat");
        _values = cast fo.get("values");
        _hardCodeValues = (_values != null);
        if (_values == null) {
            _values = new Map<String, String>();
        }
        if (com.sdtk.puller.Puller.validSource(_code)) {
            com.sdtk.puller.Puller.pullAsString(_code, function (result : String) : Void {
                _code = result;
                createElements();
                appendChild(cast fo.get("parent"), _element);
                refresh();
            });
        } else {
            createElements();
            appendChild(cast fo.get("parent"), _element);
            refresh();
        }
    }

    private function createElements() : Void {
        _element = createWrapper();
        _codeElement = createTableForCode(_code.split("\n"));
        appendChild(_element, _codeElement);
    }

    private function createWrapper() : com.field.renderers.Element {
        var wrapper = createElement();
        setStyle(wrapper, getStyleFor("code_view"));
        return wrapper;
    }

    private function createTableForCode(code : Array<String>) : com.field.renderers.Element {
        #if js
            var executor : com.sdtk.api.ExecutorAPI = null;
            switch (_language) {
                case "javascript", "js":
                    executor = com.sdtk.api.JSAPI.instance();
                case "sql":
                    executor = com.sdtk.api.SQLAPI.instance();
                case "python", "py":
                    executor = com.sdtk.api.PythonAPI.instance();
            }
            if (executor != null && executor.keywords() != null) {
                for (keyword in executor.keywords()) {
                    var search : EReg;
                    if (executor.keywordsAreCaseSensitive()) {
                        search = new EReg("\\b" + keyword + "\\b", "g");
                    } else {
                        search = new EReg("\\b" + keyword + "\\b", "gi");
                    }
                    var i : Int = 0;
                    for (line in code) {
                        code[i] = search.map(line, function (reg : EReg) : String { return "<span class=\"keyword\">" + keyword + "</span>"; });
                        i++;
                    }
                }
            }
            var tableLines = js.Browser.document.createElement("table");
            var tbodyLines = js.Browser.document.createElement("tbody");
            var tableCode = js.Browser.document.createElement("table");
            var tbodyCode = js.Browser.document.createElement("tbody");
            var counter : Int = 1;
            while (StringTools.trim(code[0]).length <= 0) {
                code.shift();
            }
            while (StringTools.trim(code[code.length - 1]).length <= 0) {
                code.pop();
            }
            for (line in code) {
                var tr = js.Browser.document.createElement("tr");
                var td = js.Browser.document.createElement("td");
                td.innerHTML = "" + counter;
                tr.appendChild(td);
                tbodyLines.appendChild(tr);
                tr = js.Browser.document.createElement("tr");
                td = js.Browser.document.createElement("td");
                td.innerHTML = line;
                tr.appendChild(td);
                tbodyCode.appendChild(tr);
                counter++;
            }
            tableCode.appendChild(tbodyCode);
            tableLines.appendChild(tbodyLines);
            var table = js.Browser.document.createElement("table");
            var tbody = js.Browser.document.createElement("tbody");
            table.appendChild(tbody);
            {
                var tr = js.Browser.document.createElement("tr");
                var td = js.Browser.document.createElement("td");
                td.appendChild(tableLines);
                td.className = "codeNumbers";
                tr.appendChild(td);
                td = js.Browser.document.createElement("td");
                td.appendChild(tableCode);
                td.className = "codeLines";
                tr.appendChild(td);                
                tbody.appendChild(tr);
            }
            table.className = "code";
            return cast table;
        #else
            return null;
        #end
    }

    private function createResultElement() : com.field.views.FieldView {
        var writer = com.field.sdtk.FieldWriter.writeToExpandableField(null);
        var field = writer.getField();
        _reader.convertTo(writer);
        var view = com.field.views.FieldView.options()
            .field(field)
            .parent(_element)
            .tileWidth(field.width())
            .tileHeight(field.height())
            .tileBuffer(0)
            .show(true)
            .execute();
        writer.dispose();
        if (_resultElement != null) {
            // TODO
        }
        appendChild(_element, view.toElement());
        return view;
    }

    public static function options() : CodeViewOptions {
        return new CodeViewOptions();
    }    

    public static function create(options : CodeViewOptions, options2 : FieldViewOptions) : CodeView {
        return new CodeView(options, options2);
    }

    public function refresh() {
        var reader : com.sdtk.std.Reader = null;
        var rowReader : com.sdtk.table.DataTableRowReader = null;
        if (!_hardCodeResult) {
            _reader = null;
            _executor = null;
            switch (_language) {
                case "csv", "psv", "tsv", "json", "ini", "properties", "splunk":
                    reader = new com.sdtk.std.StringReader(_code);
            }
            switch (_language) {
                case "sql":
                    _executor = com.sdtk.api.SQLAPI.instance();
                case "javascript", "js":
                    _executor = com.sdtk.api.JSAPI.instance();
                case "python", "py":
                    _executor = com.sdtk.api.PythonAPI.instance();
                case "csv":
                    _reader = com.sdtk.table.DelimitedReader.createCSVReader(reader);
                case "psv":
                    _reader = com.sdtk.table.DelimitedReader.createPSVReader(reader);
                case "tsv":
                    _reader = com.sdtk.table.DelimitedReader.createTSVReader(reader);
                case "json":
                    _reader = com.sdtk.table.KeyValueReader.createJSONReader(reader);
                case "ini":
                    _reader = com.sdtk.table.KeyValueReader.createINIReader(reader);
                case "properties":
                    _reader = com.sdtk.table.KeyValueReader.createPropertiesReader(reader);
                case "splunk":
                    _reader = com.sdtk.table.KeyValueReader.createSplunkReader(reader);

                // TODO - Add others
                //case "xml":
                //    _reader = com.sdtk.table.KeyValueReader.createJSONReader(reader);

            }
            if (_executor != null) {
                _executor.execute(_code, _values, function (result : Dynamic) : Void {
                    if (result == null) {

                    } else {
                        switch (_resultFormat) {
                            case "csv", "psv", "tsv", "json", "ini", "properties", "splunk":
                                reader = new com.sdtk.std.StringReader(cast result);
                        }
                        switch (_resultFormat) {
                            case "csv":
                                _reader = com.sdtk.table.DelimitedReader.createCSVReader(reader);
                            case "psv":
                                _reader = com.sdtk.table.DelimitedReader.createPSVReader(reader);
                            case "tsv":
                                _reader = com.sdtk.table.DelimitedReader.createTSVReader(reader);
                            case "json":
                                _reader = com.sdtk.table.KeyValueReader.createJSONReader(reader);
                            case "ini":
                                _reader = com.sdtk.table.KeyValueReader.createINIReader(reader);
                            case "properties":
                                _reader = com.sdtk.table.KeyValueReader.createPropertiesReader(reader);
                            case "splunk":
                                _reader = com.sdtk.table.KeyValueReader.createSplunkReader(reader);
                            case "map":
                                rowReader = com.sdtk.table.ObjectRowReader.readWholeObject(result);
                            case "array":
                                rowReader = com.sdtk.table.ArrayRowReader.readWholeArray(cast result);
                            case "object":
                                rowReader = com.sdtk.table.MapRowReader.readWholeMap(com.sdtk.std.Normalize.nativeToHaxe(result));
                            default:
                                switch (_language) {
                                    case "sql", "python", "js", "javascript":
                                        _reader = cast result;
                                }
                            // TODO - Add others
                            //case "xml":
                            //    _reader = com.sdtk.table.KeyValueReader.createJSONReader(reader);

                        }
                        if (rowReader != null) {
                            _reader = rowReader.eachEntryToRow();
                        }
                        if (_reader != null) {
                            _resultElement = createResultElement();
                        }
                    }   
                });
            } else {
                _resultElement = createResultElement();
            }
        }
    }

    public static function register() : Void {
        com.field.replacement.Global.instance().register("field-code", function (e : Dynamic, header : NativeVector<NativeVector<Any>>, rows : NativeVector<NativeVector<Any>>) : Void {
            var options = com.field.views.CodeView.options();
            if (e.getAttribute("language") != null) {
                options.language(e.getAttribute("language"));
            }
            if (e.getAttribute("result") != null) {
                options.result(e.getAttribute("result"));
            }
            if (e.getAttribute("resultFormat") != null) {
                options.resultFormat(e.getAttribute("resultFormat"));
            } 
            if (e.getAttribute("values") != null) {
                options.values(e.getAttribute("values") == "true");
            }
            if (e.id != null && e.id != "") {
                options.id(e.id);
            }
            options.code(e.textContent);
            options
                .parent(e.parentElement)
                .show(true);
            var finish = function () : Void {
                var view = options.execute();
                e.replaceWith(view.toElement());    
            };
            #if js
                js.Syntax.code("setTimeout({0})", finish);
            #else
                finish();
            #end
        });        
    }
}
#end