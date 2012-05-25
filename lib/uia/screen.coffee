class Screen
  constructor: (@name) ->
    if @anchor then target.waitForElement @anchor()
    else if @name then target.waitForElement view.elements()[@name]
  
  elements: {}                           

  element: (name,context) ->
    element = if @elements[name] then @elements[name]() else context.$(name)
    throw "Element '#{name}' not defined for the screen '#{@name}'" unless element
    element

  actions :
    'Take a screenshot$' : ->
      target.captureScreenWithName(@name)

    'Take a screenshot named "([^"]*)"$' : (name) ->
      target.captureScreenWithName(name)

    'Tap "([^"]*)"$' : (element) ->
      @element(element,view).tap()

    'Choose "([^"]*)"$' : (actionSheetOptionName) ->
      @element(actionSheetOptionName,app.actionSheet()).tap()

    'Wait for "([^"]*)" second[s]*$' : (seconds) ->
      target.delay(seconds)

    'Confirm "([^"]*)"$' : (element) ->
      @actions['Tap "([^"]*)"$'].bind(this)(element)
