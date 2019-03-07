Class {
	#name : #MailingListParser,
	#superclass : #Object,
	#instVars : [
		'mailingListUrl',
		'mailingListPrefix',
		'client',
		'pool',
		'futures'
	],
	#category : #MailingListParser
}

{ #category : #'as yet unclassified' }
MailingListParser class >> forPharoUsers [
	^ self new initializePharoUsers.
]

{ #category : #parsing }
MailingListParser >> fetchXmlFromURL: url [

	| response |
	response := self httpClient
		url: url;
		get;
		response.
	^ XMLHTMLParser parse: response contents
]

{ #category : #parsing }
MailingListParser >> httpClient [

	^ ZnClient new beOneShot
]

{ #category : #parsing }
MailingListParser >> initialize [

	super initialize.
	futures := OrderedCollection new.
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
MailingListParser >> parseLetterFromUrl: aUrl [

	| letterParser letterXML id |
	letterParser := MailingListLetterParser new.
	letterXML := self fetchXmlFromURL: aUrl.
	id := letterParser parseId: aUrl.
	^ letterParser parseLetterFromXml: letterXML andId: id
]

{ #category : #parsing }
MailingListParser >> parseLetterUrlsFromMonth: aYearMonthString [
	| url ingredientsXML |
	
	url := self letterUrlsSortedByDateFromMonth: aYearMonthString.
	ingredientsXML := self fetchXmlFromURL: url.
	
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
	| letters url |
	[
	letters := OrderedCollection new.
	anArrayOfLetterUrls do: [ :each |
		url := self letterUrlFromMonth: aYearMonthString fileName: each.
		
		self schedule: [ | letter |
			letter := self parseLetterFromUrl: url.
			letters add: letter ].
	].

	futures
		do: [ :each | each waitForCompletion: 1 minute ]
		displayingProgress: [ :each | 'Finished letters ...' ]
	
	] ensure: [ self workerPool stop ].
	^ letters
]

{ #category : #parsing }
MailingListParser >> schedule: aTask [

	futures add: (self workerPool future: aTask)
]

{ #category : #parsing }
MailingListParser >> workerPool [

	^ pool ifNil: [ 
		pool := TKTWorkerPool new.
		pool poolMaxSize: 5.
		pool start ]
]
