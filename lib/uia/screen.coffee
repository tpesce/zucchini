class Screen
  constructor: (@name) ->
    if @anchor then target.waitForElement @anchor()
  
  elements: {}                           

  element: (name,context) ->
    puts "Need to find "+name
#    actionSheet = app.actionSheet()
#    context = if isNullElement actionSheet || !actionSheet.checkIsValid() then view else actionSheet
    puts "Using context "+context
    element = if @elements[name] then @elements[name]() else context.$(name)
    throw "Element '#{name}' not defined for the screen '#{@name}'" unless element
    element

  actions :
    'Take a screenshot$' : ->
      target.delay(0.1)
      target.captureScreenWithName(@name)

    'Take a screenshot named "([^"]*)"$' : (name) ->
      target.delay(0.1)
      target.captureScreenWithName(name)

    'Tap "([^"]*)"$' : (element) ->
      @element(element,view).tap()

    'Choose "([^"]*)"$' : (actionSheetOptionName) ->
      @element(actionSheetOptionName,app.actionSheet()).tap()

    'Wait for "([^"]*)" second[s]*$' : (seconds) ->
      target.delay(seconds)

    'Confirm "([^"]*)"$' : (element) ->
      @actions['Tap "([^"]*)"$'].bind(this)(element)

    'Type "([^"]*)" in the "([^"]*)" field$': (text,element) ->
      @element(element,view).tap()
      app.keyboard().typeString text

    'Clear the "([^"]*)" field$': (elementName) ->
      @element(elementName,view).setValue ""

    'Dismiss the alert' : ->
      alert = app.alert()
      throw "No alert found to dismiss on screen '#{@name}'" if isNullElement alert
      alert.defaultButton().tap()
