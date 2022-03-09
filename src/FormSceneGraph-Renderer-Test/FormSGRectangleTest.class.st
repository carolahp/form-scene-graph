Class {
	#name : #FormSGRectangleTest,
	#superclass : #TestCase,
	#category : #'FormSceneGraph-Renderer-Test'
}

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
