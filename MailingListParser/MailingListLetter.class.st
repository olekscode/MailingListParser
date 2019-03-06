Class {
	#name : #MailingListLetter,
	#superclass : #Object,
	#instVars : [
		'id',
		'datetime',
		'title',
		'authorName',
		'authorEmail',
		'contents'
	],
	#category : #MailingListParser
}

{ #category : #accessing }
MailingListLetter >> authorEmail [
	^ authorEmail
]

{ #category : #accessing }
MailingListLetter >> authorEmail: anObject [
	authorEmail := anObject
]

{ #category : #accessing }
MailingListLetter >> authorName [
	^ authorName
]

{ #category : #accessing }
MailingListLetter >> authorName: anObject [
	authorName := anObject
]

{ #category : #accessing }
MailingListLetter >> contents [
	^ contents
]

{ #category : #accessing }
MailingListLetter >> contents: anObject [
	contents := anObject
]

{ #category : #accessing }
MailingListLetter >> datetime [
	^ datetime
]

{ #category : #accessing }
MailingListLetter >> datetime: anObject [
	datetime := anObject
]

{ #category : #accessing }
MailingListLetter >> id [
	^ id
]

{ #category : #accessing }
MailingListLetter >> id: anObject [
	id := anObject
]

{ #category : #accessing }
MailingListLetter >> removeQuotations [
	| regex |
	regex := 'On (.+), (.+) wrote\:|(</i>)?>.+|</i>|' asRegex.
	contents := contents lines reject: [ :each | regex matches: each ].
	contents := contents inject: '' into: [ :concat :each | concat, Character cr asString, each ].
]

{ #category : #accessing }
MailingListLetter >> removeTabsAndNewlines [
	contents := contents copyReplaceAll: Character tab asString with: ' '.
	contents := contents copyReplaceAll: Character cr asString with: ' '.
	contents := contents copyReplaceAll: Character lf asString with: ' '.
]

{ #category : #accessing }
MailingListLetter >> title [
	^ title
]

{ #category : #accessing }
MailingListLetter >> title: anObject [
	title := anObject
]
