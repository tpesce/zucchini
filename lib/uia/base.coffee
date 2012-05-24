Function::bind = (context) ->
  return this unless context
  fun = this
  ->
    fun.apply context, arguments
    
String::camelCase = ->
  @replace /([\-\ ][A-Za-z])/g, ($1) ->
    $1.toUpperCase().replace /[\-\ ]/g, ""

extend = (obj, mixin) ->
  obj[name] = method for name, method of mixin        
  obj

puts = (text) ->
  UIALogger.logMessage text

isNullElement = (element) ->
  element.toString() == "[object UIAElementNil]"

# Prevent UIA from auto handling alerts
UIATarget.onAlert = (alert) ->
	return true

target = UIATarget.localTarget()
app    = target.frontMostApp()
view   = app.mainWindow()

UIAElement.prototype.$ = (name) ->
  target.pushTimeout(0)
  elem = null
  for el in this.elements()
    puts " - Checking "+el.toString()+" "+el.name()
    elem = if el.name() == name then el else el.$(name)
    break if elem
  target.popTimeout()
  elem

target.waitForElement = (element) ->
  return  unless element
  found = false
  counter = 0
  while not found and (counter < 10)
    if element.isValid() and element.isVisible()
      found = true
      puts "Got the awaited element: #{element}"
      @delay 1
    else
      @delay 0.5
      counter++
  puts "Didn't find the element:  #{element}" unless found

screensCount = 0
target.captureScreenWithName_ = target.captureScreenWithName
target.captureScreenWithName = (screenName) ->
  screensCountText = (if (++screensCount < 10) then "0" + screensCount else screensCount)
  @captureScreenWithName_ screensCountText + "_" + screenName
                                                         
class Zucchini
  @run: (featureText) ->
    sections = featureText.trim().split(/\n\s*\n/)

    for section in sections
      lines = section.split(/\n/)

      screenMatch = lines[0].match(/.+ on the "([^"]*)" screen:$/)
      throw "Line '#{lines[0]}' doesn't define a screen context" unless screenMatch

      screenName = screenMatch[1]
      try
        screen = eval("new #{screenName.camelCase()}Screen")
      catch error
        screen = new Screen(screenName)

      for line in lines.slice(1)
         puts line
         functionFound = false
         for regExpText, func of screen.actions
            match = line.trim().match(new RegExp(regExpText))
            if match
              functionFound = true
              func.bind(screen)(match[1],match[2])
         throw "Action for line '#{line}' not defined" unless functionFound