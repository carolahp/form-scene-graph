Extension { #name : #Rectangle }

{ #category : #'*FormSceneGraph-Core' }
Rectangle class >> empty [
	^ self basicNew setEmpty
]

{ #category : #'*FormSceneGraph-Core' }
Rectangle class >> fullSpace [
	^ self basicNew setFullSpace
]

{ #category : #'*FormSceneGraph-Core' }
Rectangle >> isEmpty [
	^ origin x > corner x or: [ origin y > corner y ]
]

{ #category : #'*FormSceneGraph-Core' }
Rectangle >> mergeAllowingEmpty: other [
	^ self class basicNew setOrigin: (origin min: other origin) corner: (corner max: other corner)
]

{ #category : #'*FormSceneGraph-Core' }
Rectangle >> random [

	| newOrigin newExtent |
	
	newOrigin := self extent random.
	newExtent := self extent random.
	
	^ Rectangle origin: newOrigin extent: newExtent
]

{ #category : #'*FormSceneGraph-Core' }
Rectangle >> setEmpty [
	origin := Float infinity @ Float infinity.
	corner := Float negativeInfinity @ Float negativeInfinity.
]

{ #category : #'*FormSceneGraph-Core' }
Rectangle >> setFullSpace [
	origin := Float negativeInfinity @ Float negativeInfinity.
	corner := Float infinity @ Float infinity.
]

{ #category : #'*FormSceneGraph-Core' }
Rectangle >> setOrigin: newOrigin corner: newCorner [
	origin := newOrigin.
	corner := newCorner.
]
