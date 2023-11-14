"
I am a strategy to render text using Athens support.
I don't need to have Pango installed.
"
Class {
	#name : 'FormSGAthensTextRenderer',
	#superclass : 'Object',
	#category : 'FormSceneGraph-Renderer-Text',
	#package : 'FormSceneGraph-Renderer',
	#tag : 'Text'
}

{ #category : 'rendering' }
FormSGAthensTextRenderer >> renderTextNode: node on: canvas [

	| font rectangle topLeftTextPoint stringWidthOffset |
	font := node font.
	font ifNil: [ ^ self ].
	
	(font closeTo: 1.0) ifFalse: [
		font := font withSizeIncrementedBy: (font pointSize*node scale) - font pointSize
	].

	font := font realFont.
	
	rectangle := node rectangle.
	
	stringWidthOffset := font widthOfString: node string from: node firstIndex to: node lastIndex.
	
	"rectangle width trace. ' ' trace. 
	stringWidthOffset traceCr."
	
	font mutex criticalReleasingOnError: [
		canvas setFont: font.
		canvas setPaint: node color.
		topLeftTextPoint := rectangle topLeft + (0 @ font ascent).
		
		canvas clipBy: rectangle during: [  
			canvas pathTransform restoreAfter: [
				"canvas paintTransform loadIdentity".
				canvas pathTransform translateBy: topLeftTextPoint.
				canvas drawString: node string from: node firstIndex to: node lastIndex
			].
			
			(node underline or: [node strikethrough]) ifFalse: [ ^ self ].
			"stringWidthOffset := font widthOfString: node string from: node firstIndex to: node lastIndex."
			(node underline and: [ node underlineColor isTransparent not ]) ifTrue: [
				| underlineThickness underlineTop |
			 	underlineThickness := font underlineThickness asFloat.
				underlineTop := font underlineTop asFloat.
				canvas
					setPaint: node underlineColor;
					drawShape: (topLeftTextPoint + (0@underlineTop) extent: stringWidthOffset@underlineThickness)
			].

			(node strikethrough and: [ node strikethroughColor isTransparent not ]) ifTrue: [
				| strikeoutThickness strikeoutTop |
			 	strikeoutThickness := font strikeoutThickness asFloat.
				strikeoutTop := font strikeoutTop asFloat.
				canvas
					setPaint: node strikethroughColor;
					drawShape: (topLeftTextPoint + (0@strikeoutTop) extent: stringWidthOffset@strikeoutThickness)
			].
		].	
	].
	
]
