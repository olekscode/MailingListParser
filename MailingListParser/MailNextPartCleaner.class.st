Class {
	#name : #MailNextPartCleaner,
	#superclass : #MailCleaner,
	#category : #MailingListParser
}

{ #category : #'as yet unclassified' }
MailNextPartCleaner >> cleanContents: aContents [
	| regex position |
	
	regex := '.*-------------- next part --------------
An HTML attachment was scrubbed...
URL\: &lt;<A HREF=".+">.+</A>&gt;' asRegex.

	(regex matches: aContents)
		ifFalse: [ ^ aContents ].
	
	position := aContents
		findLastOccurrenceOfString: '-------------- next part --------------'
		startingAt: 1.
	
	^ (aContents first: position - 1) trimBoth.
]
