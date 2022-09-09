"
I am a node in the scene graph. My drawn content is always a rectangle that can be drawn into an ofscreen buffer and composed into a separate scene in a separate pass. My actual drawing is implemented via a visitor which is a subclass of *FormSGVisitor*.
"
Class {
	#name : #FormSGNode,
	#superclass : #Object,
	#instVars : [
		'morph'
	],
	#classVars : [
		'EmptyRenderingFormResult'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #private }
FormSGNode class >> emptyRenderingForm [
	^ EmptyRenderingFormResult ifNil: [ EmptyRenderingFormResult := Form extent: 1@1 depth: 32 ]
]

{ #category : #testing }
FormSGNode class >> isAbstract [
	^ self == FormSGNode
]

{ #category : #printing }
FormSGNode class >> nodeTypeName [
	^ name withoutPrefix: 'FormSG'
]

{ #category : #copying }
FormSGNode >> , otherNode [
	otherNode isNullNode ifTrue: [ ^ self ].
	otherNode isContainerNode ifTrue: [ ^ otherNode copy children: { self } , otherNode children ].
	^ FormSGContainerNode new 
		morph: self morph;
		children: {self . otherNode}
]

{ #category : #visiting }
FormSGNode >> accept: aVisitor [
	^ self subclassResponsibility
]

{ #category : #enumerating }
FormSGNode >> allChildrenDo: aBlock [
	self childrenDo: [:each |
		each withAllChildrenDo: aBlock 
	]
]

{ #category : #converting }
FormSGNode >> asForm [
	^ self asFormWithBackgroundColor: Color transparent
]

{ #category : #converting }
FormSGNode >> asFormWithBackgroundColor: backgroundColor [
	| surface renderer originalOrigin |

	originalOrigin := self boundingBox origin.

	surface := FormSGAthensSurface extent: self boundingBox extent.	

	originalOrigin = (0@0) ifFalse: [ self offsetPositionBy: originalOrigin negated ].

	[	renderer := FormSGNewAthensRenderer new.
		renderer clippingRectangles: {(0@0 corner: self boundingBox extent)}.

		surface drawDuring: [ :aCanvas |
			surface clear: backgroundColor.
			renderer render: self on: aCanvas ].

		^ surface asForm ] ensure: [ self offsetPositionBy: originalOrigin ]
]

{ #category : #'accessing - bounds' }
FormSGNode >> boundingBox [
	self subclassResponsibility
]

{ #category : #accessing }
FormSGNode >> children [
	^ #()
]

{ #category : #enumerating }
FormSGNode >> childrenDo: aBlock [

]

{ #category : #private }
FormSGNode >> emptyRenderingForm [
	^ self class emptyRenderingForm
]

{ #category : #inspector }
FormSGNode >> inspectorForm [

	<inspectorPresentationOrder: 920 title: 'Form'>		
	^ SpMorphPresenter new
			morph: self asForm asMorph;
			yourself	
]

{ #category : #inspector }
FormSGNode >> inspectorTree [

	<inspectorPresentationOrder: 910 title: 'Tree'>	

	| presenter |
	
	^ (presenter := SpTreePresenter new)
		beResizable;
		items: { self };
		children: [ :aNode | aNode children ];
		display: [ :aNode | aNode asString ];
		contextMenu: (SpMenuPresenter new 
			addItem: [ :item | 
				item
					name: 'Browse';
					action: [ presenter selectedItem browse ] ];
			addItem: [ :item | 
				item
					name: 'Expand';
					action: [ presenter expandSubNodes: presenter selection selectedPath ] ];
			yourself);
		yourself
]

{ #category : #testing }
FormSGNode >> isAthensNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isBorderNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isCachingSubSceneNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isClipNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isColorRectangleNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isContainerNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isGradientNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isInsetShadowNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isLinearGradientNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isNullNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isOpacityNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isOutsetShadowNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isRadialGradientNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isRectangleNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isRepeatingLinearGradientNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isRoundedClipNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isShadowNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isTextNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isTextureNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isTransformNode [
	^ false
]

{ #category : #accessing }
FormSGNode >> morph [

	^ morph
]

{ #category : #accessing }
FormSGNode >> morph: anObject [

	morph := anObject
]

{ #category : #printing }
FormSGNode >> nodeTypeName [
	^ self class nodeTypeName
]

{ #category : #operation }
FormSGNode >> offsetPositionBy: aPoint [ 
	
	"Nothing to do"
]

{ #category : #printing }
FormSGNode >> printOn: aStream [
	aStream nextPutAll: self nodeTypeName
]

{ #category : #caches }
FormSGNode >> resetCaches [
	
	
]

{ #category : #accessing }
FormSGNode >> withAllChildren [
	
	^  { self } , (self children flatCollect: [:e | e withAllChildren])
]

{ #category : #enumerating }
FormSGNode >> withAllChildrenDo: aBlock [
	aBlock value: self.
	self allChildrenDo: aBlock.
]

{ #category : #enumerating }
FormSGNode >> withChildrenDo: aBlock [
	aBlock value: self.
	self childrenDo: aBlock
]
