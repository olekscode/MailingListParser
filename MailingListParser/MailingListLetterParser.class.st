Class {
	#name : #MailingListLetterParser,
	#superclass : #Object,
	#category : #MailingListParser
}

{ #category : #parsing }
MailingListLetterParser >> parseAuthorEmail: letterXML [
	| email |
	email := (letterXML xPath: '//a') first nodes first asString trim.
	^ email copyReplaceAll: ' at ' with: '@'.
]

{ #category : #parsing }
MailingListLetterParser >> parseAuthorName: letterXML [
	^ (letterXML xPath: '//b') first nodes first asString trim.
]

{ #category : #parsing }
MailingListLetterParser >> parseContents: letterXML [
	^ (letterXML xPath: '//pre') first nodes inject: '' into: [ :concat :each | concat, each asString ].
]

{ #category : #parsing }
MailingListLetterParser >> parseDatetime: letterXML [
	| datetimeString year |
	datetimeString := (letterXML xPath: '//i') first nodes first asString.
	
	"Copy year. We will remove it from the end and add it at the beginning"
	year := datetimeString copyFrom: datetimeString size - 3 to: datetimeString size.
	
	"Remove weekday and year"
	datetimeString := datetimeString copyFrom: 4 to: datetimeString size - 5.

	"Add year to the beginning"
	datetimeString := year, datetimeString.

	"Replace timezone code with numeric indicator"
	datetimeString := datetimeString copyReplaceAll: 'EST' with: '-05.00'.

	^ datetimeString asDateAndTime.
]

{ #category : #parsing }
MailingListLetterParser >> parseId: aUrl [
	| from to |
	from := (aUrl findLastOccurrenceOfString: '/' startingAt: 1) + 1. 
	to := (aUrl findLastOccurrenceOfString: '.' startingAt: 1) - 1. 
	^ aUrl copyFrom: from to: to.
]

{ #category : #parsing }
MailingListLetterParser >> parseLetterFromUrl: aUrl [
	| letterXML |
	letterXML := XMLHTMLParser parseURL: aUrl.
	
	^ MailingListLetter new
		id: (self parseId: aUrl);
		datetime: (self parseDatetime: letterXML);
		title: (self parseTitle: letterXML);
		authorName: (self parseAuthorName: letterXML);
		authorEmail: (self parseAuthorEmail: letterXML);
		contents: (self parseContents: letterXML);
		yourself.
]

{ #category : #parsing }
MailingListLetterParser >> parseTitle: letterXML [
	^ (letterXML xPath: '//title') first nodes first asString trim.
]
