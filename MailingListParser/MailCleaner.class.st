Class {
	#name : #MailCleaner,
	#superclass : #Object,
	#category : #MailingListParser
}

{ #category : #'as yet unclassified' }
MailCleaner >> cleanContents: someContents [

	^ self cleanText: someContents
]

{ #category : #'as yet unclassified' }
MailCleaner >> cleanText: aText [

	^ aText
]

{ #category : #'as yet unclassified' }
MailCleaner >> cleanTitle: aTitle [

	^ self cleanText: aTitle
]
