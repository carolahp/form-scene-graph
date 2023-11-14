Class {
	#name : 'FormSGMorphOclusionAndClippingFilter',
	#superclass : 'Object',
	#category : 'FormSceneGraph-Morphic',
	#package : 'FormSceneGraph-Morphic'
}

{ #category : 'generation' }
FormSGMorphOclusionAndClippingFilter >> filterMorphs: morphs inVisibleRectangles: visibleRectangles [

	| alreadyDrawn unoclusedMorph visibleMorphs |
	alreadyDrawn := OrderedCollection new.
	visibleMorphs := OrderedCollection new.
	
	morphs do: [ :aMorph | 
		visibleRectangles do: [ :rect | |intersection|
			intersection := rect intersect: aMorph bounds.
			intersection isZero 
				ifFalse: [ visibleMorphs add: { aMorph. intersection } ]]].
	
	unoclusedMorph := OrderedCollection new.

	visibleMorphs do: [ :aPair | 
		(alreadyDrawn noneSatisfy: [ :aRectangle | 
			aRectangle containsRect: aPair second
			 ])
			ifTrue: [ 
				aPair first color isTranslucent 
					ifFalse: [ alreadyDrawn add: aPair second ].
				unoclusedMorph add: aPair first] ].

	^ unoclusedMorph
]
