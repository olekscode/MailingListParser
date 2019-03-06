Class {
	#name : #MailingListCsvWriter,
	#superclass : #Object,
	#category : #MailingListParser
}

{ #category : #writing }
MailingListCsvWriter >> columnNames [ 
	^ #(id datetime title authorName authorEmail contents)
]

{ #category : #writing }
MailingListCsvWriter >> lettersAsArrayOfArrays: anArrayOfLetters [
	^ anArrayOfLetters collect: [ :each |
		each removeQuotations.
		each removeTabsAndNewlines.
		
		{
			each id .
			each datetime .
			each title .
			each authorName .
			each authorEmail .
			each contents
		} ]
]

{ #category : #writing }
MailingListCsvWriter >> writeLetters: anArrayOfLetters toFile: aFileReference [
	| letters writer |
	letters := self lettersAsArrayOfArrays: anArrayOfLetters.
	
	writer := NeoCSVWriter on: aFileReference writeStream.
	writer separator: Character tab.
	writer nextPutAll: letters.
]
