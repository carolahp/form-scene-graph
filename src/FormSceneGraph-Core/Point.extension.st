Extension { #name : #Point }

{ #category : #'*FormSceneGraph-Core' }
Point >> random [
	
	^ (x * SharedRandom globalGenerator next) @ (y * SharedRandom globalGenerator next)
]
