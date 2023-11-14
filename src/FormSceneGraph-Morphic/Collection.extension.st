Extension { #name : 'Collection' }

{ #category : '*FormSceneGraph-Morphic' }
Collection >> reduceRectangles [

	^ self inject: OrderedCollection new into: [ :a :e | 
		  a
			  detect: [ :x | e containsRect: x ]
			  ifFound: [ :x | 
				  a remove: x.
				  a add: e ]
			  ifNone: [ 
			  (a anySatisfy: [ :x | x containsRect: e ]) ifFalse: [ a add: e ] ].
		  a ]
]
