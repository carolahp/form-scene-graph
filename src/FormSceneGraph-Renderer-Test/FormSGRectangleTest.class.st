Class {
	#name : #FormSGRectangleTest,
	#superclass : #TestCase,
	#category : #'FormSceneGraph-Renderer-Test'
}

{ #category : #tests }
FormSGRectangleTest >> testColorMorphWithBorderReturnsBorder [

	| morph builder graph |
	morph := Morph new.
	morph borderColor: Color black.
	morph borderWidth: 5.
	morph color: Color red.
	
	builder := FormSGBuilder extent: 500@500.
	
	graph := morph doBuildFullSceneGraphWith: builder.
	
	self assert: graph isBorderNode.
	self assert: graph content isRectangleNode.
	self assert: graph content color equals: Color red.

]

{ #category : #tests }
FormSGRectangleTest >> testScalingRectangleNodeReturnsScaledRectangleNode [

	| rect visitor newRect |
	rect := FormSGColorRectangleNode new 
			color: Color blue;
			rectangle: (60@20 corner: 100@100);
			yourself.
			
	visitor := FormSGScaleVisitor new
		scaleFactor: 2.0;
		yourself.
	
	newRect := rect accept: visitor.
	
	self assert: newRect rectangle origin equals: 120@40.
	self assert: newRect rectangle corner equals: 200@200.	
]

{ #category : #tests }
FormSGRectangleTest >> testSimpleMorphReturnsColorRectangle [

	| morph builder graph |
	morph := Morph new.
	morph position: 0@0.
	
	builder := FormSGBuilder extent: 500@500.
	
	graph := morph doBuildFullSceneGraphWith: builder.
	
	self assert: graph isRectangleNode.
	self assert: graph color equals: morph color.
	self assert: graph rectangle equals: morph bounds.
]

{ #category : #tests }
FormSGRectangleTest >> testSimpleMorphReturnsColorRectangleNotAtOrigin [

	| morph builder graph |
	morph := Morph new.
	morph position: 50@50.
	
	builder := FormSGBuilder extent: 500@500.
	
	graph := morph doBuildFullSceneGraphWith: builder.
	
	self assert: graph isRectangleNode.
	self assert: graph color equals: morph color.
	self assert: graph rectangle equals: morph bounds.
	self assert: graph rectangle origin equals: 50@50
]

{ #category : #tests }
FormSGRectangleTest >> testTransparentMorphWithBorderReturnsBorder [

	| morph builder graph |
	morph := Morph new.
	morph borderColor: Color black.
	morph borderWidth: 5.
	morph color: Color transparent.
	
	builder := FormSGBuilder extent: 500@500.
	
	graph := morph doBuildFullSceneGraphWith: builder.
	
	self assert: graph isBorderNode.
	self assert: graph content isNullNode.

]
