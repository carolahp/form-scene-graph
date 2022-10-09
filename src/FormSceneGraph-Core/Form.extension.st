Extension { #name : #Form }

{ #category : #'*FormSceneGraph-Core' }
Form >> asSurface [
	^ AthensCairoSurface fromForm: self
]

{ #category : #'*FormSceneGraph-Core' }
Form >> scaledByWorldScaleFactor [
	
	^ self scaledToSize: self extent * self currentWorld scaleFactor
]
