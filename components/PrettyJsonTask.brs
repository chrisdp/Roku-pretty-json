sub init()
	m.top.functionName = "runTaskThread"
end sub

sub runTaskThread()
	jsonString = m.top.input

	progress = 0
	indentSpacesNumber = 4
	dictionaryStartChar = "{"
	dictionaryEndChar = "}"
	arrayStartChar = "["
	arrayEndChar = "]"
	commaChar = ","
	colonChar = ":"
	newLineChar = Chr(10)
	carriageReturnChar = Chr(13)
	spaceChar = " "
	quoteChar = Chr(34)
	tabChar = Chr(9)
	indentLevel = 0
	tempString = ""
	parts = []

	indentString = string(indentSpacesNumber, spaceChar)
	originalLength = len(jsonString)
	stringArray = jsonString.split("")

	i = 1
	while i <= originalLength
		curChar = stringArray[i - 1]
		if curChar = quoteChar then

			indexOfClosingQuote = -1
			for lookahead = i to originalLength - 1
				lookaheadChar = stringArray[lookahead]
				if lookaheadChar = quoteChar then
					indexOfClosingQuote = lookahead
					exit for
				end if
			end for

			if indexOfClosingQuote > 0 then
				for midIndex = i - 1 to indexOfClosingQuote
					tempString += stringArray[midIndex]
				end for
				i = indexOfClosingQuote + 1
			else
				tempString += curChar
			end if
		else
			if curChar = dictionaryStartChar or curChar = arrayStartChar then
				indentLevel = indentLevel + 1
				parts.push(tempString + curChar)
				tempString = string(indentLevel, indentString)
			else if curChar = dictionaryEndChar or curChar = arrayEndChar then
				indentLevel = indentLevel - 1
				if indentLevel < 0 then
					indentLevel = 0
				end if
				parts.push(tempString)
				tempString = string(indentLevel, indentString) + curChar
			else if curChar = commaChar then
				parts.push(tempString + curChar)
				tempString = string(indentLevel, indentString)
			else if curChar = colonChar then
				tempString += curChar + spaceChar
			else if not(curChar = spaceChar or curChar = tabChar or curChar = newLineChar or curChar = carriageReturnChar) then
				tempString += curChar
			end if
		end if

		i = i + 1

		percent = cint(i / originalLength * 100)
		if percent <> progress then
			m.top.progress = percent
			progress = percent
		end if
	end while

	if tempString <> "" then parts.push(tempString)

	m.top.output = parts.join(newLineChar)
end sub
