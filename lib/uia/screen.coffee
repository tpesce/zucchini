class Screen
  constructor: (@name) ->
    if @anchor then target.waitForElement @anchor()
  
  elements: {}                           
  actions :
    'Take a screenshot$' : ->
      target.captureScreenWithName(@name)

    'Take a screenshot named "([^"]*)"$' : (name) ->
      target.captureScreenWithName(name)

    'Tap "([^"]*)"$' : (element) ->
      throw "Element '#{element}' not defined for the screen '#{@name}'" unless @elements[element]
      @elements[element]().tap()

    'Wait for "([^"]*)" second[s]*$' : (seconds) ->
      target.delay(seconds)

    'Confirm "([^"]*)"$' : (element) ->
      @actions['Tap "([^"]*)"$'].bind(this)(element)

    'Select the date "([^"]*)"$' : (dateString) ->
      datePicker = view.pickers()[0]
      throw "No date picker available to enter the date #{dateString}" unless (not isNullElement datePicker) and datePicker.isVisible()
      dateParts = dateString.match(/^(\d{2}) (\D*) (\d{4})$/)
      throw "Date is in the wrong format. Need DD Month YYYY. Got #{dateString}" unless dateParts?
      # Set Day
      view.pickers()[0].wheels()[0].selectValue(dateParts[1])
      # Set Month
      counter = 0
      monthWheel = view.pickers()[0].wheels()[1]
      while monthWheel.value() != dateParts[2] and counter<12
          counter++
          monthWheel.tapWithOptions({tapOffset:{x:0.5, y:0.33}})
          target.delay(0.4)
      throw "Counldn't find the month #{dateParts[2]}" unless counter <12
      # Set Year
      view.pickers()[0].wheels()[2].selectValue(dateParts[3])