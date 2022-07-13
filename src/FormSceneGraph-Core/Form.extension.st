Extension { #name : #Form }

{ #category : #'*FormSceneGraph-Core' }
Form >> asSurface [
	^ AthensCairoSurface fromForm: self
]
