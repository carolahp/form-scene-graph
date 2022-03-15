Class {
	#name : #FormSGBuiltTreeTest,
	#superclass : #TestCase,
	#instVars : [
		'builder'
	],
	#category : #'FormSceneGraph-Core-Tests'
}

{ #category : #tests }
FormSGBuiltTreeTest >> buildGraphFor: morph [

	builder := FormSGBuilder new
						scale: 1;
						clippingRectangles: { morph bounds };
						yourself.

	^ morph buildFullSceneGraphWith: builder
]

{ #category : #tests }
FormSGBuiltTreeTest >> testColorMorphWithBorderReturnsBorder [

	| morph graph |
	morph := Morph new.
	morph borderColor: Color black.
	morph borderWidth: 5.
	morph color: Color red.
	
	graph := self buildGraphFor: morph.
	
	self assert: graph isBorderNode.
	self assert: graph content isRectangleNode.
	self assert: graph content color equals: Color red.

]

{ #category : #tests }
FormSGBuiltTreeTest >> testSimpleMorphReturnsColorRectangle [

	| morph graph |
	morph := Morph new.
	morph position: 0@0.
	
	graph := self buildGraphFor: morph.
	
	self assert: graph isRectangleNode.
	self assert: graph color equals: morph color.
	self assert: graph rectangle equals: morph bounds.
]

{ #category : #tests }
FormSGBuiltTreeTest >> testSimpleMorphReturnsColorRectangleNotAtOrigin [

	| morph graph |
	morph := Morph new.
	morph position: 50@50.
	
	graph := self buildGraphFor: morph.
	
	self assert: graph isRectangleNode.
	self assert: graph color equals: morph color.
	self assert: graph rectangle equals: morph bounds.
	self assert: graph rectangle origin equals: 50@50
]

{ #category : #tests }
FormSGBuiltTreeTest >> testTransformMorphWithOutTransformDoesNotAffectTree [

	| morph graph |
	
	morph := TransformMorph new.
	morph beTransparent.
	morph addMorph: Morph new.
	
	graph := self buildGraphFor: morph.

	self assert: graph isClipNode.
	self assert: graph rectangle equals: (0@0 extent: 50@40).
	self assert: graph child isRectangleNode.
	self assert: graph child rectangle equals: (0@0 extent: 50@40)
]

{ #category : #tests }
FormSGBuiltTreeTest >> testTransformMorphWithTranslationAffectsChilds [

	| morph graph |
	
	morph := TransformMorph new.
	morph transform setOffset: 20@20.
	morph beTransparent.
	morph addMorph: Morph new.	
	
	graph := self buildGraphFor: morph.

	self assert: graph isClipNode.
	self assert: graph rectangle equals: (0@0 corner: 50@40).
	self assert: graph child isRectangleNode.
	self assert: graph child rectangle equals: (-20@(-20) corner: 30@20)
]

{ #category : #tests }
FormSGBuiltTreeTest >> testTransparentMorphWithBorderReturnsBorder [

	| morph graph |
	morph := Morph new.
	morph borderColor: Color black.
	morph borderWidth: 5.
	morph color: Color transparent.

	graph := self buildGraphFor: morph.
	
	self assert: graph isBorderNode.
	self assert: graph content isNullNode.

]
