def getBuildPlatform():
	from sys import platform
	match platform:
		case "aix":
			return "unix"
		case "linux":
			return "unix"
		case "windows":
			return "windows"
		case "win32":
			return "windows"
		case "cygwin":
			return "unix"
		case "darwin":
			return "unix"

def getLanguageSwitch():
	import sys
	return sys.argv[1]

def getPlatformSwitch():
	import sys
	return "-D " + sys.argv[2]

buildPlatform = getBuildPlatform()
languageSwitch = getLanguageSwitch()
platformSwitch = getPlatformSwitch()

def buildPath(arr):
	global buildPlatform
	match buildPlatform:
		case "unix":
			return "/".join(arr)
		case "windows":
			return "\\".join(arr)

def mkdir(path):
	import os
	try:
		os.mkdir(buildPath(path))
	except:
		pass

def rm(path):
	import shutil
	try:
		shutil.rmtree(buildPath(path))
	except:
		pass
	import os
	try:
		os.remove(buildPath(path))
	except:
		pass
	try:
		os.unlink(buildPath(path))
	except:
		pass

def move(src, to):
	import os
	rm(to)
	os.rename(buildPath(src), buildPath(to))

def append(src, to, appending):
	with open(buildPath(to), "a" if appending else "w+") as fo:
		with open(buildPath(src), "r") as fi:
			fo.write(fi.read())
def run(program, parameters):
	import os
	print(" ".join([program] + parameters))
	os.system(" ".join([program] + parameters))

def haxe(out, src, package, defines):
	global languageSwitch
	global platformSwitch
	if defines == None:
		defines = [ ]
	for i in range(len(src)):
		src[i] = "-cp " + src[i]
	run("haxe", [languageSwitch, buildPath(["out", out])] + src + [ package, platformSwitch] + defines)

if languageSwitch != "CLEAN":
	out1 = "fe"
	if languageSwitch == "--python":
		out2 = ".py"
		appendFile = "Append_To_Beginning.py"
	elif languageSwitch == "-cs":
		out2 = ".dll"
		appendFile = None
	elif languageSwitch == "-hl":
		out2 = "-lib.hl"
		appendFile = None
	elif languageSwitch == "-java":
		out2 = ".jar"
		appendFile = None
	elif languageSwitch == "-lua":
		out2 = ".lua"
		appendFile = "Append_To_Beginning.lua"
	elif platformSwitch == "-D JS_BROWSER":
		out2 = "-browser.js"
		appendFile = "Append_To_Beginning.txt"
	elif platformSwitch == "-D JS_WSH":
		out2 = "-wsh.js"
		appendFile = "Append_To_Beginning.txt"	

	# TODO - Add Lua TI
	# TODO - Add PHP
	# TODO - Add Docs
	# TODO - Add UML

	out = out1 + out2

	print("Building Library")
	mkdir(["out"])
	rm(["out", "build.tmp"])
	rm(["out", out])
	haxe(out, ["src"], "com.field", None)
	if platformSwitch == "-D JS_BROWSER":
		haxe("fe-browser-2.js", ["src", "lib-src", "plugin-src"], "com.field", [
			"--macro \"exclude('StringTools', false)\"", "--macro \"exclude('StringBuf', false)\"", "--macro \"exclude('haxe.ds.StringMap', false)\"", "--macro \"exclude('js.Boot', false)\"", "--macro \"exclude('com.sdtk', true)\"", "--macro \"exclude('com.field', false)\"",
			"--macro \"exclude('com.field.manager', false)\"", "--macro \"exclude('com.field.navigator', false)\"", "--macro \"exclude('com.field.renderers', false)\"", "--macro \"exclude('com.field.replacement', false)\"", "--macro \"exclude('com.field.search', false)\"",
			"--macro \"exclude('com.field.tests', false)\"", "--macro \"exclude('com.field.util', false)\"", "--macro \"exclude('com.field.views.AbstractView', false)\"", "--macro \"exclude('com.field.views.CircleView', false)\"",
			"--macro \"exclude('com.field.views.CircleViewOptions', false)\"", "--macro \"exclude('com.field.views.FieldViewAbstractSpriteStubValid', false)\"", "--macro \"exclude('com.field.views.LocationViewAbstract', false)\"",
			"--macro \"exclude('com.field.views.LocationViewAllocator', false)\"", "--macro \"exclude('com.field.views.MirrorView', false)\"", "--macro \"exclude('com.field.views.MirrorViewOptions', false)\"", "--macro \"exclude('com.field.views.PyramidView', false)\"",
			"--macro \"exclude('com.field.views.PyramidViewOptions', false)\"", "--macro \"exclude('com.field.views.SplitView', false)\"", "--macro \"exclude('com.field.views.SplitViewOptions', false)\"", "--macro \"exclude('com.field.views.SpriteViewAbstract', false)\"",
			"--macro \"exclude('com.field.views.SpriteViewAllocator', false)\"", "--macro \"exclude('com.field.views.CommonSettings', false)\"", "--macro \"exclude('com.field.views.DefaultListenersOptions', false)\"", "--macro \"exclude('com.field.views.FieldView', false)\"",
			"--macro \"exclude('com.field.views.FieldViewAbstract', false)\"", "--macro \"exclude('com.field.views.FieldViewFullInterface', false)\"", "--macro \"exclude('com.field.views.FieldViewInterface', false)\"", "--macro \"exclude('com.field.views.FieldViewLayered', false)\"",
			"--macro \"exclude('com.field.views.FieldViewOptions', false)\"", "--macro \"exclude('com.field.views.FieldViewOptionsAbstract', false)\"", "--macro \"exclude('com.field.views.GamepadButtonInfo', false)\"", "--macro \"exclude('com.field.views.GamepadInfo', false)\"",
			"--macro \"exclude('com.field.views.InputSettings', false)\"", "--macro \"exclude('com.field.views.LocationView', false)\"", "--macro \"exclude('com.field.views.ScreensView', false)\"", "--macro \"exclude('com.field.views.ScreensViewOptions', false)\"",
			"--macro \"exclude('com.field.views.SpriteView', false)\"", "--macro \"exclude('com.field.views.VerticalMenuView', false)\"", "--macro \"exclude('com.field.views.VerticalMenuViewOptions', false)\"", "--macro \"exclude('com.field.views.VirtualGamepadView', false)\"",
			"--macro \"exclude('com.field.workers', false)\"", "--macro \"include('com.field.sdtk', false)\""
		])
		# "--macro \"exclude('haxe.iterators.ArrayIterator', false)\""
	if languageSwitch == "-java":
		move(["out", out, out + ".jar"], ["out", "build.tmp"])
		rm(["out", out])
	else:
		move(["out", out], ["out", "build.tmp"])
	if appendFile != None:
		append(["Append_To_Beginning.txt"], ["out", out], False)
	if platformSwitch == "-D JS_BROWSER":
		append(["src", "base64.js"], ["out", out], True)
	if appendFile == None:
		move(["out", "build.tmp"], ["out", out])
	else:
		append(["out", "build.tmp"], ["out", out], True)
	if platformSwitch == "-D JS_BROWSER":
		append(["src", "2start.js"], ["out", out], True)
		append(["out", "fe-browser-2.js"], ["out", out], True)
		append(["src", "2end.js"] , ["out", out], True)
	rm(["out", "build.tmp"])
	if platformSwitch == "-D JS_BROWSER":
		rm(["out", "fe-browser-2.js"])
else:
	rm(["out"])



