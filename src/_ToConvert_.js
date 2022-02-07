		TransitionsEnabled : true,
		DefaultToFullScreen: true,
		SingleDisplay: true,
		ClearOnHide: true,
		PublicAttributes: true,
		HeightAndWidthSame: true,
		EventsOn: true,
		AnalyticsOn: false,
		LoggingOn: false,
		ReuseEventObject: true,
		ExternalEventsOn: false,
		MouseOverOn: false,
		UseWillChange: true,
		UseAllTransform: false,










    function available(s)
    {
        var v;

        try
        {
            v = eval(s);
        }
        catch (err)
        {
            return false;
        }

        if (v === undefined || v === null)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

	function copy(o1, o2)
	{
	    if (!o2)
	    {
	        o2 = { };
	    }

	    for (var s in o1)
	    {
	        o2[s] = o1[s];
	    }

	    return o2;
	}

	function createEvent(sName)
	{
	    var e = {eventName: sName};
	    var fListeners = new Array();

	    e.addEventListener = function (f)
	    {
	        fListeners.push(f);
	    };

	    e.dispatchInner = function (e2)
	    {
	        for (var i = 0; i < fListeners.length; i++)
	        {
	            fListeners[i](e2);
	        }
	    };

	    if (document.createEvent)
	    {
	        e.dispatch = function (o)
	        {
	            if (Field.EventsOn)
	            {
	                var e2;
	                if (!Field.ReuseEventObject)
                    {
	                    e2 = document.createEvent("HTMLEvents");
	                    copy(o, e2);
	                }
	                else
	                {
	                    e2 = o;
	                }
	                e2.initEvent(sName, true, true);
	                e2.eventName = sName;
	                e.dispatchInner(e2);
	                if (Field.ExternalEventsOn)
                    {
	                    document.dispatchEvent(e2);
                    }
	            }
	        };
	    }
	    else
	    {
	        e.dispatch = function (o)
	        {
	            if (Field.EventsOn)
	            {
	                var e2;
	                if (!Field.ReuseEventObject)
                    {
	                    e2 = document.createEventObject();
	                    copy(o, e2);
	                }
	                else
	                {
	                    e2 = o;
	                }
	                e2.eventType = sName;
	                e.dispatchInner(e2);
	                if (Field.ExternalEventsOn)
	                {
	                    document.fireEvent("on" + e2.eventType, e2);
                    }
                }
	        };
	    }

	    return e;
	}


	var eScroll = createEvent("fieldScroll");
	var eDisplay = createEvent("fieldDisplay");
	var eHide = createEvent("fieldHide");
	var eShow = createEvent("fieldShow");
	var eRotate = createEvent("fieldRotate");
	var eZoom = createEvent("fieldZoom");
	var eLocationDisplay = createEvent("locationDisplay");
	var eLocationHide = createEvent("locationHide");
	var eLocationHover = createEvent("locationHover");
	var eLocationSelect = createEvent("locationSelect");
	var eSpriteDisplay = createEvent("spriteDisplay");
	var eSpriteHide = createEvent("spriteHide");
	var eSpriteHover = createEvent("spriteHover");
	var eSpriteSelect = createEvent("spriteSelect");

	var eAllEvents = [ eScroll, eDisplay, eHide, eShow, eZoom, eLocationDisplay, eLocationHide, eLocationHover, eLocationSelect, eSpriteDisplay, eSpriteHide, eSpriteHover, eSpriteSelect ];
	var eEventToReuse;

	if (document.createEvent)
	{
	    eEventToReuse = document.createEvent("HTMLEvents");
	}
	else
	{
	    eEventToReuse = document.createEventObject();
	}

	createEvent = function (sId, sValue, view)
	{
	    eEventToReuse.id = sId;
		eEventToReuse.value = sValue;
		eEventToReuse.view = view;

	    return eEventToReuse;
	}

	setTimeout(function () {
	    function f(e)
	    {
	        if (Field.AnalyticsOn)
	        {
	            ga("Field", e.eventType, e.id, e.value);
	        }
	    }

	    if (available("ga"))
	    {
	        for (var i = 0; i < eAllEvents.length; i++)
	        {
	            eAllEvents[i].addEventListener(f);
	        }
	    }
	});

	function f(e)
	{
	    if (Field.LoggingOn)
	    {
	        var s = "Field: " + e.eventName;

	        if (e.id)
	        {
	            s += ", " + e.id;
	        }

	        if (e.value)
	        {
	            s += ", " + e.value;
	        }

            console.log(s);
        }
	}

	for (var i = 0; i < eAllEvents.length; i++)
	{
	    eAllEvents[i].addEventListener(f);
	}

	f = undefined;

	function isFunction(functionToCheck)
	{
        var getType = {};
        return functionToCheck && getType.toString.call(functionToCheck) === '[object Function]';
	}

	function get(functionToCheck)
	{
	    if (isFunction(functionToCheck))
	    {
	        return functionToCheck();
	    }
	    else
	    {
            return functionToCheck;
	    }
	}

	function discardDivPlain(e)
	{
		e.parentNode.removeChild(e);
	}

	function getDivPlain()
	{
		return document.createElement("div");
	}

	function discardDivEx(e)
	{
		e.parentNode.removeChild(e);
		dDiscardedDivs.push(e);
		for (var i = 0; i < e.childNodes; i++)
		{
			var e2 = e.childNodes[i];

			if (e2.tagName === "div")
			{
				discardDiv(e2);
			}
			else
			{
				e.removeChild(e2);
			}
		}
		e.style = null;
	}

	function getDivEx()
	{
		if (dDiscardedDivs.length > 0)
		{
			return dDiscardedDivs.pop();
		}
		else
		{
			return document.createElement("div");
		}
	}

	discardDiv = discardDivEx;
	getDiv = getDivEx;

	function d(sClass, dParent)
	{
		var dDiv = getDiv();
		domUpdate.now(function () {
			dDiv.className = sClass;
		});
		if (!!dParent)
		{
			dParent.appendChild(dDiv);
		}
		return dDiv;
	}

	function v(l, s, o)
	{
		if (o !== undefined)
		{
			l[s] = o;
		}
			
		return l[s];
	}




		Decorators: {
			Abstract: function () {
				var fField = this.FieldInterface();
				var original;
				fField.decorate = function (f) {
					if (f === undefined) {
						return original;
					} else {
						original = f;
						return this;
					}
				};
				fField.largeOperation = function (f, callback, whenDone, data, cleanDivide) {
					return original.largeOperation(f, callback, whenDone, data, cleanDivide);
				};
				fField.attributeFill = function (attribute, data, callback) {
					return original.attributeFill(attribute, data, callback);
				};
				fField.clear = function () {
					return original.clear();
				};
				fField.get = function (x, y)  {
					return original.get(x, y);
				};
				fField.addSubField = function (f, x, y) {
					return original.addSubField(f, x, y);
				};
				fField.Id = function () {
					return original.Id();
				};
				fField.toString = function () {
					return original.toString();
				};
				fField.getLoop = function (x, y) {
					return original.getLoop(x, y);
				};
				fField.verticalLoop = function (x, y) {
					return original.verticalLoop(x, y);
				}
				fField.horizontalLoop = function (x, y) {
					return original.horizontalLoop(x, y);
				};
				fField.horizontalVerticalLoop = function (x, y) {
					return original.horizontalVerticalLoop(x, y);
				};
				fField.loopReset = function (x, y) {
					return original.loopReset(x, y);
				};
				fField.loopReset = function (x, y) {
					return original.loopReset(x, y);
				};
				fField.loopResetWhenDoubled = function (x, y) {
					return original.loopResetWhenDoubled(x, y);
				};
				fField.getX = function () {
					return original.getX();
				};
				fField.getY = function () {
					return original.getY();
				};
				fField.width = function () {
					return original.width();
				};
				fField.height = function () {
					return original.height();
				};
				fField.getSubfieldsForLocation = function (l, i) {
					return original.getSubfieldsForLocation(l, i);
				};
				fField.getSubfieldsForSprite = function (s, i) {
					return original.getSubfieldsForSprite(s, i);
				};
				fField.getSubfields = function () {
					return original.getSubfields();
				};
				return fField;
			},
			Filter: function () {
				var filters = new Array();
				var fField = Field.Decorators.Abstract();

				fField.addFilter = function (f) {
					filters.push(filter);
				};
				fField.removeFilter = function (f) {
					filters.splice(filters.indexOf(f), 1);
				};
				fField.clearFilters = function () {
					filters = new Array();
				};
				fField.applyFilter = function () {

				};
				function canUseAccessor(sName) {
					var accessor = fField.decorate().getDefaultAccessor();
					switch (accessor.locationAttributes.type[sName]) {
						case 0:
						case 1:
						case 2:
							return false;
						case 3:
						default:
							return true;
					}
				}
				fField.columnEqual = function (x, v, attr, ignoreCase, trim) {
					if (attr !== undefined || attr !== null) {
						if (canUseAccessor(attr)) {
							return function (accessor) {
								//accessor.





							};
						} else {
							if (trim) {
								if (ignoreCase) {
									return function () {
										fField.decorate().get(x, y).Attribute(attr).trim().toUpperCase() == v.trim().toUpperCase();
									}; 
								} else {
									return function () {
										fField.decorate().get(x, y).Attribute(attr).trim() == v.trim();
									}; 
								}
							} else {
								if (ignoreCase) {
									return function () {
										fField.decorate().get(x, y).Attribute(attr).toUpperCase() == v.toUpperCase();
									}; 
								} else {
									return function () {
										fField.decorate().get(x, y).Attribute(attr) == v;
									}; 
								}
							}
						}
					} else {
						if (trim) {
							if (ignoreCase) {
								return function () {
									fField.decorate().get(x, y).value().trim().toUpperCase() == v.trim().toUpperCase();
								}; 
							} else {
								return function () {
									fField.decorate().get(x, y).value().trim() == v.trim();
								}; 
							}
						} else {
							if (ignoreCase) {
								return function () {
									fField.decorate().get(x, y).value().toUpperCase() == v.toUpperCase();
								}; 
							} else {
								return function () {
									fField.decorate().get(x, y).value() == v;
								}; 
							}
						}
					}
				};
				fField.not = function (f) {

				};
				fField.and = function (a, b) {

				};
				fField.or = function (a, b) {

				};
				fField.xor = function (a, b) {

				};				
				fField.columnContains = function (k, v, ignoreCase, trim) {
				};
				fField.columnLessThan = function (k, v) {

				};
				fField.columnGreaterThan = function (k, v) {

				};
				fField.columnLessThanOrEqualTo = function (k, v) {

				};
				fField.columnGreaterThanOrEqualTo = function (k, v) {

				};				
			},
		},

		InventoryView: function (iInventory)
		{
			var iv = Field.FieldView(iInventory);
			return iv;
		},

		MapPreview: function (mMap)
		{
			var mv = Field.FieldView(mMap);
			return mv;
		},		

		MapView: function (mMap)
		{
			var mv = Field.FieldView(mMap);
			return mv;
		},

		MenuView: function (mMenu)
		{
			var mv = Field.FieldView(mMenu);
			return mv;
		},

		DashboardView: function (dDashboard)
		{

		},

		FileSystemView: function (fsFileSystem)
		{
		},

		SpreadsheetView: function (ssSheet)
		{
		},

		DatabaseView: function (dbData)
		{
		},

		DemoField: function ()
		{
			// REWRITE
			var sSprite = Field.Sprite();
			var fField = this.Field();

			fField.fill(0, 0, 50, 50);
			fField.addSprite(sSprite);
			sSprite.location(fField.get(3, 5));

			return fField;
			// REWRITE			
		},

		StartDemo: function ()
		{
		    var fv = this.FieldView(this.DemoField(), 10, 10, 2, document.body, true);
			fv.fullScreen();
			fv.StartDefaultListeners();
		},

		PanelView: function (e)
		{
		    var f = this.Convert.ArrayToField(e);
		    var fv = this.FieldView(f, 1, 1, 0, null, false);

		    return fv;
		},

		HorizontalToolbar: function (f, iSize, iPreload)
        {
		    var fv = this.FieldView(f, iSize, 1, iPreload, null, false);
		    return fv;
        },

        VerticalToolbar: function (f, iSize, iPreload)
        {
            var fv = this.FieldView(f, 1, iSize, iPreload, null, false);
            return fv;
        },

        SingleViewer: function (f, iPreload)
        {
            var fv = this.FieldView(f, 1, 1, iPreload, null, false);
            return fv;
        },

        Dashboard: function (f)
        {

        },

		Convert:
		{
			ArrayToField: function (oValues, fLocation)
			{

			},

			// TODO - Optimized/Restricted version and non-optimized version

			FieldToArray: function (fField, bUseActual)
			{
				
			},



			ValueToLocation: function (oValue)
			{
			    var lLocation = Field.LocationTextValue();

			    lLocation.value(oValue);

			    return lLocation;
			},

			LocationToValue: function (lLocation, bUseActual)
			{
				if (bUseActual)
				{
					if (!!lLocation.actualValue)
					{
						return lLocation.actualValue();
					}
					else if (!!lLocation.value)
					{
						return lLocation.value();
					}
					else
					{
						// TODO
					}
				}
				else
				{
					if (!!lLocation.value)
					{
						return lLocation.value();
					}
					else if (!!lLocation.actualValue)
					{
						return lLocation.actualValue();
					}
					else
					{
						// TODO
					}
				}
			},

			CSVToField: function (sCSV, fLocation)
			{
				if (!(sTable.indexOf(",") > 0))
				{
					var e = document.getElementById(sCSV);
					if (!!e.value)
					{
						sCSV= e.value;
					}
					else if (!!e.textContent)
					{
						sCSV = e.textContent;
					}
					else if (!!e.innerHtml)
					{
						sCSV = e.innerHtml;
					}
				}

				sCSV = sCSV.replace(/(\r\n|\n|\r)/gm, "\n").split("\n");
				
				for (var i = 0; i < sCSV.length; i++)
				{
					sCSV[i] = sCSV[i].split(",");
				}

				return Field.Convert.ArrayToField(sCSV, fLocation);
			},

			FieldToCSV: function (fField, bUseActual, sOutput)
			{
				var oValues = Field.Convert.FieldToArray(fField, bUseActual);
				var sCSV = "";

				for (var j = 0; j < oValues.length; j++)
				{
					var oRow = oValues[j];

					for (var i = 0; i < oRow.length; i++)
					{
						sCSV += oRow[i].toString() + ",";
					}

					sCSV += "\n";
				}

				return Output(sCSV, sOutput);
			},

			JSONToField: function (sJSON, fLocation, fOption, iColumns)
			{
			    return Field.Convert.DictionaryToField(JSON.parse(sJSON), fLocation, fOptions, iColumns);
			},

			FieldToJSON: function (fField, bUseActual, sOutput)
			{
				Field.Convert.FieldToArray(fField, bUseActual);
			},

			XMLToField: function (sJSON, fLocation)
			{

			},

			FieldToXML: function (fField, bUseActual)
			{
				Field.Convert.FieldToArray(fField, bUseActual);
			},

			TableToField: function (sTable, fLocation)
			{
				if (!(sTable.trim().toLowerCase().indexOf("<table>") === 0))
				{
					var e = document.getElementById(sTable);
					if (!!e.innerHtml)
					{
						sTable = e.innerHtml;
					}
					else if (!!e.value)
					{
						sTable = e.value;
					}
					else if (!!e.textContent)
					{
						sTable = e.textContent;
					}
				}

				sTable = sTable.split("(?<table>")[0];
				sTable = sTable.split("(?<tr>");
				
				for (var i = 0; i < sTable.length; i++)
				{
					sTable[i] = sTable[i].split("(?<td>");
				}

				return Field.Convert.ArrayToField(sTable, fLocation);
			},

			FieldToTable: function (fField, bUseActual, sOutput)
			{
				Field.Convert.FieldToArray(fField, bUseActual);
			},

			ImageListToField: function (o, sType, fLocation)
			{
			    if (!sType)
			    {
			        sType = "Image";
			    }

			    if (!fLocation)
			    {
			        fLocation = Field.Convert.ImageToLocation;
			    }

			    var f = Field.Convert.DocumentListToField(o, sType, fLocation);

			    return f;
			},

			DocumentListToField: function (o, sType, fLocation)
			{
			    if (!sType)
			    {
			        sType = "Document";
			    }

			    if (!fLocation)
			    {
			        fLocation = Field.Convert.DocumentToLocation;
			    }

			    var f = Field.FieldStandard();
			    var r = new Array();
			    f.push(r);

			    for (var i = 0; i < o.length; i++)
			    {
			        var sName = sType + (i + 1).toString();
			        var l = fLocation(o[i], sName);
			        r.push(l);
			    }

			    return f;
			}
		},

		DocumentToField: function (o, sType, fGetPageCount, fFindPage, fLocation)
		{
		    var sInternalType = Field.Convert.DetermineDocumentType(o);
		    var f = Field.FieldStandard();
		    fGetPageCount(o, function (o2, iLength) {
		        var r = new Array();
		        f.push(r);

		        for (var i = 0; i < iLength; i++) {
		            fFindPage(o2, i, function (o3, i2) {
		                r[i2] = fLocation(o3);
		            });
		        }
		    });
            
		    return f;
		},

		ImageToLocation: function (o, sName)
		{

		},

		DocumentToLocation: function (o, sName)
		{

		},

		DetermineDocumentType: function (o)
		{
		    var s = o.toString();
		    var sL = s.toLowerCase();

            function endsWith(s1, s2)
		    {
                var i = s1.indexOf(s2);

                if (i >= 0)
                {
                    i += s2.length;

                    if (i == s1.length)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                else
                {
                    return false;
                }
		    }

		    if (s.indexOf("%PDF-") >= 0)
		    {
		        return "pdf";
		    }
		    else if (sL.indexOf("<html>") >= 0)
		    {
		        return "html";
		    }
		    else
		    {
		        var sP = sL.split("?")[0];
		        if (endsWith(sP, "/") >= 0)
		        {
		            return "src-html";
		        }
		        else
		        {
		            sP = sP.split(".");
		            sP = sP[sP.length - 1];
		            switch (sP)
		            {
		                case "htm":
		                case "html":
                        case "asp":
		                case "aspx":
		                case "php":
		                case "jsp":
		                    return "src-html";
		                case "pdf":
		                    return "src-pdf";
		            }
		        }
            }
		},


	Field.LocationStateDisplayed = Field.LocationStateDisplayed();
	Field.LocationStateHidden = Field.LocationStateHidden();
	Field.Events = {};
	Field.RecommendedSettings = function () {
		var mem = navigator.deviceMemory;
		if (mem <= 1) {
//extra-small
		} else if (mem <= 2) {
//very-small
		} else if (mem <= 4) {
//small
		} else if (mem <= 8) {
//regular
		}
	};
	Field.Set

	for (var i = 0; i < eAllEvents.length; i++)
	{
	    var e = eAllEvents[i];
	    Field.Events[e.eventName] = e;
	}

    /*
	var feField = document.registerElement('fe-field', { prototype: null });
	var feToolbar = document.registerElement('fe-toolbar', { prototype: null });
	var feVerticalToolbar = document.registerElement('fe-vertical-toolbar', { prototype: null });
	var feHorizontalToolbar = document.registerElement('fe-horizontal-toolbar', { prototype: null });
	var feDashboard = document.registerElement('fe-dashboard', { prototype: null });
	var feDatabase = document.registerElement('fe-database', { prototype: null });
	var feFileSystem = document.registerElement('fe-filesystem', { prototype: null });
	var feInventory = document.registerElement('fe-inventory', { prototype: null });
	var feMap = document.registerElement('fe-map', { prototype: null });
	var feMapPreview = document.registerElement('fe-map-preview', { prototype: null });
	var fePanel = document.registerElement('fe-map-panel', { prototype: null });
	var feSingle = document.registerElement('fe-map-single', { prototype: null });
	var feSpreadSheet = document.registerElement('fe-spread-sheet', { prototype: null });
    */
	
	if (available("window"))
	{
		window.Field = Field;
	}
