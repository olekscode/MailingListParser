Class {
	#name : #MailingListParser,
	#superclass : #Object,
	#instVars : [
		'mailingListUrl',
		'mailingListPrefix'
	],
	#category : #MailingListParser
}

{ #category : #'as yet unclassified' }
MailingListParser class >> forPharoUsers [
	^ self new initializePharoUsers.
]

{ #category : #parsing }
MailingListParser >> initializePharoUsers [
	mailingListUrl := 'http://lists.pharo.org/pipermail/pharo-users_lists.pharo.org'.
	mailingListPrefix := '[Pharo-users]'.
	^ self
]

{ #category : #parsing }
MailingListParser >> letterUrlFromMonth: aYearMonthString fileName: aLetterFileName [
	^ self mailingListUrl, '/', aYearMonthString, '/', aLetterFileName.
]

{ #category : #parsing }
MailingListParser >> letterUrlsSortedByDateFromMonth: aYearMonthString [
	^ self mailingListUrl, '/', aYearMonthString, '/date.html'.
]

{ #category : #parsing }
MailingListParser >> mailingListPrefix [
	^ mailingListPrefix
]

{ #category : #parsing }
MailingListParser >> mailingListUrl [
	^ mailingListUrl 
]

{ #category : #parsing }
MailingListParser >> parseLetterUrlsFromMonth: aYearMonthString [
	| url ingredientsXML |
	
	url := self letterUrlsSortedByDateFromMonth: aYearMonthString.
	ingredientsXML := XMLHTMLParser parseURL: url.
	
	^ (ingredientsXML xPath: '//li//a')
		select: [ :each | each nodes first beginsWith: self mailingListPrefix ]
		thenCollect: [ :each | each attributeAt: 'href' ].
]

{ #category : #parsing }
MailingListParser >> parseLettersFromMonth: aYearMonthString [
	| letterUrls |
	
	letterUrls := self parseLetterUrlsFromMonth: aYearMonthString.
	^ self parseLettersFromUrls: letterUrls fromMonth: aYearMonthString.
]

{ #category : #parsing }
MailingListParser >> parseLettersFromUrls: anArrayOfLetterUrls fromMonth: aYearMonthString [
	| letters letterParser url |
	letters := OrderedCollection new.
	letterParser := MailingListLetterParser new.

	anArrayOfLetterUrls do: [ :each |
		url := self letterUrlFromMonth: aYearMonthString fileName: each.
		letters add: (letterParser parseLetterFromUrl: url).
	] displayingProgress: [ :each | 'Parsing letters from ', aYearMonthString ].

	^ letters
]
